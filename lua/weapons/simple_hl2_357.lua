AddCSLuaFile()

SWEP.Base = "simple_base"

SWEP.PrintName = ".357 Magnum"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 1

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_357.mdl")
SWEP.WorldModel = Model("models/weapons/w_357.mdl")

SWEP.HoldType = "revolver"
SWEP.LowerHoldType = "normal"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "357",

	ClipSize = 6,
	DefaultClip = 6,

	Damage = 40,
	Delay = 60 / 80,

	Range = 1600,

	Accuracy = 1400,
	AccuracyRef = 12,

	Recoil = {
		MinAng = Angle(3, -0.3, 0),
		MaxAng = Angle(4, 0.3, 0),
		Punch = 0.5,
		Ratio = 0.2
	},

	Sound = "Weapon_357.Single",
	TracerName = "Tracer"
}
