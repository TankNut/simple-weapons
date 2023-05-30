AddCSLuaFile()

simple_weapons.Include("Convars")
simple_weapons.Include("Enums")

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
	local zoom = self:GetZoom()

	if zoom == 1 then
		return 0
	end

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

function SWEP:IsEmpty()
	if self.AmmoType == AMMO_NORMAL then
		return InfiniteAmmo:GetInt() != 2 and self:Clip1() < self.Primary.Cost
	elseif self.AmmoType == AMMO_NOMAG then
		return InfiniteAmmo:GetInt() == 0 and self:GetOwner():GetAmmoCount(self.Primary.Ammo) < self.Primary.Cost
	elseif self.AmmoType == AMMO_INTERNAL then
		return self:Clip1() < self.Primary.Cost
	end

	return false
end

function SWEP:GetShootDir()
	local ply = self:GetOwner()

	if ply:IsNPC() then
		return ply:GetAimVector()
	else
		return (ply:GetAimVector():Angle() + ply:GetViewPunchAngles()):Forward()
	end
end

function SWEP:HandleAutoRaise()
	if not self.ClassicMode and (self:GetLowered() or not self:IsReady()) and not self:IsReloading() then
		if self:GetOwner():GetInfoNum("simple_weapons_disable_raise", 0) == 0 then
			self:SetLower(false)
		end

		return true
	end

	return false
end

function SWEP:IsAltFireHeld()
	local ply = self:GetOwner()

	if not IsValid(ply) or ply:IsNPC() then
		return false
	end

	if ClassicMode:GetBool() then
		return ply:KeyDown(IN_ATTACK2)
	else
		return ply:KeyDown(IN_USE) and ply:KeyDown(IN_ATTACK)
	end
end

function SWEP:ForceStopFire()
	local ply = self:GetOwner()

	if not IsValid(ply) or not ply:IsPlayer() then
		return
	end

	ply:ConCommand("-attack")
end

function SWEP:DoAR2Impact(tr)
	if tr.HitSky then
		return
	end

	if not game.SinglePlayer() and not IsFirstTimePredicted() then
		return
	end

	local effect = EffectData()

	effect:SetOrigin(tr.HitPos + tr.HitNormal)
	effect:SetNormal(tr.HitNormal)

	util.Effect("AR2Impact", effect)
end
