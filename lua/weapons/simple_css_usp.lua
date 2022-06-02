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
		Punch = 0.2,
		Ratio = 0.6
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
	self.Primary.Automatic = false

	local suppressed = not self:GetSuppressed()

	self:SetSuppressed(suppressed)

	self:SendTranslatedWeaponAnim(suppressed and ACT_VM_ATTACH_SILENCER or ACT_VM_DETACH_SILENCER)

	local duration = CurTime() + self:SequenceDuration()

	self:SetNextPrimaryFire(duration)
	self:SetNextIdle(duration)
end

local replace = {
	[ACT_VM_DRAW] = ACT_VM_DRAW_SILENCED,
	[ACT_VM_PRIMARYATTACK] = ACT_VM_PRIMARYATTACK_SILENCED,
	[ACT_VM_IDLE] = ACT_VM_IDLE_SILENCED,
	[ACT_VM_RELOAD] = ACT_VM_RELOAD_SILENCED
}

function SWEP:EmitFireSound()
	self:EmitSound(self:GetSuppressed() and "Weapon_USP.SilencedShot" or "Weapon_USP.Single")
end

function SWEP:ModifyBulletTable(bullet)
	if self:GetSuppressed() then
		bullet.Tracer = 0
	end
end

function SWEP:TranslateWeaponAnim(act)
	if self:GetSuppressed() then
		return replace[act] or act
	end

	return act
end

if CLIENT then
	function SWEP:DrawWorldModel(flags)
		self:SetModel(self:GetSuppressed() and "models/weapons/w_pist_usp_silencer.mdl" or "models/weapons/w_pist_usp.mdl")

		BaseClass.DrawWorldModel(self, flags)
	end

	function SWEP:DrawWorldModelTranslucent(flags)
		self:DrawWorldModel(flags)
	end
end

function SWEP:FireAnimationEvent(_, _, event)
	if self:GetSuppressed() and (event == 5001 or event == 5003) then
		return true
	end
end
