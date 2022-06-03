AddCSLuaFile()

DEFINE_BASECLASS("simple_base")

simple_weapons.Include("Helpers")

SWEP.Base = "simple_base"

SWEP.PrintName = "Crossbow"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 3

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelTargetFOV = 54

SWEP.ViewModel = Model("models/weapons/c_crossbow.mdl")
SWEP.WorldModel = Model("models/weapons/w_crossbow.mdl")

SWEP.HoldType = "ar2"
SWEP.LowerHoldType = "passive"

SWEP.Firemode = 0

SWEP.LowerTime = 0.5

SWEP.Primary = {
	Ammo = "XBowBolt",

	ClipSize = 1,
	DefaultClip = 1,

	Damage = 120,
	Delay = 0.75,

	Recoil = {
		MinAng = Angle(1, -0.3, 0),
		MaxAng = Angle(2, 0.3, 0),
		Punch = 0.2,
		Ratio = 0.6
	}
}

SWEP.Zoom = 2
SWEP.ScopeZoom = 4.5

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar("Bool", 4, "InScope")
end

function SWEP:OnDeploy()
	BaseClass.OnDeploy(self)

	self:SetInScope(false)

	if self:Clip1() > 0 then
		self:GetViewModel():SetSkin(1)
	end
end

function SWEP:OnHolster(removing)
	BaseClass.OnHolster(self, removing)

	self:SetInScope(false)
end

function SWEP:EmitFireSound()
	self:EmitSound("Weapon_Crossbow.Single")
	self:EmitSound("Weapon_Crossbow.BoltFly")
end

function SWEP:FireWeapon()
	local ply = self:GetOwner()

	self:EmitFireSound()

	self:SendTranslatedWeaponAnim(ACT_VM_PRIMARYATTACK)

	ply:SetAnimation(PLAYER_ATTACK1)

	if SERVER then
		local ent = ents.Create("crossbow_bolt")

		local ang = ply:GetAimVector():Angle() + ply:GetViewPunchAngles()
		local dir = ang:Forward()

		ent:SetPos(ply:GetShootPos())
		ent:SetAngles(ang)

		ent:SetOwner(ply)

		ent:SetVelocity(dir * 3500)
		ent:Fire("SetDamage", self.Primary.Damage)

		ent:Spawn()
		ent:Activate()
	end

	self:GetViewModel():SetSkin(0)
end

function SWEP:GetFOV()
	if self:GetLowered() then
		return 0
	end

	local desired = self:GetOwner():GetInfo("fov_desired")

	return self:GetInScope() and desired / self.ScopeZoom or desired / self.Zoom
end

function SWEP:SetScope(bool)
	if self:GetInScope() == bool then
		return
	end

	self:SetInScope(bool)

	self:GetOwner():SetFOV(self:GetFOV(), 0.2, self)
	--self:EmitSound("Default.Zoom") CS:S content so we can't use it
end

function SWEP:CanAlternateAttack()
	if self:GetLowered() then
		return false
	end

	return BaseClass.CanAlternateAttack(self)
end

function SWEP:AlternateAttack()
	self.Primary.Automatic = false

	self:SetScope(not self:GetInScope())
end

function SWEP:TranslateWeaponAnim(act)
	if self:Clip1() == 0 and act == ACT_VM_IDLE then
		return ACT_VM_FIDGET
	end

	return act
end

function SWEP:FireAnimationEvent(_, _, event)
	if event == 3005 then
		self:GetViewModel():SetSkin(1)
		self:EmitSound("Weapon_Crossbow.BoltElectrify")
	end
end
