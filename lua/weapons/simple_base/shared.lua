AddCSLuaFile()

simple_weapons.Include("Convars")

SWEP.Base = "weapon_base"

SWEP.m_WeaponDeploySpeed = 1

SWEP.DrawWeaponInfoBox = false

SWEP.ViewModelTargetFOV = 54
SWEP.ViewModelFOV = 54

SWEP.SimpleWeapon = true

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.Primary.Ammo = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0

SWEP.Primary.PumpAction = false
SWEP.Primary.PumpSound = ""

SWEP.Primary.Damage = 0
SWEP.Primary.Count = 1

SWEP.Primary.Spread = Vector(0, 0, 0)

SWEP.Primary.Range = 1000
SWEP.Primary.Accuracy = 12

SWEP.Primary.RangeModifier = 0.9

SWEP.Primary.Delay = 0.1

SWEP.Primary.BurstDelay = 0
SWEP.Primary.BurstEndDelay = 0

SWEP.Primary.Recoil = {
	MinAng = angle_zero,
	MaxAng = angle_zero,
	Punch = 0,
	Ratio = 0,
}

SWEP.Primary.Reload = {
	Time = 0,
	Amount = math.huge,
	Shotgun = false,
	Sound = ""
}

SWEP.Primary.Sound = ""
SWEP.Primary.TracerName = ""

SWEP.Secondary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false

SWEP.ViewOffset = Vector()

if CLIENT then
	include("cl_hud.lua")
else
	AddCSLuaFile("cl_hud.lua")
end

include("sh_animations.lua")
include("sh_attack.lua")
include("sh_helpers.lua")
include("sh_recoil.lua")
include("sh_reload.lua")
include("sh_view.lua")

function SWEP:Initialize()
	self:SetFiremode(self.Firemode)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Lowered")
	self:NetworkVar("Bool", 1, "NeedPump")
	self:NetworkVar("Bool", 2, "FirstReload")
	self:NetworkVar("Bool", 3, "AbortReload")

	self:NetworkVar("Int", 0, "Firemode")
	self:NetworkVar("Int", 1, "BurstFired")

	self:NetworkVar("Float", 0, "LowerTime")
	self:NetworkVar("Float", 1, "NextIdle")
	self:NetworkVar("Float", 2, "LastFire")
	self:NetworkVar("Float", 3, "FinishReload")
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

	self:SetFirstReload(false)
	self:SetAbortReload(false)
	self:SetFinishReload(0)

	ply:SetFOV(0, 0.1, self)
end

function SWEP:CanLower()
	if not self:IsReady() then
		return false
	end

	if not LoweredReloads:GetBool() and self:IsReloading() then
		return false
	end

	return true
end

function SWEP:SetLower(lower)
	if not self:CanLower() then
		return false
	end

	if self:GetLowered() != lower then
		self:SetLowered(lower)
		self:SetLowerTime(CurTime())

		self:SetHoldType(lower and self.LowerHoldType or self.HoldType)

		self:UpdateFOV(ReadyTime:GetFloat())
	end

	self.Primary.Automatic = true

	return true
end

function SWEP:CanPrimaryAttack()
	if (self:GetLowered() or not self:IsReady()) and not self:IsReloading() then
		if self:GetOwner():GetInfoNum("simple_weapons_disable_raise", 0) == 0 then
			self:SetLower(false)
		end

		return false
	end

	if self:IsReloading() then
		if self.Primary.Reload.Shotgun then
			self:SetAbortReload(true)
		end

		return false
	end

	if self.Primary.ClipSize != -1 and self:Clip1() <= 0 then
		self:EmitSound(")weapons/pistol/pistol_empty.wav", 75, 100, 0.7, CHAN_STATIC)

		if self:GetOwner():GetInfoNum("simple_weapons_auto_reload", 0) == 1 and self:GetBurstFired() == 0 then
			self:Reload()
		end

		self:SetNextPrimaryFire(CurTime() + 0.2)

		self.Primary.Automatic = false

		return false
	end

	return true
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()

	if ply:KeyDown(IN_USE) then
		if not self:CanAlternateAttack() then
			return
		end

		self:AlternateAttack()

		return
	end

	if not self:CanPrimaryAttack() then
		return
	end

	self:UpdateAutomatic()
	self:FireWeapon()

	local delay = self:GetDelay()

	if ply:IsPlayer() then
		self:ApplyRecoil(ply)
	end

	self:ConsumeAmmo()

	if self:ShouldPump() then
		self:SetNeedPump(true)
	end

	self:SetLastFire(CurTime())

	self:SetNextIdle(CurTime() + self:SequenceDuration())
	self:SetNextPrimaryFire(CurTime() + delay)
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

function SWEP:HandlePump()
	if self:GetNeedPump() and not self:IsReloading() and self:GetNextPrimaryFire() <= CurTime() and self:Clip1() > 0 then
		self:SendTranslatedWeaponAnim(ACT_SHOTGUN_PUMP)

		local snd = self.Primary.PumpSound

		if snd != "" then
			self:EmitSound(snd)
		end

		local duration = self:SequenceDuration()

		self:SetNextPrimaryFire(CurTime() + duration)
		self:SetNextIdle(CurTime() + duration)

		self:SetNeedPump(false)
	end
end

function SWEP:HandleBurst()
	if self:GetBurstFired() > 0 and CurTime() > self:GetNextPrimaryFire() + engine.TickInterval() then
		self:SetBurstFired(0)
		self:SetNextPrimaryFire(CurTime() + self:GetDelay())
	end
end

function SWEP:Think()
	self:HandleReload()
	self:HandleIdle()
	self:HandlePump()
	self:HandleBurst()
end

function SWEP:OnReloaded()
	self:SetWeaponHoldType(self:GetHoldType())
end

function SWEP:OnRemove()
	local ply = self:GetOwner()

	if IsValid(ply) and ply._ActiveWeapon == self then
		self:OnHolster(true, ply)
	end
end

function SWEP:SetupMove(ply, mv)
	local fraction = self:GetLowerFraction()
	local speed = math.Remap(fraction, 0, 1, ply:GetWalkSpeed(), ply:GetRunSpeed())

	mv:SetMaxSpeed(speed)
	mv:SetMaxClientSpeed(speed)
end
