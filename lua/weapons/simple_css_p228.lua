AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "P228"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 1

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_p228.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_p228.mdl")

SWEP.HoldType = "pistol"
SWEP.LowerHoldType = "normal"

SWEP.Firemode = 0

SWEP.LowerTime = 0.3

SWEP.Primary = {
	Ammo = "Pistol",

	ClipSize = 20,
	DefaultClip = 20,

	Damage = 5,
	Delay = 60 / 400,

	Spread = Spread(500),

	Recoil = {
		MinAng = Angle(0.7, -0.3, 0),
		MaxAng = Angle(1, 0.3, 0),
		Punch = 0.2,
		Ratio = 0.6
	},

	Sound = "Weapon_P228.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.2
