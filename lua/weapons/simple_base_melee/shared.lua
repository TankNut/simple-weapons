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
SWEP.Primary.Automatic = false

SWEP.Primary.ChargeTime = 1
SWEP.Primary.AutoSwing = true

SWEP.Primary.Light = {
	Damage = 1,
	DamageType = DMG_CLUB,

	Range = 75,
	Delay = 0.1,

	Act = ACT_VM_HITCENTER,

	Sound = ""
}

SWEP.Primary.Heavy = {
	Damage = 1,
	DamageType = DMG_CLUB,

	Range = 75,
	Delay = 0.1,

	Act = ACT_VM_HITCENTER,

	Sound = ""
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
	self._NetworkVars = {
		["String"] = 0,
		["Bool"]   = 0,
		["Float"]  = 0,
		["Int"]    = 0,
		["Vector"] = 0,
		["Angle"]  = 0,
		["Entity"] = 0
	}

	self:AddNetworkVar("Bool", "Lowered")

	self:AddNetworkVar("Float", "LowerTime")
	self:AddNetworkVar("Float", "NextIdle")
	self:AddNetworkVar("Float", "ChargeTime")
end

function SWEP:AddNetworkVar(varType, name, extended)
	local index = assert(self._NetworkVars[varType], "Attempt to register unknown network var type " .. varType)
	local max = varType == "String" and 3 or 31

	if index >= max then
		error("Network var limit exceeded for " .. varType)
	end

	self:NetworkVar(varType, index, name, extended)
	self._NetworkVars[varType] = index + 1
end

function SWEP:Deploy()
	self.ClassicMode = ClassicMode:GetBool()

	self:SetLowerTime(0)

	if self.ClassicMode then
		self:SetLowered(false)
		self:SetHoldType(self.HoldType)
	else
		self:SetLowered(true)
		self:SetHoldType(self.LowerHoldType)
	end

	self:SendTranslatedWeaponAnim(ACT_VM_DRAW)
	self:SetNextIdle(CurTime() + self:SequenceDuration())
end

function SWEP:Holster()
	self:SetChargeTime(0)

	return true
end

function SWEP:IsReady()
	return CurTime() - self:GetLowerTime() >= ReadyTime:GetFloat()
end

function SWEP:CanLower()
	return self:IsReady() and self:GetChargeTime() == 0
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

	if self.Primary.ChargeTime == 0 then
		self.Primary.Automatic = self.Primary.AutoSwing
		self:LightAttack()

		return
	end

	if self:GetChargeTime() != 0 then
		return
	end

	self:SetChargeTime(CurTime())

	self.Primary.Automatic = false
end

function SWEP:SecondaryAttack()
	if self.ClassicMode then
		return
	end

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

if CLIENT then
	function SWEP:DoDrawCrosshair(x, y)
		return self:GetLowered()
	end

	local ease = math.ease.OutBack

	function SWEP:GetViewModelPosition(pos, ang)
		local fraction = self:GetLowerFraction()
		local offset = Vector(VMOffsetX:GetFloat(), VMOffsetY:GetFloat(), VMOffsetZ:GetFloat())

		pos, ang = LocalToWorld(offset, Angle(fraction * 15, 0, 0), pos, ang)

		local charge = self:GetChargeTime()

		if self.Primary.ChargeTime > 0 and charge != 0 then
			local frac = ease(math.Clamp(math.Remap(CurTime() - charge, 0, self.Primary.ChargeTime * 2, 0, 1), 0, 1))

			local chargePos = LerpVector(frac, vector_origin, self.ChargeOffset.Pos)
			local chargeAng = LerpAngle(frac, angle_zero, self.ChargeOffset.Ang)

			pos, ang = LocalToWorld(chargePos, chargeAng, pos, ang)
		end

		return pos, ang
	end
end

function SWEP:SetupMove(ply, mv)
	local fraction = self.ClassicMode and 1 or self:GetLowerFraction()
	local speed = math.Remap(fraction, 0, 1, ply:GetWalkSpeed(), ply:GetRunSpeed())

	if mv:GetForwardSpeed() <= 0 then
		mv:SetMaxClientSpeed(speed)
	end
end

function SWEP:OnRestore()
	self:SetLowerTime(0)
	self:SetNextIdle(CurTime())
	self:SetChargeTime(0)
end
