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

	ClipSize = 6,
	DefaultClip = 6,

	PumpAction = true,
	PumpSound = "Weapon_Shotgun.Special1",

	Damage = 17,
	Count = 7,

	Delay = -1,

	Range = 150,
	Accuracy = 24,

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

SWEP.NPCData = {
	Burst = {1, 2},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay * 2, SWEP.Primary.Delay * 3}
}

list.Add("NPCUsableWeapons", {class = "simple_hl2_shotgun", title = "Simple Weapons: " .. SWEP.PrintName})
