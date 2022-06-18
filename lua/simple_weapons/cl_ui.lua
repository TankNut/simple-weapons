hook.Add("PopulateToolMenu", "simple_weapons", function()
	spawnmenu.AddToolMenuOption("Utilities", "Simple Weapons", "simple_weapons_cl", "Client", "", "", function(pnl)
		pnl:ClearControls()

		pnl:Help("Client Settings. These settings save automatically.")

		local default = {}

		for _, v in pairs(simple_weapons.Convars) do
			if TypeID(v) != TYPE_CONVAR or v:IsFlagSet(FCVAR_REPLICATED) then
				continue
			end

			default[v:GetName()] = v:GetDefault()
		end

		pnl:AddControl("ComboBox", {MenuButton = 1, Folder = "simple_weapons_cl", Options = {["Default"] = default}, CVars = table.GetKeys(default)})

		pnl:CheckBox("Auto reload when empty", "simple_weapons_auto_reload")

		pnl:Help("Viewmodel Offset")

		pnl:NumSlider("X offset (Forward)", "simple_weapons_vm_offset_x", -10, 10, 2)
		pnl:NumSlider("Y offset (Side)", "simple_weapons_vm_offset_y", -10, 10, 2)
		pnl:NumSlider("Z offset (Up)", "simple_weapons_vm_offset_z", -10, 10, 2)
	end)

	spawnmenu.AddToolMenuOption("Utilities", "Simple Weapons", "simple_weapons_sv", "Server", "", "", function(pnl)
		pnl:ClearControls()

		pnl:Help("Server Settings. These settings can only be changed by the person who created the game server through the main menu.")

		local default = {}

		for _, v in pairs(simple_weapons.Convars) do
			if TypeID(v) != TYPE_CONVAR then
				continue
			end

			default[v:GetName()] = v:GetDefault()
		end

		pnl:AddControl("ComboBox", {MenuButton = 1, Folder = "simple_weapons_sv", Options = {["Default"] = default}, CVars = table.GetKeys(default)})

		pnl:NumSlider("Ready time", "simple_weapons_ready_time", 0, 1, 1)

		pnl:AddControl("ComboBox", {
			Label = "Infinite Ammo",
			MenuButton = 0,
			CVars = {"simple_weapons_infinite_ammo"},
			Options = {
				["1. Disabled"] = {simple_weapons_infinite_ammo = 0},
				["2. Enabled"] = {simple_weapons_infinite_ammo = 1},
				["3. Bottomless magazines"] = {simple_weapons_infinite_ammo = 2}
			}
		})

		pnl:NumSlider("Damage multiplier", "simple_weapons_damage_mult", 0.1, 4, 1)
		pnl:NumSlider("Spread multiplier", "simple_weapons_spread_mult", 0, 4, 1)
		pnl:NumSlider("Recoil multiplier", "simple_weapons_recoil_mult", 0, 2, 1)
	end)
end)
