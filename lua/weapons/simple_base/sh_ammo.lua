AddCSLuaFile()

simple_weapons.Include("Convars")
simple_weapons.Include("Enums")

function SWEP:GetAmmoType()
	if self.Primary.Ammo == "" and self.Primary.ClipSize == -1 then
		return AMMO_NONE
	elseif self.Primary.Ammo == "" then
		return AMMO_INTERNAL
	elseif self.Primary.ClipSize == -1 then
		return AMMO_NOMAG
	else
		return AMMO_NORMAL
	end
end

function SWEP:ConsumeAmmo()
	if self.AmmoType == AMMO_NONE then
		return
	elseif self.AmmoType == AMMO_NORMAL and InfiniteAmmo:GetInt() == 2 then
		return
	elseif self.AmmoType == AMMO_NOMAG and InfiniteAmmo:GetInt() != 0 then
		return
	end

	local primary = self.Primary
	local cost = primary.Cost
	local ply = self:GetOwner()

	if self.AmmoType == AMMO_NOMAG then
		cost = math.min(cost, ply:GetAmmoCount(primary.Ammo))

		ply:RemoveAmmo(cost, primary.Ammo)
	else
		self:TakePrimaryAmmo(math.min(cost, self:Clip1()))
	end
end

function SWEP:GetAmmo()
	if self.AmmoType == AMMO_NORMAL or self.AmmoType == AMMO_INTERNAL then
		return self:Clip1()
	elseif self.AmmoType == AMMO_NOMAG then
		return self:GetOwner():GetAmmoCount(self.Primary.Ammo)
	end

	return 1
end
