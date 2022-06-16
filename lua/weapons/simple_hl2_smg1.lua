AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "SMG"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_smg1.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg1.mdl")

SWEP.HoldType = "smg"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "SMG1",

	ClipSize = 45,
	DefaultClip = 45,

	Damage = 11,
	Delay = 60 / 800,

	Spread = Spread(300),

	Recoil = {
		MinAng = Angle(0.7, -0.4, 0),
		MaxAng = Angle(0.9, 0.4, 0),
		Punch = 0.4,
		Ratio = 0.4
	},

	Reload = {
		Sound = "Weapon_SMG1.Reload"
	},

	Sound = "Weapon_SMG1.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.2
