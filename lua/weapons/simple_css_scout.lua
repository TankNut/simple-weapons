AddCSLuaFile()

DEFINE_BASECLASS("simple_base")

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "Steyr Scout"
SWEP.Category = "Simple Weapons: Counter-Strike: Source"

SWEP.CSMuzzleFlashes = true

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/cstrike/c_snip_scout.mdl")
SWEP.WorldModel = Model("models/weapons/w_snip_scout.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = 0

SWEP.LowerTime = 0.4

SWEP.Primary = {
	Ammo = "XBowBolt",

	ClipSize = 10,
	DefaultClip = 10,

	Damage = 65,
	Delay = -1,

	Spread = Spread(1850),

	Recoil = {
		MinAng = Angle(2, -1, 0),
		MaxAng = Angle(3, 1, 0),
		Punch = 0.5,
		Ratio = 0.2
	},

	Sound = "Weapon_Scout.Single",
	TracerName = "Tracer"
}

SWEP.Zoom = 2.25
SWEP.ScopeZoom = 9

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
