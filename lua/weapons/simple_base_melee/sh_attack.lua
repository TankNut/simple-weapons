AddCSLuaFile()

simple_weapons.Include("Convars")

function SWEP:GetDelay(heavy, hit, trace)
	local tab = heavy and self.Primary.Heavy or self.Primary.Light

	if istable(tab.Delay) then
		return hit and tab.Delay[1] or tab.Delay[2]
	end

	return tab.Delay
end

function SWEP:GetAttackAct(heavy, hit, trace)
	local tab = heavy and self.Primary.Heavy or self.Primary.Light

	if istable(tab.Act) then
		return hit and tab.Act[1] or tab.Act[2]
	end

	return tab.Act
end

function SWEP:PlayAttackSound(heavy, hit, trace)
	local tab = heavy and self.Primary.Heavy or self.Primary.Light
	local snd = tab.Sound

	if istable(snd) then
		if snd[3] and trace.HitWorld then
			snd = snd[3]
		else
			snd = hit and snd[1] or snd[2]
		end
	end

	if snd != "" then
		self:EmitSound(snd)
	end
end

function SWEP:GetDamage(heavy, trace)
	local tab = heavy and self.Primary.Heavy or self.Primary.Light

	return tab.Damage * DamageMult:GetFloat(), tab.DamageType
end

function SWEP:HandleCharge()
	if game.SinglePlayer() and CLIENT then
		return
	end

	local charge = self:GetChargeTime()

	if charge > 0 and not self:GetOwner():KeyDown(IN_ATTACK) then
		local primary = self.Primary
		local time = CurTime() - charge

		if time < engine.TickInterval() then
			return
		end

		if primary.ChargeTime > 0 and time > primary.ChargeTime then
			self:HeavyAttack()
		else
			self:LightAttack()
		end

		self:SetChargeTime(0)

		self.Primary.Automatic = self.Primary.AutoSwing
	end
end

function SWEP:RefineHullTrace(trace, result)
	local distance = math.huge
	local endpos = result.StartPos + (result.HitPos - result.StartPos) * 2

	trace.start = result.StartPos
	trace.endpos = endpos

	local tr = result
	local temp = util.TraceLine(trace)

	if temp.Hit then
		return temp
	end

	for i = -1, 1, 2 do
		for j = -1, 1, 2 do
			for k = -1, 1, 2 do
				local vec = Vector(
					endpos.x + (16 * i),
					endpos.y + (16 * j),
					endpos.z + (16 * k)
				)

				trace.endpos = vec

				temp = util.TraceLine(trace)

				if temp.Hit then
					local dist = (tr.HitPos - tr.StartPos):Length()

					if dist < distance then
						tr = temp
						distance = dist
					end
				end
			end
		end
	end

	return tr
end

-- Basically a copy of CWeaponSDKMelee::Swing()'s trace code
function SWEP:GetAttackTrace(range)
	local ply = self:GetOwner()

	local start = ply:GetShootPos()
	local forward = ply:GetAimVector()

	local endpos = start + forward * range

	local trace = {
		start = start,
		endpos = endpos,
		mins = Vector(-16, -16, -16),
		maxs = Vector(16, 16, 16),
		mask = MASK_SHOT_HULL,
		filter = ply,
		collisiongroup = COLLISION_GROUP_NONE
	}

	local tr = util.TraceLine(trace)

	if tr.Hit then
		return true, tr
	end

	trace.endpos = trace.endpos - forward * 1.732 * 16

	tr = util.TraceHull(trace)

	if tr.Hit and IsValid(tr.Entity) then
		local vec = (tr.Entity:GetPos() - start):GetNormalized()

		if vec:Dot(forward) < math.rad(0.70721) then
			return false, tr
		end

		return true, self:RefineHullTrace(table.Copy(trace), tr)
	end

	return false, tr
end

function SWEP:LightAttack()
	self:GenericAttack(false)
end

function SWEP:HeavyAttack()
	self:GenericAttack(true)
end

function SWEP:GenericAttack(heavy)
	local tab = heavy and self.Primary.Heavy or self.Primary.Light
	local ply = self:GetOwner()

	ply:LagCompensation(true)

	local hit, trace = self:GetAttackTrace(tab.Range)

	ply:LagCompensation(false)

	ply:SetAnimation(PLAYER_ATTACK1)

	if hit and SERVER then
		local dmg = DamageInfo()

		local damage, damageType = self:GetDamage(heavy, trace)

		dmg:SetDamage(damage)
		dmg:SetDamageType(damageType)

		dmg:SetInflictor(self)
		dmg:SetAttacker(self:GetOwner())

		dmg:SetDamagePosition(trace.HitPos)
		dmg:SetDamageForce(trace.Normal * (tab.Damage * 300))

		if bit.band(util.PointContents(trace.HitPos), CONTENTS_WATER) == 0 then
			local effect = EffectData()

			effect:SetEntity(trace.Entity)
			effect:SetOrigin(trace.HitPos)
			effect:SetStart(trace.StartPos)
			effect:SetSurfaceProp(trace.SurfaceProps)
			effect:SetDamageType(damageType)
			effect:SetHitBox(trace.HitBox)

			util.Effect("Impact", effect, false, true)
		end

		if IsValid(trace.Entity) then
			trace.Entity:DispatchTraceAttack(dmg, trace)
		end
	end

	self:WaterImpact(trace.StartPos, trace.HitPos)

	self:SendTranslatedWeaponAnim(self:GetAttackAct(heavy, hit))
	self:SetNextIdle(CurTime() + self:SequenceDuration())

	self:PlayAttackSound(heavy, hit, trace)

	local delay = self:GetDelay(heavy, hit)

	if delay == -1 then
		delay = self:SequenceDuration()
	end

	self:SetNextPrimaryFire(CurTime() + delay)

	return hit, trace
end

function SWEP:WaterImpact(start, endpos)
	local flags = bit.bor(CONTENTS_WATER, CONTENTS_SLIME)

	if bit.band(util.PointContents(start), flags) != 0 then
		return
	end

	if bit.band(util.PointContents(endpos), flags) == 0 then
		return
	end

	local tr = util.TraceLine({
		start = start,
		endpos = endpos,
		mask = flags,
		filter = self:GetOwner(),
		collisiongroup = COLLISION_GROUP_NONE
	})

	if tr.Hit then
		local data = EffectData()

		data:SetFlags(bit.band(tr.Contents, CONTENTS_SLIME) == 0 and 0 or 1)
		data:SetOrigin(tr.HitPos)
		data:SetNormal(tr.HitNormal)
		data:SetScale(8)

		util.Effect("watersplash", data, false, true)
	end
end
