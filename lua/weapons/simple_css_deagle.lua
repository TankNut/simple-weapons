AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "Desert Eagle"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.Slot = 1
SWEP.SlotPos = 14

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_deagle.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_deagle.mdl")

SWEP.HoldType = "revolver"
SWEP.LowerHoldType = "normal"

SWEP.Firemodes = 0

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "357",

	ClipSize = 7,
	DefaultClip = 7,

	Damage = 43,
	Delay = 60 / 267,

	Spread = Spread(700),

	Recoil = {
		MinAng = Angle(1, -0.3, 0),
		MaxAng = Angle(2, 0.3, 0),
		Min = 1,
		Grow = 0,
		Punch = 0.3,
		Ratio = 0.2,
		Reset = 1
	},

	Sound = "Weapon_DEagle.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.4
