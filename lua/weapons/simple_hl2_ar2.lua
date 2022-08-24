AddCSLuaFile()

simple_weapons.Include("Convars")

DEFINE_BASECLASS("simple_base")

SWEP.Base = "simple_base"

SWEP.PrintName = "AR2"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_irifle.mdl")
SWEP.WorldModel = Model("models/weapons/w_irifle.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.Primary = {
	Ammo = "AR2",

	ClipSize = 30,
	DefaultClip = 60,

	Damage = 22,
	Delay = 60 / 600,

	Range = 800,
	Accuracy = 12,

	RangeModifier = 0.98,

	Recoil = {
		MinAng = Angle(0.8, -0.6, 0),
		MaxAng = Angle(1, 0.6, 0),
		Punch = 0.4,
		Ratio = 0.6
	},

	Sound = "Weapon_AR2.Single",
	TracerName = "AR2Tracer"
}

SWEP.Secondary = {
	Ammo = "AR2AltFire",
	ChargeSound = "Weapon_CombineGuard.Special1",
	FireSound = "Weapon_IRifle.Single"
}

SWEP.NPCData = {
	Burst = {2, 5},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay * 2, SWEP.Primary.Delay * 3}
}

list.Add("NPCUsableWeapons", {class = "simple_hl2_ar2", title = "Simple Weapons: " .. SWEP.PrintName})

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:AddNetworkVar("Float", "FireBall")
end

function SWEP:Holster()
	if self:GetFireBall() > 0 then
		return false
	end

	return true
end

function SWEP:OnDeploy()
	BaseClass.OnDeploy(self)

	self:SetFireBall(0)
end

function SWEP:OnHolster(removing, ply)
	BaseClass.OnHolster(self, removing, ply)

	self:SetFireBall(0)
end

function SWEP:DoImpactEffect(tr, dmgtype)
	if tr.HitSky then
		return
	end

	if not game.SinglePlayer() and IsFirstTimePredicted() then
		return
	end

	local effect = EffectData()

	effect:SetOrigin(tr.HitPos + tr.HitNormal)
	effect:SetNormal(tr.HitNormal)

	util.Effect("AR2Impact", effect)
end

-- ACT_VM_RECOIL support
local transitions = {
	[ACT_VM_PRIMARYATTACK] = ACT_VM_RECOIL1,
	[ACT_VM_RECOIL1] = ACT_VM_RECOIL2,
	[ACT_VM_RECOIL2] = ACT_VM_RECOIL3,
	[ACT_VM_RECOIL3] = ACT_VM_RECOIL3
}

function SWEP:TranslateWeaponAnim(act)
	if act == ACT_VM_PRIMARYATTACK then
		local lookup = transitions[self:GetActivity()]

		if lookup then
			act = lookup
		end
	end

	return act
end

function SWEP:CanAlternateAttack()
	if not self:HandleAutoRaise() or self:IsReloading() then
		return false
	end

	if InfiniteAmmo:GetInt() == 0 and self:GetOwner():GetAmmoCount(self.Secondary.Ammo) < 1 then
		self:EmitEmptySound()

		self:SetNextPrimaryFire(CurTime() + 0.2)

		self.Primary.Automatic = false

		return false
	end

	return true
end

function SWEP:AlternateAttack()
	self.Primary.Automatic = false

	self:EmitSound(self.Secondary.ChargeSound)

	self:SendTranslatedWeaponAnim(ACT_VM_FIDGET)
	self:SetNextIdle(0)

	self:SetFireBall(CurTime() + 0.5)

	self:SetNextPrimaryFire(math.huge)
	self:SetNextAlternateAttack(math.huge)
end

function SWEP:Think()
	BaseClass.Think(self)

	local ball = self:GetFireBall()

	if ball > 0 and ball <= CurTime() then
		self:SetFireBall(0)

		local ply = self:GetOwner()

		self:TakeSecondaryAmmo(1)

		self:EmitSound(self.Secondary.FireSound)

		self:SendTranslatedWeaponAnim(ACT_VM_SECONDARYATTACK)

		ply:SetAnimation(PLAYER_ATTACK1)

		if SERVER then
			local ent = ents.Create("prop_combine_ball")

			local ang = ply:GetAimVector():Angle() + ply:GetViewPunchAngles()
			local dir = ang:Forward()

			ent:SetPos(ply:GetShootPos())
			ent:SetAngles(ang)

			ent:SetOwner(ply)

			ent:SetSaveValue("m_flRadius", 10)

			ent:Spawn()
			ent:Activate()

			ent:SetSaveValue("m_nState", 2)

			ent:GetPhysicsObject():SetVelocity(dir * 1000)

			ent:EmitSound("NPC_CombineBall.Launch")

			ent:Fire("Explode", "", 4)
		end

		if ply:IsPlayer() then
			self:ApplyStaticRecoil(ply, Angle(-2, 0, 0))
		end

		self.Primary.Automatic = true

		self:SetNextIdle(CurTime() + self:SequenceDuration())

		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:SetNextAlternateAttack(CurTime() + 1)
	end
end
