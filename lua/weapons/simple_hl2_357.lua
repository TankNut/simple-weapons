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
	DefaultClip = 12,

	Damage = 40,
	Delay = 60 / 80,

	Range = 1600,
	Accuracy = 12,

	RangeModifier = 0.94,

	Recoil = {
		MinAng = Angle(3, -0.3, 0),
		MaxAng = Angle(4, 0.3, 0),
		Punch = 0.5,
		Ratio = 0.2
	},

	Sound = "Weapon_357.Single",
	TracerName = "Tracer"
}

SWEP.NPCData = {
	Burst = {1, 1},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay, SWEP.Primary.Delay * 2}
}

list.Add("NPCUsableWeapons", {class = "simple_hl2_357", title = "Simple Weapons: " .. SWEP.PrintName})
