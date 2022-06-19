AddCSLuaFile()

DEFINE_BASECLASS("simple_base")

SWEP.Base = "simple_base"

SWEP.ScopeZoom = 1
SWEP.ScopeSound = ""

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar("Bool", 4, "InScope")
end

function SWEP:OnDeploy()
	BaseClass.OnDeploy(self)

	self:SetInScope(false)
end

function SWEP:OnHolster(removing, ply)
	BaseClass.OnHolster(self, removing, ply)

	self:SetInScope(false)
end

function SWEP:GetZoom()
	if self:GetLowered() then
		return 1
	end

	return self:GetInScope() and self.ScopeZoom or self:GetOwner():GetInfoNum("simple_weapons_zoom", 1.25)
end

function SWEP:SetScope(bool)
	if self:GetInScope() == bool then
		return
	end

	self:SetInScope(bool)

	self:UpdateFOV(0.2)

	if self.ScopeSound != "" then
		self:EmitSound(self.ScopeSound)
	end
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
