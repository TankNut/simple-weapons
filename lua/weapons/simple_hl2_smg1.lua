AddCSLuaFile()

simple_weapons.Include("Convars")

SWEP.Base = "simple_base"

SWEP.PrintName = "SMG"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 2

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_smg1.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg1.mdl")

SWEP.HoldType = "smg"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = -1

SWEP.Primary = {
	Ammo = "SMG1",

	ClipSize = 45,
	DefaultClip = 45,

	Damage = 11,
	Delay = 60 / 800,

	Range = 300,
	Accuracy = 12,

	RangeModifier = 0.85,

	Recoil = {
		MinAng = Angle(0.7, -0.4, 0),
		MaxAng = Angle(0.9, 0.4, 0),
		Punch = 0.4,
		Ratio = 0.4
	},

	Reload = {
		Sound = "Weapon_SMG1.Reload"
	},

	Sound = "Weapon_SMG1.Single",
	TracerName = "Tracer"
}

SWEP.Secondary = {
	Ammo = "SMG1_Grenade"
}

SWEP.NPCData = {
	Burst = {3, 5},
	Delay = SWEP.Primary.Delay,
	Rest = {SWEP.Primary.Delay * 3, SWEP.Primary.Delay * 5}
}

list.Add("NPCUsableWeapons", {class = "simple_hl2_smg1", title = "Simple Weapons: " .. SWEP.PrintName})

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

	if self:IsReloading() then
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
	local ply = self:GetOwner()

	self:TakeSecondaryAmmo(1)

	self:EmitSound("Weapon_SMG1.Double")

	self:SendTranslatedWeaponAnim(ACT_VM_SECONDARYATTACK)

	ply:SetAnimation(PLAYER_ATTACK1)

	if SERVER then
		local ent = ents.Create("simple_ent_hl2_40mm")

		local ang = ply:GetAimVector():Angle() + ply:GetViewPunchAngles()
		local dir = ang:Forward()

		ent:SetPos(ply:GetShootPos())
		ent:SetAngles(ang)

		ent:SetOwner(ply)

		ent:SetVelocity(dir * 1000)

		ent:Spawn()
		ent:Activate()
	end

	self:ApplyRecoil()

	self.Primary.Automatic = true

	self:SetNextIdle(CurTime() + self:SequenceDuration())
	self:SetNextPrimaryFire(CurTime() + 0.5)
	self:SetNextAlternateAttack(CurTime() + 1)
end
