AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "AK-47"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_rif_ak47.mdl")
SWEP.WorldModel = Model("models/weapons/w_rif_ak47.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.LowerTime = 0.5

SWEP.Primary = {
	Ammo = "AR2",

	ClipSize = 30,
	DefaultClip = 30,

	Damage = 24,
	Delay = 60 / 600,

	Spread = Spread(1100),

	Recoil = {
		MinAng = Angle(1.1, -0.5, 0),
		MaxAng = Angle(1.3, 0.5, 0),
		Punch = 0.4,
		Ratio = 0.6
	},

	Sound = "Weapon_AK47.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.4
