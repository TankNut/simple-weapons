AddCSLuaFile()

-- Boilerplate lines, required for anything to work at all.

DEFINE_BASECLASS("simple_base_melee")

SWEP.Base = "simple_base_melee"

-- UI stuff

SWEP.PrintName = "Melee template" -- The weapon's name used in the spawn menu and HUD
SWEP.Category = "Simple Weapons: Custom" -- The category the weapon will appear in, recommended you use your own if making a pack

SWEP.Slot = 0 -- The slot the weapon will appear in when switching weapons, add 1 to get the actual slot (e.g. a value of 0 translates to weapon slot 1, the melee slots)

SWEP.Spawnable = false -- Set this to true to make your weapon appear in the spawnmenu, set to false to hide the template

SWEP.UseHands = true -- If your viewmodel includes it's own hands (v_ model instead of a c_ model), set this to false

-- Appearance

SWEP.ViewModelFOV = 54 -- The default FOV used for the viewmodel

SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl") -- Weapon viewmodel, usually a c_ or v_ model
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl") -- Weapon worldmodel, almost always a w_ model

SWEP.HoldType = "melee" -- Default holdtype, you can find all the options here: https://wiki.facepunch.com/gmod/Hold_Types
SWEP.LowerHoldType = "normal" -- Ditto, used when a weapon is lowered

-- Weapon stats

SWEP.Primary = {
	AutoSwing = true, -- Whether finishing a swing requires you to release the mouse button before queueing up another one
	ChargeTime = 0.4, -- The time a player needs to hold down attack to set up a heavy attack, if set to 0 will disable heavy attacks alltogether

	-- Light attacks
	Light = {
		Damage = 24, -- Damage dealt per hit
		DamageType = DMG_CLUB, -- Damage type dealt, only DMG_CLUB seems to correctly add all the effects

		Range = 75, -- Attack range
		Delay = 0.4, -- Cooldown between attacks, set to -1 to use animation duration instead

		Act = {ACT_VM_HITCENTER, ACT_VM_MISSCENTER}, -- Viewmodel animations to use, can be one value or a table for hit and miss respectively

		Sound = {"Weapon_Crowbar.Melee_Hit", "Weapon_Crowbar.Single"} -- Sound to use when attacking, can be one value or a table for hit and miss respectively
	},

	-- Heavy attacks, only applicable when ChargeTime > 0, vars are identical to light attacks otherwise
	Heavy = {
		Damage = 40,
		DamageType = DMG_CLUB,

		Range = 100,
		Delay = 1,

		Act = ACT_VM_MISSCENTER,

		Sound = {"Weapon_Crowbar.Melee_Hit", "Weapon_Crowbar.Single"}
	}
}

SWEP.ChargeOffset = { -- View offset to use when charging
	Pos = Vector(-15, 0, -10),
	Ang = Angle(-35)
}
