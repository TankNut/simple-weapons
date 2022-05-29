AddCSLuaFile()

DEFINE_BASECLASS("simple_base")

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "USP-S"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 1

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_usp.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_usp.mdl")

SWEP.HoldType = "pistol"
SWEP.LowerHoldType = "normal"

SWEP.Firemode = 0

SWEP.LowerTime = 0.3

SWEP.Primary = {
	Ammo = "Pistol",

	ClipSize = 12,
	DefaultClip = 12,

	Damage = 5,
	Delay = 60 / 400,

	Spread = Spread(700),

	Recoil = {
		MinAng = Angle(0.7, -0.3, 0),
		MaxAng = Angle(1, 0.3, 0),
		Min = 1,
		Grow = 0,
		Punch = 0.2,
		Ratio = 0.6,
		Reset = 1
	},

	Sound = "Weapon_USP.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.3

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar("Bool", 4, "Suppressed")
end

function SWEP:CanAlternateAttack()
	if self:IsReloading() then
		return false
	end

	return true
end

function SWEP:AlternateAttack()
	local suppressed = not self:GetSuppressed()

	self:SetSuppressed(suppressed)

	self.Primary.Sound = suppressed and "Weapon_USP.SilencedShot" or "Weapon_USP.Single"
	self.Primary.TracerName = suppressed and "" or "Tracer"

	self:SendTranslatedWeaponAnim(suppressed and ACT_VM_ATTACH_SILENCER or ACT_VM_DETACH_SILENCER)

	self:SetWorldModel(suppressed and "models/weapons/w_pist_usp_silencer.mdl" or "models/weapons/w_pist_usp.mdl")

	if game.SinglePlayer() then
		self:CallOnClient("SetWorldModel", suppressed and "models/weapons/w_pist_usp_silencer.mdl" or "models/weapons/w_pist_usp.mdl")
	end

	local duration = CurTime() + self:SequenceDuration()

	self:SetNextPrimaryFire(duration)
	self:SetNextIdle(duration)
end

function SWEP:SetWorldModel(mdl)
	self.WorldModel = mdl
end

local replace = {
	[ACT_VM_PRIMARYATTACK] = ACT_VM_PRIMARYATTACK_SILENCED,
	[ACT_VM_IDLE] = ACT_VM_IDLE_SILENCED,
	[ACT_VM_RELOAD] = ACT_VM_RELOAD_SILENCED
}

function SWEP:TranslateWeaponAnim(act)
	if self:GetSuppressed() then
		return replace[act] or act
	end

	return act
end
