AddCSLuaFile()

simple_weapons.Include("Convars")

SWEP.Base = "weapon_base"

SWEP.m_WeaponDeploySpeed = 1

SWEP.DrawWeaponInfoBox = false

SWEP.ViewModelFOV = 54

SWEP.SimpleWeapon = true
SWEP.SimpleWeaponThrowing = true

SWEP.HoldType = "grenade"
SWEP.LowerHoldType = "normal"

SWEP.Primary.Ammo = ""
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Primary.ThrowAct = {ACT_VM_PULLBACK_HIGH, ACT_VM_THROW}
SWEP.Primary.LobAct = {ACT_VM_PULLBACK_LOW, ACT_VM_HAULBACK}
SWEP.Primary.RollAct = {ACT_VM_PULLBACK_LOW, ACT_VM_SECONDARYATTACK}

SWEP.Secondary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false

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

	self:AddNetworkVar("Int", "ThrowMode")

	self:AddNetworkVar("Float", "NextIdle")
	self:AddNetworkVar("Float", "FinishThrow")
	self:AddNetworkVar("Float", "FinishReload")
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
	self:SetHoldType(self.LowerHoldType)

	self:SetNextIdle(CurTime() + self:SendTranslatedWeaponAnim(ACT_VM_DRAW))
end

function SWEP:Holster()
	return true
end

function SWEP:CanThrow()
	if self:GetFinishThrow() > 0 then
		return false
	end

	if self:GetFinishReload() > 0 then
		return false
	end

	return true
end

function SWEP:EmitThrowSound()
	self:EmitSound("WeaponFrag.Throw")
end

function SWEP:PrimaryAttack()
	if not self:CanThrow() then
		return
	end

	self:SetThrowMode(1)
	self:SetFinishThrow(CurTime() + self:SendTranslatedWeaponAnim(self.Primary.ThrowAct[1]))
	self:SetNextIdle(0)

	self:SetHoldType(self.HoldType)
end

function SWEP:SecondaryAttack()
	if not self:CanThrow() then
		return
	end

	local duration = 0

	if self:GetOwner():Crouching() then
		duration = self:SendTranslatedWeaponAnim(self.Primary.RollAct[1])
		self:SetThrowMode(3)
	else
		duration = self:SendTranslatedWeaponAnim(self.Primary.LobAct[1])
		self:SetThrowMode(2)
	end

	self:SetFinishThrow(CurTime() + duration)
	self:SetNextIdle(0)

	self:SetHoldType(self.HoldType)
end

function SWEP:Throw()
	local ply = self:GetOwner()

	ply:SetAnimation(PLAYER_ATTACK1)

	self:EmitThrowSound()

	local mode = self:GetThrowMode()

	if SERVER then
		self:ThrowEntity(mode)
	end

	local act

	if mode == 1 then
		act = self.Primary.ThrowAct[2]
	elseif mode == 2 then
		act = self.Primary.LobAct[2]
	elseif mode == 3 then
		act = self.Primary.RollAct[2]
	end

	self:SetFinishReload(CurTime() + self:SendTranslatedWeaponAnim(act))

	if InfiniteAmmo:GetInt() == 0 then
		self:TakePrimaryAmmo(1)
	end
end

if SERVER then
	function SWEP:GetThrowPosition(pos)
		local ply = self:GetOwner()
		local tr = util.TraceHull({
			start = ply:EyePos(),
			endpos = pos,
			mins = Vector(-4, -4, -4),
			maxs = Vector(4, 4, 4),
			filter = ply
		})

		return tr.Hit and tr.HitPos or pos
	end

	function SWEP:CreateEntity()
	end

	function SWEP:ThrowEntity(mode)
		local ply = self:GetOwner()
		local ent = self:CreateEntity()

		if not IsValid(ent) then
			return
		end

		local phys = ent:GetPhysicsObject()

		if not IsValid(phys) then
			return
		end

		if mode == 1 then
			local pos = LocalToWorld(Vector(18, -8, 0), angle_zero, ply:GetShootPos(), ply:GetAimVector():Angle())

			ent:SetPos(self:GetThrowPosition(pos))

			phys:SetVelocity(ply:GetVelocity() + (ply:GetForward() + Vector(0, 0, 0.1)) * 1200)
			phys:AddAngleVelocity(Vector(600, math.random(-1200, 1200), 0))
		elseif mode == 3 then
			local pos = ply:GetPos() + Vector(0, 0, 4)
			local facing = ply:GetAimVector()

			facing.z = 0
			facing = facing:GetNormalized()

			local tr = util.TraceLine({
				start = pos,
				endpos = pos + Vector(0, 0, -16),
				filter = ply
			})

			if tr.Fraction != 1 then
				local tan = facing:Cross(tr.Normal)

				facing = tr.Normal:Cross(tan)
			end

			pos = pos + (facing * 18)

			ent:SetPos(self:GetThrowPosition(pos))
			ent:SetAngles(Angle(0, ply:GetAngles().y, -90))

			phys:SetVelocity(ply:GetVelocity() + ply:GetForward() * 700)
			phys:AddAngleVelocity(Vector(0, 0, 720))
		elseif mode == 2 then
			local pos = LocalToWorld(Vector(18, -8, 0), angle_zero, ply:GetShootPos(), ply:GetAimVector():Angle())

			ent:SetPos(self:GetThrowPosition(pos))

			phys:SetVelocity(ply:GetVelocity() + (ply:GetForward() * 350) + Vector(0, 0, 50))
			phys:AddAngleVelocity(Vector(200, math.random(-600, 600), 0))
		end
	end
end

function SWEP:TranslateWeaponAnim(act)
	return act
end

function SWEP:SendTranslatedWeaponAnim(act)
	act = self:TranslateWeaponAnim(act)

	if not act then
		return
	end

	self:SendWeaponAnim(act)

	return self:SequenceDuration(self:SelectWeightedSequence(act))
end

function SWEP:FinishReload()
	local ply = self:GetOwner()

	if ply:GetAmmoCount(self.Primary.Ammo) <= 0 then
		if SERVER then
			ply:StripWeapon(self.ClassName)
		end

		return false
	end

	local time = CurTime() + self:SendTranslatedWeaponAnim(ACT_VM_DRAW)

	self:SetNextIdle(time)

	self:SetNextPrimaryFire(time)
	self:SetNextSecondaryFire(time)

	self:SetHoldType(self.LowerHoldType)

	return true
end

function SWEP:Think()
	local idle = self:GetNextIdle()

	if idle > 0 and idle <= CurTime() then
		self:SendTranslatedWeaponAnim(ACT_VM_IDLE)

		self:SetNextIdle(0)
	end

	local reload = self:GetFinishReload()

	if reload > 0 and reload <= CurTime() then
		self:FinishReload()

		self:SetFinishReload(0)
	end

	local throw = self:GetFinishThrow()

	if throw > 0 and throw <= CurTime() and not self:GetOwner():KeyDown(self:GetThrowMode() == 1 and IN_ATTACK or IN_ATTACK2) then
		self:Throw()

		self:SetFinishThrow(0)
	end
end

function SWEP:OnReloaded()
	self:SetWeaponHoldType(self:GetHoldType())
end

if CLIENT then
	function SWEP:DoDrawCrosshair(x, y)
		return self:GetFinishThrow() == 0
	end

	function SWEP:CustomAmmoDisplay()
		return {
			Draw = true,
			PrimaryClip = self:GetOwner():GetAmmoCount(self.Primary.Ammo)
		}
	end
end

function SWEP:OnRestore()
	self:SetNextIdle(CurTime())
	self:SetFinishThrow(0)
	self:SetFinishReload(0)
end
