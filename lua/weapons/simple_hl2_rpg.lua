AddCSLuaFile()

DEFINE_BASECLASS("simple_base")

SWEP.Base = "simple_base"

SWEP.PrintName = "RPG"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 4

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_rpg.mdl")
SWEP.WorldModel = Model("models/weapons/w_rocket_launcher.mdl")

SWEP.HoldType = "rpg"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "RPG_Round",

	ClipSize = 1,
	DefaultClip = 3,

	Damage = 120,
	Delay = 0.5,

	Recoil = {
		MinAng = Angle(0, 0, 0),
		MaxAng = Angle(0, 0, 0),
		Punch = 0,
		Ratio = 1
	},

	Sound = "Weapon_RPG.Single"
}

SWEP.NPCData = {
	Burst = {1, 1},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay * 2, SWEP.Primary.Delay * 3}
}

list.Add("NPCUsableWeapons", {class = "simple_hl2_rpg", title = "Simple Weapons: " .. SWEP.PrintName})

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:AddNetworkVar("Bool", "DotEnabled")

	self:AddNetworkVar("Entity", "Dot")
end

function SWEP:SetLower(lower)
	BaseClass.SetLower(self, lower)

	if SERVER then
		if self:GetLowered() then
			SafeRemoveEntity(self:GetDot())
		elseif self:GetDotEnabled() then
			self:CreateDot()
		end
	end
end

function SWEP:AltFire()
	self.Primary.Automatic = false

	self:SetDotEnabled(not self:GetDotEnabled())

	if SERVER then
		if not self:GetLowered() and self:GetDotEnabled() then
			self:CreateDot()
		else
			SafeRemoveEntity(self:GetDot())
		end
	end

	self:EmitSound(self:GetDotEnabled() and "Weapon_RPG.LaserOn" or "Weapon_RPG.LaserOff")
end

if SERVER then
	function SWEP:OnDeploy()
		BaseClass.OnDeploy(self)

		if self.ClassicMode and self:GetDotEnabled() then
			self:CreateDot()
		end
	end

	function SWEP:OnHolster(removing, ply)
		BaseClass.OnHolster(self, removing, ply)

		SafeRemoveEntity(self:GetDot())
	end

	function SWEP:GetNPCBulletSpread(prof)
		return 0
	end

	function SWEP:CreateDot()
		if IsValid(self:GetDot()) then
			return
		end

		local dot = ents.Create("env_laserdot")

		dot:SetOwner(self:GetOwner())

		dot:Spawn()
		dot:Activate()

		dot:SetNoDraw(false)
		dot:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)

		self:SetDot(dot)
	end
end

function SWEP:FireWeapon()
	local ply = self:GetOwner()

	self:EmitFireSound()

	self:SendTranslatedWeaponAnim(ACT_VM_PRIMARYATTACK)

	ply:SetAnimation(PLAYER_ATTACK1)

	if SERVER then
		local ent = ents.Create("rpg_missile")
		local ang = self:GetShootDir():Angle()

		ent:SetPos(LocalToWorld(Vector(12, -6, 3), angle_zero, ply:GetShootPos(), ang))
		ent:SetAngles(ang)

		ent:SetOwner(ply)

		ent:SetVelocity(ang:Forward() * 300 + Vector(0, 0, 128))
		ent:SetSaveValue("m_flDamage", self:GetDamage())

		ent:Spawn()
		ent:Activate()
	end
end

function SWEP:Think()
	BaseClass.Think(self)

	local dot = self:GetDot()

	if IsValid(dot) then
		local ply = self:GetOwner()

		local tr = util.TraceLine({
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 56756,
			mask = MASK_SHOT,
			filter = ply
		})

		if IsValid(tr.Entity) and not tr.Entity:IsWorld() then
			dot:SetSaveValue("m_hTargetEnt", tr.Entity)
		else
			dot:SetSaveValue("m_hTargetEnt", NULL)
		end

		dot:SetPos(tr.HitPos)
		dot:SetSaveValue("m_vecSurfaceNormal", tr.HitNormal)
	end
end

if CLIENT then
	function SWEP:ShouldHideCrosshair()
		return BaseClass.ShouldHideCrosshair(self) or self:GetDotEnabled()
	end
end
