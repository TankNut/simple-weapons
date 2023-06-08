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

SWEP.CustomHoldType = {}
SWEP.CustomLowerHoldType = {}

SWEP.Firemode = -1

SWEP.Primary.Ammo = ""
SWEP.Primary.Cost = 1

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
SWEP.Primary.TracerFrequency = 2

SWEP.Secondary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false

SWEP.ViewOffset = Vector()

SWEP.NPCData = {
	Burst = {3, 5},
	Delay = 0.1,
	Rest = {0.5, 1}
}

if CLIENT then
	include("cl_hud.lua")
else
	AddCSLuaFile("cl_hud.lua")
end

include("sh_ammo.lua")
include("sh_animations.lua")
include("sh_attack.lua")
include("sh_getters.lua")
include("sh_helpers.lua")
include("sh_recoil.lua")
include("sh_reload.lua")
include("sh_sound.lua")
include("sh_view.lua")

if SERVER then
	include("sv_npc.lua")
end

if engine.ActiveGamemode() == "terrortown" then
	include("sh_ttt.lua")
end

function SWEP:Initialize()
	self:SetFiremode(self.Firemode)

	self.AmmoType = self:GetAmmoType()
end

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

	self:AddNetworkVar("Entity", "LastOwner")

	self:AddNetworkVar("Bool", "Lowered")
	self:AddNetworkVar("Bool", "NeedPump")
	self:AddNetworkVar("Bool", "FirstReload")
	self:AddNetworkVar("Bool", "AbortReload")

	self:AddNetworkVar("Int", "Firemode")
	self:AddNetworkVar("Int", "BurstFired")

	self:AddNetworkVar("Float", "LowerTime")
	self:AddNetworkVar("Float", "NextIdle")
	self:AddNetworkVar("Float", "FinishReload")

	self:AddNetworkVar("Float", "NextFire")
	self:AddNetworkVar("Float", "NextAltFire")
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

function SWEP:OwnerChanged()
	local old = self:GetLastOwner()

	if IsValid(old) and old:IsPlayer() then
		old:SetFOV(0, 0.1, self)
	end

	local ply = self:GetOwner()

	if IsValid(ply) and ply:IsNPC() then
		self:SetHoldType(self.HoldType)
	end

	self:SetLastOwner(ply)
end

function SWEP:Deploy()
	self:SetLowerTime(0)

	if ClassicMode:GetBool() then
		self:SetLowered(false)
		self:SetHoldType(self.HoldType)
	else
		self:SetLowered(true)
		self:SetHoldType(self.LowerHoldType)
	end

	self:SendTranslatedWeaponAnim(ACT_VM_DRAW)
	self:SetNextIdle(CurTime() + self:SequenceDuration())

	self.ClassicMode = ClassicMode:GetBool()
end

function SWEP:Holster()
	self:SetFirstReload(false)
	self:SetAbortReload(false)
	self:SetFinishReload(0)

	local ply = self:GetOwner()

	if IsValid(ply) and ply:IsPlayer() then
		ply:SetFOV(0, 0.1, self)
	end

	return true
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

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()

	if not ClassicMode:GetBool() and ply:IsPlayer() and ply:KeyDown(IN_USE) then
		self:TryAltFire()

		return
	end

	if self:GetNextFire() > CurTime() or not self:CanPrimaryFire() then
		return
	end

	self:PrimaryFire()
end

function SWEP:SecondaryAttack()
	if ClassicMode:GetBool() then
		self:TryAltFire()
	else
		self:SetLower(not self:GetLowered())
	end
end

function SWEP:HandleIdle()
	local idle = self:GetNextIdle()

	if idle > 0 and idle <= CurTime() then
		self:SendTranslatedWeaponAnim(ACT_VM_IDLE)

		self:SetNextIdle(0)
	end
end

function SWEP:HandlePump()
	if self:GetNeedPump() and not self:IsReloading() and self:GetNextFire() <= CurTime() then
		if not self.Primary.PumpOnEmpty and self:Clip1() == 0 then
			return
		end

		self:SendTranslatedWeaponAnim(ACT_SHOTGUN_PUMP)

		local snd = self.Primary.PumpSound

		if snd != "" and IsFirstTimePredicted() then
			self:EmitSound(snd)
		end

		local duration = self:SequenceDuration()

		self:SetNextFire(CurTime() + duration)
		self:SetNextIdle(CurTime() + duration)

		self:SetNeedPump(false)
	end
end

function SWEP:HandleBurst()
	if self:GetBurstFired() > 0 and CurTime() > self:GetNextFire() + engine.TickInterval() then
		self:SetBurstFired(0)
		self:SetNextFire(CurTime() + self:GetDelay())
	end
end

function SWEP:Think()
	self:HandleReload()
	self:HandleIdle()
	self:HandlePump()
	self:HandleBurst()
	self:HandleViewModel()

	self:UpdateClassicMode()
end

function SWEP:UpdateClassicMode()
	local classic = ClassicMode:GetBool()

	if self.ClassicMode == nil then
		self:Deploy()

		return
	end

	if self.ClassicMode != classic then
		self:SetLowered(false)
		self:SetLowerTime(0)

		self:UpdateFOV(0.1)

		self:SetHoldType(self.HoldType)
		self.ClassicMode = ClassicMode:GetBool()
	end
end

function SWEP:OnReloaded()
	if self:GetHoldType() != "" then
		self:SetWeaponHoldType(self:GetHoldType())
	end
end

function SWEP:SetupMove(ply, mv)
	local fraction = ClassicMode:GetBool() and 1 or self:GetLowerFraction()
	local min = hook.Run("SimpleLimitMoveSpeed", ply, self)

	if not min then
		min = WalkSpeed:GetFloat()

		if ply:Crouching() then
			min = math.min(min, ply:GetWalkSpeed() * ply:GetCrouchedWalkSpeed())
		end
	end

	local speed = math.Remap(fraction, 0, 1, min, ply:GetRunSpeed())

	mv:SetMaxSpeed(speed)
	mv:SetMaxClientSpeed(speed)
end

function SWEP:OnRestore()
	self:SetFirstReload(false)
	self:SetAbortReload(false)

	self:SetBurstFired(0)

	self:SetLowerTime(0)
	self:SetNextIdle(CurTime())
	self:SetFinishReload(0)

	self:SetNextFire(CurTime())
	self:SetNextAltFire(CurTime())
end
