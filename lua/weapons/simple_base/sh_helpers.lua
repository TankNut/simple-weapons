AddCSLuaFile()

function SWEP:IsReady()
	return CurTime() - self:GetLowerTime() >= self.LowerTime
end

function SWEP:GetLowerFraction()
	local frac = math.Clamp(math.Remap(CurTime() - self:GetLowerTime(), 0, self.LowerTime, 0, 1), 0, 1)

	return self:GetLowered() and frac or 1 - frac
end

local easeIn = math.ease.InQuad
local easeOut = math.ease.OutQuad

function SWEP:GetEasedLowerFraction()
	local fraction = self:GetLowerFraction()

	if self:GetLowered() then
		fraction = easeOut(fraction)
	else
		fraction = easeIn(fraction)
	end

	return fraction
end

function SWEP:HasCameraControl()
	local ply = self:GetOwner()

	if CLIENT and not ply:ShouldDrawLocalPlayer() then
		return true
	end

	return ply:GetViewEntity() == ply
end

function SWEP:GetOwnerDefaultFOV()
	return self:GetOwner():GetInfoNum("fov_desired", 75)
end

function SWEP:GetZoom()
	if self:GetLowered() then
		return 1
	end

	return self.Zoom
end

function SWEP:GetTargetFOV()
	return self:GetOwnerDefaultFOV() / self:GetZoom()
end

function SWEP:UpdateFOV(time, reset)
	self:GetOwner():SetFOV(reset and 0 or self:GetTargetFOV(), time, self)
end

function SWEP:GetFOV()
	return self:GetOwner():GetFOV()
end

function SWEP:GetViewModel(index)
	return self:GetOwner():GetViewModel()
end

function SWEP:GetRecoilMultiplier()
	return 1 / self:GetZoom()
end
