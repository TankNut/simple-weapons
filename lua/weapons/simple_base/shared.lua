AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.m_WeaponDeploySpeed = 1

SWEP.DrawWeaponInfoBox = false

SWEP.ViewModelTargetFOV = 54
SWEP.ViewModelFOV = 54

SWEP.SimpleWeapon = true

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.LowerTime = 0.5

SWEP.Primary.Ammo = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0

SWEP.Primary.PumpAction = false
SWEP.Primary.PumpSound = ""

SWEP.Primary.Damage = 0
SWEP.Primary.Count = 1

SWEP.Primary.Spread = Vector(0, 0, 0)

SWEP.Primary.Delay = 0.1

SWEP.Primary.BurstDelay = 0
SWEP.Primary.BurstEndDelay = 0

SWEP.Primary.Recoil = {
	MinAng = angle_zero,
	MaxAng = angle_zero,
	Min = 0,
	Grow = 0,
	Punch = 0,
	Ratio = 0,
	Reset = 1
}

SWEP.Primary.Reload = {
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

SWEP.Zoom = 1

SWEP.DefaultAmmo = "Default"
SWEP.AmmoTypes = {}

if CLIENT then
	include("cl_hud.lua")
	include("cl_viewmodel.lua")
else
	AddCSLuaFile("cl_hud.lua")
	AddCSLuaFile("cl_viewmodel.lua")
end

include("sh_animations.lua")
include("sh_helpers.lua")
include("sh_hooks.lua")
include("sh_reload.lua")

function SWEP:Initialize()
	self:SetFiremode(self.Firemode)

	self.StoredAmmoStats = {}

	simple_weapons.Weapons[self] = true
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Lowered")
	self:NetworkVar("Bool", 1, "NeedPump")
	self:NetworkVar("Bool", 2, "FirstReload")
	self:NetworkVar("Bool", 3, "AbortReload")

	self:NetworkVar("Int", 0, "Firemode")
	self:NetworkVar("Int", 1, "ShotsFired")
	self:NetworkVar("Int", 2, "BurstFired")

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
end

function SWEP:OnHolster(removing)
	self:SetLowered(true)
	self:SetLowerTime(0)

	self:SetFirstReload(false)
	self:SetAbortReload(false)
	self:SetFinishReload(0)

	self:GetOwner():SetFOV(0, 0.1, self)
end

function SWEP:SetLower(lower)
	if not self:IsReady() then
		return
	end

	if self:GetLowered() != lower then
		self:SetLowered(lower)
		self:SetLowerTime(CurTime())

		self:SetHoldType(lower and self.LowerHoldType or self.HoldType)

		local ply = self:GetOwner()

		ply:SetFOV(lower and 0 or ply:GetInfo("fov_desired") / self.Zoom, self.LowerTime, self)
	end

	self.Primary.Automatic = true
end

function SWEP:CanPrimaryAttack()
	if (self:GetLowered() or not self:IsReady()) and not self:IsReloading() then
		self:SetLower(false)

		return false
	end

	if self:IsReloading() then
		if self.Primary.Reload.Shotgun then
			self:SetAbortReload(true)
		end

		return false
	end

	if self.Primary.Ammo != -1 and self:Clip1() <= 0 then
		self:EmitSound(")weapons/pistol/pistol_empty.wav", 75, 100, 0.7, CHAN_ITEM)
		self:SetNextPrimaryFire(CurTime() + 0.2)

		self.Primary.Automatic = false

		return false
	end

	return true
end

function SWEP:CanAlternateAttack()
	return true
end

function SWEP:GetDelay(firemode)
	-- Basic support for burst fire
	if firemode > 0 then
		if self:GetBurstFired() == 0 and self.Primary.BurstEndDelay != 0 then
			return self.Primary.BurstEndDelay
		elseif self.Primary.BurstDelay != 0 then
			return self.Primary.BurstDelay
		end
	end

	return self.Primary.Delay
end

local convar_infinite = simple_weapons.Convars.InfiniteAmmo

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

	local primary = self.Primary
	local firemode = self:GetFiremode()

	if firemode == -1 then
		primary.Automatic = true
	elseif firemode == 0 then
		primary.Automatic = false
	else
		local count = self:GetBurstFired()

		if count + 1 >= firemode then
			primary.Automatic = false

			self:SetBurstFired(0)
		else
			primary.Automatic = true

			self:SetBurstFired(count + 1)
		end
	end

	local delay = self:GetDelay(firemode)

	self:FireWeapon()

	if ply:IsPlayer() then
		local command = ply:GetCurrentCommand()

		local recoil = self.Primary.Recoil
		local mult = math.Clamp(math.Remap((self:GetShotsFired() + 1) / recoil.Grow, 0, 1, recoil.Min, 1), recoil.Min, 1)

		local pitch = -util.SharedRandom(self:EntIndex() .. command:CommandNumber() .. "1", recoil.MinAng.p, recoil.MaxAng.p) * mult
		local yaw = util.SharedRandom(self:EntIndex() .. command:CommandNumber() .. "2", recoil.MinAng.y, recoil.MaxAng.y) * mult

		if game.SinglePlayer() or (CLIENT and IsFirstTimePredicted()) then
			ply:SetEyeAngles(ply:EyeAngles() + Angle(pitch, yaw, 0) * recoil.Punch)
		end

		ply:ViewPunch(Angle(pitch, yaw, 0))
	end

	if convar_infinite:GetInt() != 2 then
		self:TakePrimaryAmmo(1)
	end

	if primary.PumpAction then
		self:SetNeedPump(true)
	end

	self:SetLastFire(CurTime())
	self:SetShotsFired(self:GetShotsFired() + 1)

	local duration = self:SequenceDuration()

	if delay == -1 then
		delay = duration
	end

	self:SetNextIdle(CurTime() + self:SequenceDuration())
	self:SetNextPrimaryFire(CurTime() + delay)
end

function SWEP:AlternateAttack()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
end

function SWEP:ModifyBulletTable(bullet)
end

function SWEP:FireWeapon()
	local ply = self:GetOwner()
	local primary = self.Primary

	self:EmitFireSound()

	self:SendTranslatedWeaponAnim(ACT_VM_PRIMARYATTACK)

	ply:SetAnimation(PLAYER_ATTACK1)

	local spread = Vector(math.rad(primary.Spread.x) * 0.5, math.rad(primary.Spread.y), 0)

	local bullet = {
		Num = primary.Count,
		Src = ply:GetShootPos(),
		Dir = (ply:GetAimVector():Angle() + ply:GetViewPunchAngles()):Forward(),
		Spread = spread,
		TracerName = primary.TracerName,
		Tracer = primary.TracerName == "" and 0 or 1,
		Force = 5,
		Damage = primary.Damage
	}

	self:ModifyBulletTable(bullet)

	ply:FireBullets(bullet)
end

function SWEP:SecondaryAttack()
	self:SetLower(not self:GetLowered())
end

function SWEP:Think()
	local primary = self.Primary

	-- Idle

	local idle = self:GetNextIdle()

	if idle > 0 and idle <= CurTime() then
		self:SendTranslatedWeaponAnim(ACT_VM_IDLE)

		self:SetNextIdle(0)
	end

	-- Reload handling

	local reload = self:GetFinishReload()

	if reload > 0 and reload <= CurTime() then
		self:FinishReload()
	end

	-- Pump action

	if self:GetNeedPump() and not self:IsReloading() and self:GetNextPrimaryFire() <= CurTime() and self:Clip1() > 0 then
		self:SendTranslatedWeaponAnim(ACT_SHOTGUN_PUMP)

		if primary.PumpSound != "" then
			self:EmitSound(self.Primary.PumpSound)
		end

		local duration = self:SequenceDuration()

		self:SetNextPrimaryFire(CurTime() + duration)
		self:SetNextIdle(CurTime() + duration)

		self:SetNeedPump(false)
	end

	-- Burst reset

	if self:GetBurstFired() > 0 and CurTime() > self:GetNextPrimaryFire() + engine.TickInterval() then
		self:SetBurstFired(0)
		self:SetNextPrimaryFire(CurTime() + self:GetDelay(self:GetFiremode()))
	end

	-- Shots fired reset

	if self:GetShotsFired() > 0 and CurTime() - self:GetLastFire() > self.Primary.Recoil.Reset then
		self:SetShotsFired(0)
	end
end

if CLIENT then
	function SWEP:AdjustMouseSensitivity()
		if not self:HasCameraControl() then
			return 1
		end

		local ply = self:GetOwner()

		local desired = ply:GetInfo("fov_desired")
		local fov = ply:GetFOV()

		return fov / desired
	end
end

function SWEP:TranslateFOV(fov)
	if not self:HasCameraControl() then
		self.ViewModelFOV = self.ViewModelTargetFOV

		return fov
	end

	local desired = self:GetOwner():GetInfo("fov_desired")

	self.ViewModelFOV = self.ViewModelTargetFOV + (desired - fov) * 0.6

	return fov
end

function SWEP:OnReloaded()
	self:SetWeaponHoldType(self:GetHoldType())
end

function SWEP:OnRemove()
	local ply = self:GetOwner()

	if IsValid(ply) and ply._ActiveWeapon == self then
		self:OnHolster(true)
	end

	simple_weapons.Weapons[self] = nil
end
