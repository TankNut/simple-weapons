AddCSLuaFile()

DEFINE_BASECLASS("simple_base_melee")

SWEP.Base = "simple_base_melee"

SWEP.RenderGroup = RENDERGROUP_BOTH

SWEP.PrintName = "Stunstick"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 0

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelFOV = 54

SWEP.ViewModel = Model("models/weapons/c_stunstick.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.HoldType = "melee"
SWEP.LowerHoldType = "normal"

SWEP.Primary = {
	ChargeTime = 0.4,

	Light = {
		Damage = 36,
		DamageType = DMG_CLUB,

		Range = 75,
		Delay = 0.6,

		Act = {ACT_VM_HITCENTER, ACT_VM_MISSCENTER},

		Sound = {"Weapon_StunStick.Melee_HitWorld", "Weapon_StunStick.Swing"}
	},

	Heavy = {
		Damage = 60,
		DamageType = DMG_CLUB,

		Range = 100,
		Delay = 1,

		Act = ACT_VM_MISSCENTER,

		Sound = {"Weapon_StunStick.Melee_Hit", "Weapon_StunStick.Swing"}
	}
}

SWEP.ChargeOffset = {
	Pos = Vector(-15, 0, -10),
	Ang = Angle(-35)
}

function SWEP:SetLower(lower)
	local ok = BaseClass.SetLower(self, lower)

	if ok then
		self:EmitSound(lower and "Weapon_StunStick.Deactivate" or "Weapon_StunStick.Activate")
	end
end

function SWEP:GenericAttack(heavy)
	local hit, trace = BaseClass.GenericAttack(self, heavy)

	if hit and SERVER then
		local effect = EffectData()

		effect:SetOrigin(trace.HitPos + trace.HitNormal)
		effect:SetNormal(trace.HitNormal)

		util.Effect("StunstickImpact", effect, false, true)
	end
end

if CLIENT then
	local vmGlow = Material("sprites/light_glow02_add_noz")
	local wmGlow = Material("effects/blueflare1")

	function SWEP:PostDrawViewModel(vm, weapon, ply)
		if not self:GetLowered() then
			cam.Start3D()
				render.SetMaterial(vmGlow)

				for i = 1, 18 do
					local att = vm:GetAttachment(i)

					if att then
						local size = math.Rand(4, 5)

						vmGlow:SetFloat("$alpha", math.Rand(0.05, 0.5))

						render.DrawSprite(att.Pos, size, size, color)
					end
				end

				vmGlow:SetFloat("$alpha", 1)
			cam.End3D()
		end
	end

	function SWEP:DrawWorldModelTranslucent(flags)
		if not self:GetLowered() then
			local size = math.Rand(4, 6)
			local glow = math.Rand(0.6, 0.8) * 255

			local att = self:GetAttachment(1)

			if att then
				render.SetMaterial(wmGlow)
				render.DrawSprite(att.Pos, size * 2, size * 2, Color(glow, glow, glow))
			end
		end
	end
end
