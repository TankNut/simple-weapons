AddCSLuaFile()

SWEP.Base = "simple_base"

SWEP.PrintName = "9mm Pistol"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 1

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_pistol.mdl")
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")

SWEP.HoldType = "pistol"
SWEP.LowerHoldType = "normal"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "Pistol",

	ClipSize = 18,
	DefaultClip = 18,

	Damage = 13,
	Delay = 60 / 600,

	Range = 750,
	Accuracy = 12,

	RangeModifier = 0.85,

	Recoil = {
		MinAng = Angle(1, -0.3, 0),
		MaxAng = Angle(1.2, 0.3, 0),
		Punch = 0.2,
		Ratio = 0.4
	},

	Reload = {
		Sound = "Weapon_Pistol.Reload"
	},

	Sound = "Weapon_Pistol.Single",
	TracerName = "Tracer"
}
