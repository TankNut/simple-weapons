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

function SWEP:GetFOV()
	if self:GetLowered() then
		return 0
	end

	return self:GetOwner():GetInfo("fov_desired") / self.Zoom
end
