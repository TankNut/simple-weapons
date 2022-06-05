AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base_scoped"

SWEP.PrintName = "G3SG1"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_snip_g3sg1.mdl")
SWEP.WorldModel = Model("models/weapons/w_snip_g3sg1.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "XBowBolt",

	ClipSize = 20,
	DefaultClip = 20,

	Damage = 60,
	Delay = 60 / 240,

	Spread = Spread(3500),

	Recoil = {
		MinAng = Angle(2, -2, 0),
		MaxAng = Angle(3, 2, 0),
		Punch = 0.5,
		Ratio = 0.2
	},

	Sound = "Weapon_G3SG1.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 2
SWEP.ScopeZoom = 6
SWEP.ScopeSound = "Default.Zoom"
