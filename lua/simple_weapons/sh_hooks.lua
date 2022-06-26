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

hook.Add("Think", "simple_base", function()
	for _, ply in pairs(player.GetAll()) do
		if CLIENT and ply != LocalPlayer() then
			continue
		end

		ply._ActiveWeapon = ply:GetActiveWeapon()

		local oldWeapon = ply._LastActiveWeapon
		local newWeapon = ply._ActiveWeapon

		if not oldWeapon or oldWeapon != newWeapon then
			if IsValid(oldWeapon) and oldWeapon.SimpleWeapon then
				oldWeapon:OnHolster(false, ply)
			end

			if IsValid(newWeapon) and newWeapon.SimpleWeapon then
				newWeapon:OnDeploy()
			end
		end

		ply._LastActiveWeapon = newWeapon
	end
end)
