AddCSLuaFile()

simple_weapons.Include("Convars")

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

function SWEP:GetSpread(range, accuracy)
	local range2, accuracy2 = self:GetRange()

	range = range or range2
	accuracy = accuracy or accuracy2

	local inches = accuracy / 0.75
	local yards = (range / 0.75) / 36
	local MOA = (inches * 100) / yards

	local spread = math.rad(MOA / 60)

	return Vector(spread, spread, 0)
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

function SWEP:CanAlternateAttack()
	return true
end

function SWEP:AlternateAttack()
end

function SWEP:ShouldPump()
	return self.Primary.PumpAction
end
