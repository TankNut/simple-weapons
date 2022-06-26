AddCSLuaFile()

DEFINE_BASECLASS("simple_base_scoped")

SWEP.Base = "simple_base_scoped"

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

SWEP.Primary = {
	Ammo = "XBowBolt",

	ClipSize = 1,
	DefaultClip = 1,

	Damage = 120,
	Delay = 0.75,

	Recoil = {
		MinAng = Angle(2, -0.3, 0),
		MaxAng = Angle(3, 0.3, 0),
		Punch = 0.2,
		Ratio = 0.4
	}
}

SWEP.ScopeZoom = 4.5

function SWEP:OnDeploy()
	BaseClass.OnDeploy(self)

	if self:Clip1() > 0 then
		self:GetViewModel():SetSkin(1)
	end
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
		ent:Fire("SetDamage", self:GetDamage())

		ent:Spawn()
		ent:Activate()
	end

	self:GetViewModel():SetSkin(0)
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
