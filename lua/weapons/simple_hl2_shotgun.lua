AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "Shotgun"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 3
SWEP.SlotPos = 11

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_shotgun.mdl")
SWEP.WorldModel = Model("models/weapons/w_shotgun.mdl")

SWEP.HoldType = "shotgun"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = 0

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "Buckshot",

	ClipSize = 6,
	DefaultClip = 6,

	PumpAction = true,
	PumpSound = "Weapon_Shotgun.Special1",

	Damage = 8,
	Count = 7,

	Delay = -1,

	Spread = Spread(200),

	Recoil = {
		MinAng = Angle(1, -0.7, 0),
		MaxAng = Angle(2, 0.7, 0),
		Min = 1,
		Grow = 0,
		Punch = 0.5,
		Ratio = 0,
		Reset = 1
	},

	Reload = {
		Amount = 1,
		Shotgun = true,
		Sound = "Weapon_Shotgun.Reload",
	},

	Sound = "Weapon_Shotgun.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.2

SWEP.DefaultAmmo = "Buckshot"
SWEP.AmmoTypes = {"base_slugs"}
