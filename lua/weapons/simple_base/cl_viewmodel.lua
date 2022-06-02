DEFINE_BASECLASS("weapon_base")

simple_weapons.Include("Convars")

function SWEP:CalcView(ply, pos, ang, fov)
	if not self:HasCameraControl() then
		return
	end

	return pos, ang - ply:GetViewPunchAngles() * self.Primary.Recoil.Ratio, fov
end

local defaultOffset = Vector()
local altOffset = Vector(0, 0, 1)

function SWEP:GetViewModelPosition(pos, ang)
	local fraction = self:GetEasedLowerFraction()

	pos, ang = LocalToWorld(AltOffset:GetBool() and altOffset or defaultOffset, Angle(fraction * 15, 0, 0), pos, ang)

	local ply = self:GetOwner()

	if IsValid(ply) then
		local fov = ply:GetFOV()
		local ratio = math.min(self.ViewModelFOV / fov, fov / self.ViewModelFOV)

		local recoil = self.Primary.Recoil

		ang = ang + ply:GetViewPunchAngles() * ratio * recoil.Ratio
	end

	return pos, ang
end

function SWEP:DrawWorldModelTranslucent(flags)
	self:DrawWorldModel(flags)
end
