REALM_CLIENT = 1
REALM_SERVER = 2

function simple_weapons.CreateOptionsMenu(realm, identifier, name, convars, callback)
	local category = "Options"
	local header = "Simple - "
	local helpText = ""
	local check

	if realm == REALM_CLIENT then
		header = header .. "Client"
		helpText = "Client Settings. These settings save automatically."
		check = function(convar) return TypeID(convar) == TYPE_CONVAR and convar:IsFlagSet(FCVAR_LUA_CLIENT) end
	else
		header = header .. "Server"
		helpText = "Server Settings. These settings can only be changed by the person who created the game server through the main menu."
		check = function(convar) return TypeID(convar) == TYPE_CONVAR and convar:IsFlagSet(FCVAR_LUA_SERVER) end
	end

	spawnmenu.AddToolMenuOption(category, header, identifier, name, "", "", function(pnl)
		pnl:ClearControls()
		pnl:Help(helpText)

		local default = {}

		for _, v in pairs(convars) do
			if not check(v) then
				continue
			end

			default[v:GetName()] = v:GetDefault()
		end

		pnl:AddControl("ComboBox", {MenuButton = 1, Folder = identifier, Options = {["Default"] = default}, CVars = table.GetKeys(default)})

		callback(pnl)
	end)
end

hook.Add("PopulateToolMenu", "simple_weapons", function()
	simple_weapons.CreateOptionsMenu(REALM_CLIENT, "simple_weapons_cl", "Base", simple_weapons.Convars, function(pnl)
		pnl:CheckBox("Disable left click raising", "simple_weapons_disable_raise")

		pnl:CheckBox("Auto reload when empty", "simple_weapons_auto_reload")

		pnl:NumSlider("Aim focus (zoom)", "simple_weapons_zoom", 1, 1.5, 2)

		pnl:CheckBox("Draw scopes", "simple_weapons_scopes")

		pnl:Help("")
		pnl:Help("Viewmodel Settings")

		pnl:NumSlider("Viewmodel sway", "simple_weapons_swayscale", 0, 3, 2)
		pnl:NumSlider("Viewmodel bob", "simple_weapons_bobscale", 0, 3, 2)

		pnl:Help("")
		pnl:Help("Viewmodel Offset")

		pnl:NumSlider("X offset (Forward)", "simple_weapons_vm_offset_x", -10, 10, 2)
		pnl:NumSlider("Y offset (Side)", "simple_weapons_vm_offset_y", -10, 10, 2)
		pnl:NumSlider("Z offset (Up)", "simple_weapons_vm_offset_z", -10, 10, 2)
	end)

	simple_weapons.CreateOptionsMenu(REALM_SERVER, "simple_weapons_sv", "Base", simple_weapons.Convars, function(pnl)
		pnl:Help("When enabled classic mode will disable the limited movement and raise/lower system.")
		pnl:CheckBox("Classic mode", "simple_weapons_classic_mode")

		pnl:CheckBox("Replace weapons", "simple_weapons_replace_weapons")

		pnl:NumSlider("Ready time", "simple_weapons_ready_time", 0, 1, 1)

		pnl:CheckBox("Limit player movement", "simple_weapons_limit_movement")

		pnl:NumSlider("Walk speed limit", "simple_weapons_walk_speed", 100, 200, 1)

		pnl:CheckBox("Allow reloading while lowered", "simple_weapons_lowered_reloads")

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
		pnl:NumSlider("NPC Damage multiplier", "simple_weapons_npc_damage_mult", 0.1, 2, 1)
		pnl:NumSlider("Range multiplier", "simple_weapons_range_mult", 0, 4, 1)
		pnl:NumSlider("Recoil multiplier", "simple_weapons_recoil_mult", 0, 2, 1)

		pnl:Help("Weapons will always do at least this much damage regardless of the distance they're fired at.")
		pnl:NumSlider("Minimum damage", "simple_weapons_min_damage", 0, 1, 2)

		pnl:NumSlider("Damage falloff modifier", "simple_weapons_falloff_mult", 0.01, 10, 2)
	end)
end)
