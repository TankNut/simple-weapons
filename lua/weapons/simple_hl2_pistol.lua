AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "9mm Pistol"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 1
SWEP.SlotPos = 11

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_pistol.mdl")
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")

SWEP.HoldType = "pistol"
SWEP.LowerHoldType = "normal"

SWEP.Firemode = 0

SWEP.LowerTime = 0.3

SWEP.Primary = {
	Ammo = "Pistol",

	ClipSize = 18,
	DefaultClip = 18,

	Damage = 5,
	Delay = 60 / 600,

	Spread = Spread(500),

	Recoil = {
		MinAng = Angle(0.7, -0.3, 0),
		MaxAng = Angle(1, 0.3, 0),
		Min = 1,
		Grow = 0,
		Punch = 0.2,
		Ratio = 0.4,
		Reset = 1
	},

	Reload = {
		Sound = "Weapon_Pistol.Reload"
	},

	Sound = "Weapon_Pistol.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.2
