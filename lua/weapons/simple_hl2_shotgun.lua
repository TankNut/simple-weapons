AddCSLuaFile()

DEFINE_BASECLASS("simple_base")

SWEP.Base = "simple_base"

SWEP.PrintName = "Shotgun"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_shotgun.mdl")
SWEP.WorldModel = Model("models/weapons/w_shotgun.mdl")

SWEP.HoldType = "shotgun"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = 0

SWEP.Primary = {
	Ammo = "Buckshot",

	ClipSize = 6,
	DefaultClip = 6,

	PumpAction = true,
	PumpSound = "Weapon_Shotgun.Special1",

	Damage = 17,
	Count = 7,

	Delay = -1,

	Range = 400,
	Accuracy = 24,

	RangeModifier = 0.7,

	Recoil = {
		MinAng = Angle(2, -0.7, 0),
		MaxAng = Angle(3, 0.7, 0),
		Punch = 0.5,
		Ratio = 0
	},

	Reload = {
		Amount = 1,
		Shotgun = true,
		Sound = "Weapon_Shotgun.Reload",
	},

	Sound = "Weapon_Shotgun.Single",
	TracerName = "Tracer"
}

SWEP.Secondary = {
	Count = 12,

	Recoil = {
		MinAng = Angle(5, -2, 0),
		MaxAng = Angle(5, 2, 0),
		Punch = 0.5,
		Ratio = 0
	},

	Sound = "Weapon_Shotgun.Double"
}

SWEP.NPCData = {
	Burst = {1, 2},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay * 2, SWEP.Primary.Delay * 3}
}

list.Add("NPCUsableWeapons", {class = "simple_hl2_shotgun", title = "Simple Weapons: " .. SWEP.PrintName})

function SWEP:CanAlternateAttack()
	if self:GetNextPrimaryFire() > CurTime() then
		return
	end

	return BaseClass.CanPrimaryAttack(self)
end

function SWEP:AlternateAttack()
	self.Primary.Automatic = false

	if self:Clip1() == 1 then
		self:ConsumeAmmo()
		self:FireWeapon()

		local delay = self:GetDelay()

		self:ApplyRecoil()

		if self:ShouldPump() then
			self:SetNeedPump(true)
		end

		self:SetNextIdle(CurTime() + self:SequenceDuration())
		self:SetNextPrimaryFire(CurTime() + delay)

		return
	end

	self:TakePrimaryAmmo(2)
	self:FireWeaponDouble()

	self:ApplyRecoil(self.Secondary.Recoil)
	self:SetNeedPump(true)

	local time = CurTime() + self:SequenceDuration()

	self:SetNextIdle(time)
	self:SetNextPrimaryFire(time)
end

function SWEP:FireWeaponDouble()
	local ply = self:GetOwner()
	local primary = self.Primary
	local secondary = self.Secondary

	self:EmitSound(self.Secondary.Sound)

	self:SendTranslatedWeaponAnim(ACT_VM_SECONDARYATTACK)

	ply:SetAnimation(PLAYER_ATTACK1)

	local damage = self:GetDamage()

	local bullet = {
		Num = secondary.Count,
		Src = ply:GetShootPos(),
		Dir = self:GetShootDir(),
		Spread = self:GetSpread(),
		TracerName = primary.TracerName,
		Tracer = primary.TracerName == "" and 0 or 1,
		Force = damage * 0.25,
		Damage = damage,
		Callback = function(attacker, tr, dmginfo)
			dmginfo:ScaleDamage(self:GetDamageFalloff(tr.StartPos:Distance(tr.HitPos)))
		end
	}

	self:ModifyBulletTable(bullet)

	ply:FireBullets(bullet)
end
