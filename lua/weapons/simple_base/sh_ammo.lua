AddCSLuaFile()

simple_weapons.Include("Convars")
simple_weapons.Include("Ammo")

function SWEP:SetAmmoType(index)
	if self:IsReloading() then
		return
	end

	local id

	if index != 0 then
		id = self.AmmoTypes[index]

		if not id or not Ammo[id] or not HasAmmo(self:GetOwner(), id) then
			return
		end
	end

	local current = self:GetAmmoIndex()

	if current != index then
		if SERVER and InfiniteAmmo:GetInt() == 0 then
			self:GetOwner():GiveAmmo(self:Clip1(), self.Primary.Ammo)
		end

		self:SetClip1(0)
	end

	if current != 0 then
		self:ResetWeaponStats()
	end

	if index != 0 then
		local tab = CreateAmmoTable()

		Ammo[id].Callback(self, tab)

		self:SetWeaponStats(tab)
	end

	self:SetAmmoIndex(index)

	if current != index then
		self:SuppressOwner(true)
		self:Reload()
		self:SuppressOwner(false)

		if self.Primary.PumpAction then
			self:SetNeedPump(true)
		end
	end
end

local function setRecursive(target, store, tab)
	for k, v in pairs(tab) do
		if k == "BaseClass" then
			continue
		end

		if istable(target[k]) then
			setRecursive(target[k], store[k], v)
		else
			store[k] = target[k] == nil and TYPE_NIL or target[k]
			target[k] = v
		end
	end
end

function SWEP:SetWeaponStats(tab)
	self.StoredAmmoStats = table.Copy(tab)

	setRecursive(self, self.StoredAmmoStats, tab)
end

local function resetRecursive(target, tab)
	for k, v in pairs(tab) do
		if k == "BaseClass" then
			continue
		end

		if istable(target[k]) then
			resetRecursive(target[k], v)
		else
			if v == TYPE_NIL then
				target[k] = nil
			else
				target[k] = v
			end
		end
	end
end

function SWEP:ResetWeaponStats()
	resetRecursive(self, self.StoredAmmoStats)
end
