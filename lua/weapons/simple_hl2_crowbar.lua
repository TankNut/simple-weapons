AddCSLuaFile()

SWEP.Base = "simple_base_melee"

SWEP.PrintName = "Crowbar"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 0

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelFOV = 54

SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.HoldType = "melee"
SWEP.LowerHoldType = "normal"

SWEP.Primary = {
	ChargeTime = 0.4,

	Light = {
		Damage = 24,
		DamageType = DMG_CLUB,

		Range = 75,
		Delay = 0.4,

		Act = {ACT_VM_HITCENTER, ACT_VM_MISSCENTER},

		Sound = {"Weapon_Crowbar.Melee_Hit", "Weapon_Crowbar.Single"}
	},

	Heavy = {
		Damage = 40,
		DamageType = DMG_CLUB,

		Range = 100,
		Delay = 1,

		Act = ACT_VM_MISSCENTER,

		Sound = {"Weapon_Crowbar.Melee_Hit", "Weapon_Crowbar.Single"}
	}
}

SWEP.ChargeOffset = {
	Pos = Vector(-15, 0, -10),
	Ang = Angle(-35)
}
