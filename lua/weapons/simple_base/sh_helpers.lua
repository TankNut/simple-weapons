AddCSLuaFile()

simple_weapons.Include("Convars")

function SWEP:IsReady()
	return CurTime() - self:GetLowerTime() >= ReadyTime:GetFloat()
end

local easeIn = math.ease.InQuad
local easeOut = math.ease.OutQuad

function SWEP:GetLowerFraction()
	local frac = math.Clamp(math.Remap(CurTime() - self:GetLowerTime(), 0, ReadyTime:GetFloat(), 0, 1), 0, 1)

	if self:GetLowered() then
		return easeOut(frac)
	else
		return easeIn(1 - frac)
	end
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

function SWEP:GetTargetFOV()
	return self:GetOwnerDefaultFOV() / self:GetZoom()
end

function SWEP:UpdateFOV(time)
	self:GetOwner():SetFOV(self:GetTargetFOV(), time, self)
end

function SWEP:GetFOV()
	return self:GetOwner():GetFOV()
end

function SWEP:GetViewModel(index)
	return self:GetOwner():GetViewModel()
end
