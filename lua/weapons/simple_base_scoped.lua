AddCSLuaFile()

simple_weapons.Include("Convars")

DEFINE_BASECLASS("simple_base")

SWEP.Base = "simple_base"

SWEP.Primary.UnscopedRange = 0
SWEP.Primary.UnscopedAccuracy = 0

SWEP.ScopeZoom = 1
SWEP.ScopeSound = ""

SWEP.UseScope = true
SWEP.HideInScope = true

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:AddNetworkVar("Int", "ScopeIndex")
end

function SWEP:Deploy()
	BaseClass.Deploy(self)

	self:SetScopeIndex(0)
end

function SWEP:Holster()
	self:SetScopeIndex(0)

	return BaseClass.Holster(self)
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
		return ClassicMode:GetBool() and 1 or self:GetOwner():GetInfoNum("simple_weapons_zoom", 1.25)
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

function SWEP:CanAltFire()
	return not self:GetLowered()
end

function SWEP:AltFire()
	self.Primary.Automatic = false

	self:CycleScope()
end

if CLIENT then
	function SWEP:PreDrawViewModel(vm, _, ply)
		if not self.UseScope or not self.HideInScope or self:GetLowered() then
			return
		end

		return self:GetScopeIndex() != 0 and UseScopes:GetBool()
	end

	function SWEP:ShouldHideCrosshair()
		if self.UseScope and self:GetScopeIndex() != 0 and UseScopes:GetBool() then
			return self:GetLowered()
		else
			return self:GetLowered() or self:IsReloading()
		end
	end

	function SWEP:DrawCrosshair(x, y)
		if self:GetScopeIndex() == 0 or not self.UseScope then
			return false
		else
			return UseScopes:GetBool() and self:DrawScope(x, y) or false
		end
	end

	local scope = Material("gmod/scope")

	function SWEP:DrawScope(x, y)
		local screenW = ScrW()
		local screenH = ScrH()

		local h = screenH
		local w = (4 / 3) * h

		local dw = (screenW - w) * 0.5

		local midX = screenW * 0.5
		local midY = screenH * 0.5

		surface.SetMaterial(scope)
		surface.SetDrawColor(0, 0, 0)

		surface.DrawLine(0, midY, screenW, midY)
		surface.DrawLine(midX, 0, midX, screenH)

		surface.DrawRect(0, 0, dw, h)
		surface.DrawRect(w + dw, 0, dw, h)

		surface.DrawTexturedRect(dw, 0, w, h)

		return true
	end
end
