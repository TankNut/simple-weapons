DEFINE_BASECLASS("weapon_base")

function SWEP:CalcView(ply, pos, ang, fov)
	if not self:HasCameraControl() then
		return
	end

	return pos, ang - ply:GetViewPunchAngles() * self.Primary.Recoil.Ratio, fov
end

function SWEP:GetViewModelPosition(pos, ang)
	local offset = self:GetEasedLowerFraction()

	ang:RotateAroundAxis(ang:Right(), -offset * 15)

	local ply = self:GetOwner()

	if IsValid(ply) then
		local fov = ply:GetFOV()
		local ratio = math.min(self.ViewModelFOV / fov, fov / self.ViewModelFOV)

		local recoil = self.Primary.Recoil

		ang = ang + ply:GetViewPunchAngles() * ratio * recoil.Ratio
	end

	return pos, ang
end
