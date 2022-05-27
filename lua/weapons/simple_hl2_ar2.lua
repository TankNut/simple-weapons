AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "Pulse-Rifle"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 2
SWEP.SlotPos = 12

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_irifle.mdl")
SWEP.WorldModel = Model("models/weapons/w_irifle.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemodes = {-1, 3, 0}

SWEP.LowerTime = 0.5

SWEP.Primary = {
	Ammo = "AR2",

	ClipSize = 30,
	DefaultClip = 30,

	Damage = 8,
	Delay = 60 / 600,

	Spread = Spread(800),

	Recoil = {
		MinAng = Angle(1, -0.6, 0),
		MaxAng = Angle(1.3, 0.6, 0),
		Min = 0.3,
		Grow = 10,
		Punch = 0.2,
		Ratio = 0.6,
		Reset = 1
	},

	Sound = "Weapon_AR2.Single",
	TracerName = "AR2Tracer"
}

SWEP.Zoom = 1.4
