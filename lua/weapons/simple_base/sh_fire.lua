AddCSLuaFile()

function SWEP:GetDelay(firemode)
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

function SWEP:GetSpread()
	local spread = self.Primary.Spread

	return Vector(math.rad(spread.x) * 0.5, math.rad(spread.y), 0) * SpreadMult:GetFloat()
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
		Damage = self:GetDamage()
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
