AddCSLuaFile()

SWEP.Base = "simple_base"

SWEP.PrintName = "Shotgun"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_shotgun.mdl")
SWEP.WorldModel = Model("models/weapons/w_shotgun.mdl")

SWEP.HoldType = "shotgun"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "Buckshot",
	Cost = 1,

	ClipSize = 6,
	DefaultClip = 6,

	PumpAction = true,
	PumpSound = "Weapon_Shotgun.Special1",

	Damage = 17,
	Count = 7,

	Delay = -1,

	Range = 500,
	AccuracyRef = 24,

	RangeModifier = 0.7,

	Recoil = {
		MinAng = Angle(2, -0.7, 0),
		MaxAng = Angle(3, 0.7, 0),
		Punch = 0.5,
		Ratio = 0
	},

	Reload = {
		Amount = 1,
		Shotgun = true,
		Sound = "Weapon_Shotgun.Reload",
	},

	Sound = "Weapon_Shotgun.Single",
	TracerName = "Tracer"
}
