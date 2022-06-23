AddCSLuaFile()

simple_weapons.Include("Convars")

function SWEP:GetDelay()
	local firemode = self:GetFiremode()

	-- Basic support for burst fire
	if firemode > 0 then
		if self:GetBurstFired() == 0 and self.Primary.BurstEndDelay != 0 then
			return self.Primary.BurstEndDelay
		elseif self.Primary.BurstDelay != 0 then
			return self.Primary.BurstDelay
		end
	end

	local delay = self.Primary.Delay

	if delay == -1 then
		delay = self:SequenceDuration()
	end

	return delay
end

function SWEP:UpdateAutomatic()
	local primary = self.Primary
	local firemode = self:GetFiremode()

	if firemode == -1 then
		primary.Automatic = true
	elseif firemode == 0 then
		primary.Automatic = false
	else
		local count = self:GetBurstFired()

		if count + 1 >= firemode then
			primary.Automatic = false

			self:SetBurstFired(0)
		else
			primary.Automatic = true

			self:SetBurstFired(count + 1)
		end
	end
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
end

function SWEP:GetDamage()
	return self.Primary.Damage * DamageMult:GetFloat()
end

function SWEP:GetDamageFalloff(distance)
	local distMod = 1000 * Falloff:GetFloat()

	return math.max(self.Primary.RangeModifier ^ (distance / distMod), MinDamage:GetFloat())
end

function SWEP:GetSpread()
	local range = self.Primary.Range * RangeMult:GetFloat()

	local inches = self.Primary.Accuracy / 0.75
	local yards = (range / 0.75) / 36
	local MOA = (inches * 100) / yards

	local spread = math.rad(MOA / 60)

	return Vector(spread * 0.5, spread, 0)
end

function SWEP:FireWeapon()
	local ply = self:GetOwner()
	local primary = self.Primary

	self:EmitFireSound()

	self:SendTranslatedWeaponAnim(ACT_VM_PRIMARYATTACK)

	ply:SetAnimation(PLAYER_ATTACK1)

	local bullet = {
		Num = primary.Count,
		Src = ply:GetShootPos(),
		Dir = (ply:GetAimVector():Angle() + ply:GetViewPunchAngles()):Forward(),
		Spread = self:GetSpread(),
		TracerName = primary.TracerName,
		Tracer = primary.TracerName == "" and 0 or 1,
		Force = 5,
		Damage = self:GetDamage(),
		Callback = function(attacker, tr, dmginfo)
			dmginfo:ScaleDamage(self:GetDamageFalloff(tr.StartPos:Distance(tr.HitPos)))
		end
	}

	self:ModifyBulletTable(bullet)

	ply:FireBullets(bullet)
end

function SWEP:ModifyBulletTable(bullet)
end

function SWEP:CanAlternateAttack()
	return true
end

function SWEP:AlternateAttack()
end

function SWEP:ShouldPump()
	return self.Primary.PumpAction
end
