AddCSLuaFile()

simple_weapons.Include("Convars")

DEFINE_BASECLASS("simple_base")

SWEP.Base = "simple_base"

SWEP.Primary.UnscopedRange = 0
SWEP.Primary.UnscopedAccuracy = 0

SWEP.ScopeZoom = 1
SWEP.ScopeSound = ""

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:AddNetworkVar("Int", "ScopeIndex")
end

function SWEP:OnDeploy()
	BaseClass.OnDeploy(self)

	self:SetScopeIndex(0)
end

function SWEP:OnHolster(removing, ply)
	BaseClass.OnHolster(self, removing, ply)

	self:SetScopeIndex(0)
end

function SWEP:GetRange()
	local range = self.Primary.Range
	local accuracy = self.Primary.Accuracy

	if self:GetOwner():IsNPC() then
		return range * RangeMult:GetFloat(), accuracy
	end

	if self:GetScopeIndex() == 0 then
		if self.Primary.UnscopedRange > 0 then
			range = self.Primary.UnscopedRange
		end

		if self.Primary.UnscopedAccuracy > 0 then
			accuracy = self.Primary.UnscopedAccuracy
		end
	end

	return range * RangeMult:GetFloat(), accuracy
end

function SWEP:GetZoom()
	if self:GetLowered() then
		return 1
	end

	local index = self:GetScopeIndex()

	if index == 0 then
		return self.ClassicMode and 1 or self:GetOwner():GetInfoNum("simple_weapons_zoom", 1.25)
	else
		return istable(self.ScopeZoom) and self.ScopeZoom[index] or self.ScopeZoom
	end
end

function SWEP:CycleScope()
	local index = self:GetScopeIndex()

	if istable(self.ScopeZoom) then
		index = (index + 1) % (#self.ScopeZoom + 1)
	else
		index = math.abs(index - 1)
	end

	self:SetScopeIndex(index)

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

	self:CycleScope()
end
