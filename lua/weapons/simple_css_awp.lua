AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base_scoped"

SWEP.PrintName = "AWP"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_snip_awp.mdl")
SWEP.WorldModel = Model("models/weapons/w_snip_awp.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = 0

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "XBowBolt",

	ClipSize = 10,
	DefaultClip = 10,

	Damage = 85,
	Delay = -1,

	Spread = Spread(3500),

	Recoil = {
		MinAng = Angle(7, -2, 0),
		MaxAng = Angle(9, 2, 0),
		Punch = 1,
		Ratio = 0.2
	},

	Sound = "Weapon_AWP.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 2.25
SWEP.ScopeZoom = 9
SWEP.ScopeSound = "Default.Zoom"
