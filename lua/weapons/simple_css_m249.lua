AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "M249"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_mach_m249para.mdl")
SWEP.WorldModel = Model("models/weapons/w_mach_m249para.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "AR2",

	ClipSize = 100,
	DefaultClip = 100,

	Damage = 18,
	Delay = 60 / 750,

	Spread = Spread(500),

	Recoil = {
		MinAng = Angle(0.5, -0.4, 0),
		MaxAng = Angle(0.7, 0.4, 0),
		Punch = 0.6,
		Ratio = 0
	},

	Sound = "Weapon_M249.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.2
