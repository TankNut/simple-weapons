DEFINE_BASECLASS("weapon_base")

simple_weapons.Include("Convars")

function SWEP:CalcView(ply, pos, ang, fov)
	if not self:HasCameraControl() then
		return
	end

	return pos, ang - ply:GetViewPunchAngles() * self.Primary.Recoil.Ratio, fov
end

function SWEP:GetViewModelPosition(pos, ang)
	local fraction = self:GetEasedLowerFraction()
	local offset = Vector(VMOffsetX:GetFloat(), VMOffsetY:GetFloat(), VMOffsetZ:GetFloat())

	pos, ang = LocalToWorld(offset, Angle(fraction * 15, 0, 0), pos, ang)

	local ply = self:GetOwner()

	if IsValid(ply) then
		local const = math.pi / 360
		local ratio = math.tan(ply:GetFOV() * const) / math.tan(self.ViewModelFOV * const)

		ang = ang + ply:GetViewPunchAngles() * ratio * self.Primary.Recoil.Ratio
	end

	return pos, ang
end

function SWEP:DrawWorldModelTranslucent(flags)
	self:DrawWorldModel(flags)
end
