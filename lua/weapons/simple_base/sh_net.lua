AddCSLuaFile()

if SERVER then
	util.AddNetworkString("simple_set_firemode")
	util.AddNetworkString("simple_set_ammo")

	net.Receive("simple_set_firemode", function(_, ply)
		local weapon = ply:GetActiveWeapon()

		if not IsValid(weapon) or not weapon.SimpleWeapon then
			return
		end

		local index = net.ReadUInt(3)

		if not istable(weapon.Firemodes) or not weapon.Firemodes[index] then
			return
		end

		weapon:SetFiremode(weapon.Firemodes[index])
		weapon:EmitSound("Weapon_SMG1.Special1")
	end)

	net.Receive("simple_set_ammo", function(_, ply)
		local weapon = ply:GetActiveWeapon()

		if not IsValid(weapon) or not weapon.SimpleWeapon then
			return
		end

		local index = net.ReadUInt(4)

		if index != 0 and not weapon.AmmoTypes[index] then
			return
		end

		weapon:SetAmmoType(index)
	end)
end
