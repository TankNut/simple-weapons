AddCSLuaFile()

DEFINE_BASECLASS("simple_base")

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

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
		MinAng = Angle(0.8, -0.6, 0),
		MaxAng = Angle(1, 0.6, 0),
		Punch = 0,
		Ratio = 0.6
	},

	Sound = "Weapon_SG552.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 1.5
SWEP.ScopeZoom = 3

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar("Bool", 4, "InScope")
end

function SWEP:OnDeploy()
	BaseClass.OnDeploy(self)

	self:SetInScope(false)
end

function SWEP:OnHolster(removing)
	BaseClass.OnHolster(self, removing)

	self:SetInScope(false)
end

function SWEP:GetDelay(firemode)
	return self:GetInScope() and 60 / 429 or 60 / 666
end

function SWEP:GetFOV()
	if self:GetLowered() then
		return 0
	end

	local desired = self:GetOwnerDefaultFOV()

	return self:GetInScope() and desired / self.ScopeZoom or desired / self.Zoom
end

function SWEP:SetScope(bool)
	if self:GetInScope() == bool then
		return
	end

	self:SetInScope(bool)

	self:GetOwner():SetFOV(self:GetFOV(), 0.2, self)
	self:EmitSound("Default.Zoom")
end

function SWEP:CanAlternateAttack()
	if self:GetLowered() then
		return false
	end

	return BaseClass.CanAlternateAttack(self)
end

function SWEP:AlternateAttack()
	self.Primary.Automatic = false

	self:SetScope(not self:GetInScope())
end
