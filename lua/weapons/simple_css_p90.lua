AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "P90"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_smg_p90.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg_p90.mdl")

SWEP.HoldType = "smg"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "SMG1",

	ClipSize = 50,
	DefaultClip = 50,

	Damage = 13,
	Delay = 60 / 857,

	Spread = Spread(500),

	Recoil = {
		MinAng = Angle(0.5, -0.5, 0),
		MaxAng = Angle(0.7, 0.5, 0),
		Punch = 0.6,
		Ratio = 0.6
	},

	Sound = "Weapon_P90.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.2
