AddCSLuaFile()

simple_weapons.Include("Convars")

SWEP.Base = "weapon_base"

SWEP.m_WeaponDeploySpeed = 1

SWEP.DrawWeaponInfoBox = false

SWEP.ViewModelFOV = 54

SWEP.SimpleWeapon = true

SWEP.HoldType = "melee"
SWEP.LowerHoldType = "normal"

SWEP.Primary.Ammo = ""
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true

SWEP.Primary.ChargeTime = 1

SWEP.Primary.Light = {
	Damage = 1,
	DamageType = bit.bor(DMG_CLUB, DMG_SHOCK),

	Range = 75,
	Delay = 0.1,

	Act = ACT_VM_HITCENTER,

	Sound = ""
}

SWEP.Primary.Heavy = {
	Damage = 1,
	DamageType = bit.bor(DMG_CLUB, DMG_SHOCK),

	Range = 75,
	Delay = 0.1,

	Act = ACT_VM_HITCENTER,

	HitSound = "",
	MissSound = ""
}

SWEP.Secondary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false

SWEP.ChargeOffset = {
	Pos = Vector(),
	Ang = Angle()
}

include("sh_animations.lua")
include("sh_attack.lua")

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Lowered")

	self:NetworkVar("Float", 0, "LowerTime")
	self:NetworkVar("Float", 1, "NextIdle")
	self:NetworkVar("Float", 2, "ChargeTime")
end

function SWEP:OnDeploy()
	self:SetLowered(true)
	self:SetLowerTime(0)

	self:SetHoldType(self.LowerHoldType)

	self:SendTranslatedWeaponAnim(ACT_VM_DRAW)
	self:SetNextIdle(CurTime() + self:SequenceDuration())
end

function SWEP:OnHolster(removing, ply)
	self:SetLowered(true)
	self:SetLowerTime(0)

	self:SetChargeTime(0)
end

function SWEP:IsReady()
	return CurTime() - self:GetLowerTime() >= ReadyTime:GetFloat()
end

function SWEP:CanLower()
	return self:IsReady()
end

function SWEP:SetLower(lower)
	if not self:CanLower() then
		return false
	end

	if self:GetLowered() != lower then
		self:SetLowered(lower)
		self:SetLowerTime(CurTime())

		self:SetHoldType(lower and self.LowerHoldType or self.HoldType)
	end

	self.Primary.Automatic = true

	return true
end

function SWEP:PrimaryAttack()
	if self:GetLowered() or not self:IsReady() then
		if self:GetOwner():GetInfoNum("simple_weapons_disable_raise", 0) == 0 then
			self:SetLower(false)
		end

		return
	end

	if self:GetChargeTime() != 0 then
		return
	end

	self:SetChargeTime(CurTime())

	self.Primary.Automatic = false
end

function SWEP:SecondaryAttack()
	self:SetLower(not self:GetLowered())
end

function SWEP:HandleIdle()
	local idle = self:GetNextIdle()

	if idle > 0 and idle <= CurTime() then
		self:SendTranslatedWeaponAnim(ACT_VM_IDLE)

		self:SetNextIdle(0)
	end
end

function SWEP:Think()
	self:HandleIdle()
	self:HandleCharge()
end

function SWEP:OnReloaded()
	self:SetWeaponHoldType(self:GetHoldType())
end

if CLIENT then
	function SWEP:DoDrawCrosshair(x, y)
		return self:GetLowered()
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

	local ease = math.ease.OutBack

	function SWEP:GetViewModelPosition(pos, ang)
		local fraction = self:GetLowerFraction()
		local offset = Vector(VMOffsetX:GetFloat(), VMOffsetY:GetFloat(), VMOffsetZ:GetFloat())

		pos, ang = LocalToWorld(offset, Angle(fraction * 15, 0, 0), pos, ang)

		local charge = self:GetChargeTime()

		if charge != 0 then
			local frac = ease(math.Clamp(math.Remap(CurTime() - charge, 0, self.Primary.ChargeTime * 2, 0, 1), 0, 1))

			local chargePos = LerpVector(frac, vector_origin, self.ChargeOffset.Pos)
			local chargeAng = LerpAngle(frac, angle_zero, self.ChargeOffset.Ang)

			pos, ang = LocalToWorld(chargePos, chargeAng, pos, ang)
		end

		return pos, ang
	end
end
