AddCSLuaFile()

simple_weapons.Include("Convars")

hook.Add("SetupMove", "simple_base", function(ply, mv)
	if not LimitMovement:GetBool() then
		return
	end

	local weapon = ply:GetActiveWeapon()

	if not IsValid(weapon) or not weapon.SimpleWeapon then
		return
	end

	if not weapon.SetupMove then
		return
	end

	weapon:SetupMove(ply, mv)
end)

if CLIENT then
	hook.Add("PostDrawTranslucentRenderables", "simple_base", function(depth, skybox, skybox3d)
		if skybox or skybox3d then
			return
		end

		for _, ply in ipairs(player.GetAll()) do
			if ply:IsDormant() or ply:InVehicle() then
				continue
			end

			local weapon = ply:GetActiveWeapon()

			if not IsValid(weapon) or weapon:IsDormant() or not weapon.SimpleWeapon then
				continue
			end

			if not weapon.PostDrawTranslucentRenderables then
				continue
			end

			weapon:PostDrawTranslucentRenderables()
		end
	end)
else
	local key = {
		["weapon_crowbar"] = "simple_hl2_crowbar",
		["weapon_stunstick"] = "simple_hl2_stunstick",
		["weapon_pistol"] = "simple_hl2_pistol",
		["weapon_357"] = "simple_hl2_357",
		["weapon_smg1"] = "simple_hl2_smg1",
		["weapon_ar2"] = "simple_hl2_ar2",
		["weapon_shotgun"] = "simple_hl2_shotgun",
		["weapon_crossbow"] = "simple_hl2_crossbow",
		["weapon_frag"] = "simple_hl2_frag",
		["weapon_rpg"] = "simple_hl2_rpg"
	}

	local isGiving = false

	hook.Add("PlayerGiveSWEP", "simple_base", function(ply, weapon)
		local replacement = key[weapon]

		isGiving = ReplaceWeapons:GetBool() and replacement
	end)

	hook.Add("PlayerCanPickupWeapon", "simple_base", function(ply, weapon)
		local replacement = key[weapon:GetClass()]

		if weapon.IgnorePickup then -- For whatever reason, PlayerCanPickupWeapon is called multiple times if we return false, even when removing the original weapon
			return false
		end

		if ReplaceWeapons:GetBool() and replacement then
			local swep = weapons.Get(replacement)
			local new = ply:Give(replacement)

			if not isGiving and not IsValid(new) and swep.Primary.Ammo != "" then -- Picked up a weapon that we already have from the ground and has ammo
				local amount = swep.Primary.DefaultClip

				if swep.SimpleWeaponThrowing then
					amount = 1 -- Grenades don't use ammo the 'normal' way
				end

				ply:GiveAmmo(amount, swep.Primary.Ammo)
			end

			weapon.IgnorePickup = true
			weapon:Remove()

			if isGiving then -- Otherwise we won't auto-select replaced weapons
				ply:SelectWeapon(replacement)

				isGiving = false
			end

			return false
		end
	end)
end
