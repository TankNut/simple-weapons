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
		Damage = 40,
		DamageType = DMG_CLUB,

		Range = 75,
		Delay = 0.8,

		Act = {ACT_VM_HITCENTER, ACT_VM_MISSCENTER},

		Sound = {"Weapon_StunStick.Melee_Hit", "Weapon_StunStick.Swing"}
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
	local vmGlow2 = Material("sprites/light_glow02_add")

	local wmGlow = Material("effects/blueflare1")

	local function translatefov(fov, pos, inverse)
		local worldx = math.tan(LocalPlayer():GetFOV() * (math.pi / 360))
		local viewx = math.tan(fov * (math.pi / 360))

		local factor = Vector(worldx / viewx, worldx / viewx, 0)
		local tmp = pos - EyePos()

		local eye = EyeAngles()
		local transformed = Vector(eye:Right():Dot(tmp), eye:Up():Dot(tmp), eye:Forward():Dot(tmp))

		if inverse then
			transformed.x = transformed.x / factor.x
			transformed.y = transformed.y / factor.y
		else
			transformed.x = transformed.x * factor.x
			transformed.y = transformed.y * factor.y
		end

		local out = (eye:Right() * transformed.x) + (eye:Up() * transformed.y) + (eye:Forward() * transformed.z)

		return EyePos() + out
	end

	local exceptions = {
		[1] = true,
		[2] = true,
		[9] = true
	}

	function SWEP:PostDrawViewModel(vm, weapon, ply)
		if not self:GetLowered() then
			local att = vm:GetAttachment(vm:LookupAttachment("sparkrear"))

			render.SetMaterial(vmGlow2)

			local scale = math.Rand(4, 6)

			render.DrawSprite(translatefov(self.ViewModelFOV, att.Pos, true), scale, scale)

			render.SetMaterial(vmGlow)

			for i = 1, 9 do
				if exceptions[i] then
					continue
				end

				att = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "a"))

				if att then
					vmGlow:SetFloat("$alpha", math.Rand(0.05, 0.5))

					render.DrawSprite(translatefov(self.ViewModelFOV, att.Pos, true), 1, 1)
				end

				att = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))

				if att then
					vmGlow:SetFloat("$alpha", math.Rand(0.05, 0.5))

					render.DrawSprite(translatefov(self.ViewModelFOV, att.Pos, true), 1, 1)
				end
			end

			vmGlow:SetFloat("$alpha", 1)
			vmGlow2:SetFloat("$alpha", 1)
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
