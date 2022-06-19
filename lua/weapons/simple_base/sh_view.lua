AddCSLuaFile()

DEFINE_BASECLASS("weapon_base")

simple_weapons.Include("Convars")

function SWEP:GetZoom()
	if self:GetLowered() then
		return 1
	end

	return self:GetOwner():GetInfoNum("simple_weapons_zoom", 1.25)
end

function SWEP:TranslateFOV(fov)
	if not self:HasCameraControl() then
		self.ViewModelFOV = self.ViewModelTargetFOV

		return fov
	end

	local desired = self:GetOwnerDefaultFOV()

	self.ViewModelFOV = self.ViewModelTargetFOV + (desired - fov) * 0.6

	return fov
end

if CLIENT then
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

	function SWEP:AdjustMouseSensitivity()
		if not self:HasCameraControl() then
			return 1
		end

		local desired = self:GetOwnerDefaultFOV()
		local fov = self:GetFOV()

		return fov / desired
	end

	function SWEP:DrawWorldModelTranslucent(flags)
		self:DrawWorldModel(flags)
	end
end
