AddCSLuaFile()

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "TMP"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_smg_tmp.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg_tmp.mdl")

SWEP.HoldType = "smg"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "SMG1",

	ClipSize = 30,
	DefaultClip = 30,

	Damage = 8,
	Delay = 60 / 857,

	Spread = Spread(500),

	Recoil = {
		MinAng = Angle(0.5, -0.3, 0),
		MaxAng = Angle(0.7, 0.3, 0),
		Punch = 0.6,
		Ratio = 0.6
	},

	Sound = "Weapon_TMP.Single",
	TracerName = ""
}

SWEP.Zoom = 1.2

function SWEP:FireAnimationEvent(_, _, event)
	if event == 5001 or event == 5003 then
		return true
	end
end
