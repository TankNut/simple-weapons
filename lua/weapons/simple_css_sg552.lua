AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base_scoped"

SWEP.PrintName = "SG 552"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_rif_sg552.mdl")
SWEP.WorldModel = Model("models/weapons/w_rif_sg552.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.LowerTime = 0.5

SWEP.Primary = {
	Ammo = "AR2",

	ClipSize = 30,
	DefaultClip = 30,

	Damage = 23,
	Delay = 60 / 666,

	Spread = Spread(1100),

	Recoil = {
		MinAng = Angle(1, -0.4, 0),
		MaxAng = Angle(1.2, 0.4, 0),
		Punch = 0.4,
		Ratio = 0.4
	},

	Sound = "Weapon_SG552.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.5
SWEP.ScopeZoom = 3
SWEP.ScopeSound = "Default.Zoom"

function SWEP:GetDelay()
	return self:GetInScope() and 60 / 429 or 60 / 666
end
