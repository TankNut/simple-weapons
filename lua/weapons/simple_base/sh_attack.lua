AddCSLuaFile()

simple_weapons.Include("Convars")

-- Primary fire
function SWEP:CanPrimaryFire()
	if self:HandleAutoRaise() or self:HandleReloadAbort() then
		return false
	end

	if self:IsEmpty() then
		local ply = self:GetOwner()

		if ply:IsNPC() then
			if SERVER then
				ply:SetSchedule(SCHED_RELOAD) -- Metropolice don't like reloading...
			end

			return false
		end

		if ply:GetInfoNum("simple_weapons_auto_reload", 0) == 1 and self:GetBurstFired() == 0 then
			self:Reload()
		end

		if not self:IsReloading() then
			self:EmitEmptySound()
		end

		self:SetNextFire(CurTime() + 0.2)
		self:ForceStopFire()

		return false
	end

	return true
end

function SWEP:PrimaryFire()
	self:UpdateAutomatic()
	self:ConsumeAmmo()

	self:FireWeapon()

	local delay = self:GetDelay()

	self:ApplyRecoil()

	if self:ShouldPump() then
		self:SetNeedPump(true)
	end

	self:SetNextIdle(CurTime() + self:SequenceDuration())
	self:SetNextFire(CurTime() + delay)
end

-- Alt fire
function SWEP:TryAltFire()
	if self:GetNextAltFire() > CurTime() or not self:CanAltFire() then
		return
	end

	self:AltFire()
end

function SWEP:CanAltFire()
	return true
end

function SWEP:AltFire()
end

function SWEP:UpdateAutomatic()
	local primary = self.Primary
	local firemode = self:GetFiremode()

	if firemode == 0 then
		primary.Automatic = false
	else
		primary.Automatic = true
	end

	if firemode > 0 then
		local count = self:GetBurstFired()

		if count + 1 >= firemode then
			self:ForceStopFire()
			self:SetBurstFired(0)
		else
			self:SetBurstFired(count + 1)
		end
	end
end

function SWEP:FireWeapon()
	local ply = self:GetOwner()
	local primary = self.Primary

	self:EmitFireSound()

	self:SendTranslatedWeaponAnim(ACT_VM_PRIMARYATTACK)

	ply:SetAnimation(PLAYER_ATTACK1)

	local damage = self:GetDamage()

	local bullet = {
		Num = primary.Count,
		Src = ply:GetShootPos(),
		Dir = self:GetShootDir(),
		Spread = self:GetSpread(),
		TracerName = primary.TracerName,
		Tracer = primary.TracerName == "" and 0 or primary.TracerFrequency,
		Force = damage * 0.25,
		Damage = damage,
		Callback = function(attacker, tr, dmginfo)
			dmginfo:ScaleDamage(self:GetDamageFalloff(tr.StartPos:Distance(tr.HitPos)))
		end
	}

	self:ModifyBulletTable(bullet)

	ply:FireBullets(bullet)
end

function SWEP:ModifyBulletTable(bullet)
end

function SWEP:ShouldPump()
	return self.Primary.PumpAction
end
