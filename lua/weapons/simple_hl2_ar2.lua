AddCSLuaFile()

SWEP.Base = "simple_base"

SWEP.PrintName = "Pulse Rifle"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_irifle.mdl")
SWEP.WorldModel = Model("models/weapons/w_irifle.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.Primary = {
	Ammo = "AR2",

	ClipSize = 30,
	DefaultClip = 60,

	Damage = 22,
	Delay = 60 / 600,

	Range = 1400,
	Accuracy = 12,

	RangeModifier = 0.98,

	Recoil = {
		MinAng = Angle(0.8, -0.6, 0),
		MaxAng = Angle(1, 0.6, 0),
		Punch = 0.4,
		Ratio = 0.6
	},

	Sound = "Weapon_AR2.Single",
	TracerName = "AR2Tracer"
}

function SWEP:DoImpactEffect(tr, dmgtype)
	if not IsFirstTimePredicted() or tr.HitSky then
		return
	end

	local effect = EffectData()

	effect:SetOrigin(tr.HitPos + tr.HitNormal)
	effect:SetNormal(tr.HitNormal)

	util.Effect("AR2Impact", effect)
end
