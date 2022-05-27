AddCSLuaFile()

hook.Add("SetupMove", "simple_base", function(ply, mv)
	local weapon = ply:GetActiveWeapon()

	if not IsValid(weapon) or not weapon.SimpleWeapon then
		return
	end

	local fraction = weapon:GetEasedLowerFraction()
	local speed = math.Remap(fraction, 0, 1, ply:GetWalkSpeed(), mv:GetMaxClientSpeed())

	mv:SetMaxClientSpeed(speed)
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
				oldWeapon:OnHolster(false)
			end

			if IsValid(newWeapon) and newWeapon.SimpleWeapon then
				newWeapon:OnDeploy()
			end
		end

		ply._LastActiveWeapon = newWeapon
	end
end)
