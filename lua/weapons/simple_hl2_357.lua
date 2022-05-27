AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = ".357 Magnum"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 1
SWEP.SlotPos = 12

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_357.mdl")
SWEP.WorldModel = Model("models/weapons/w_357.mdl")

SWEP.HoldType = "revolver"
SWEP.LowerHoldType = "normal"

SWEP.Firemodes = 0

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "357",

	ClipSize = 6,
	DefaultClip = 6,

	Damage = 40,
	Delay = 60 / 80,

	Spread = Spread(1000),

	Recoil = {
		MinAng = Angle(2, -0.3, 0),
		MaxAng = Angle(3, 0.3, 0),
		Min = 1,
		Grow = 0,
		Punch = 0.5,
		Ratio = 0,
		Reset = 1
	},

	Sound = "Weapon_357.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.5
