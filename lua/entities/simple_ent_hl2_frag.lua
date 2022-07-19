AddCSLuaFile()

simple_weapons.Include("Convars")

DEFINE_BASECLASS("simple_ent_grenade_base")

ENT.Base = "simple_ent_grenade_base"

ENT.Model = Model("models/weapons/w_npcnade.mdl")

ENT.Damage = 100

function ENT:SetTimer(delay)
	BaseClass.SetTimer(self, delay)

	self.Beep = CurTime()
end

function ENT:Initialize()
	BaseClass.Initialize(self)

	if SERVER then
		local attachment = self:LookupAttachment("fuse")

		if attachment <= 0 then
			return
		end

		local pos = self:GetAttachment(attachment).Pos

		local main = ents.Create("env_sprite")

		main:SetPos(pos)
		main:SetParent(self)
		main:SetKeyValue("model", "sprites/redglow1.vmt")
		main:SetKeyValue("scale", 0.2)
		main:SetKeyValue("GlowProxySize", 4)
		main:SetKeyValue("rendermode", 5)
		main:SetKeyValue("renderamt", 200)
		main:Spawn()
		main:Activate()

		local trail = ents.Create("env_spritetrail")

		trail:SetPos(pos)
		trail:SetParent(self)
		trail:SetKeyValue("spritename", "sprites/bluelaser1.vmt")
		trail:SetKeyValue("startwidth", 8)
		trail:SetKeyValue("endwidth", 1)
		trail:SetKeyValue("lifetime", 0.5)
		trail:SetKeyValue("rendermode", 5)
		trail:SetKeyValue("rendercolor", "255 0 0")
		trail:Spawn()
		trail:Activate()

		self:DeleteOnRemove(main)
		self:DeleteOnRemove(trail)
	end
end

function ENT:Explode()
	local pos = self:WorldSpaceCenter()

	local explo = ents.Create("env_explosion")
	explo:SetOwner(self:GetOwner())
	explo:SetPos(pos)
	explo:SetKeyValue("iMagnitude", self.Damage * DamageMult:GetFloat())
	explo:SetKeyValue("spawnflags", 32)
	explo:Spawn()
	explo:Activate()
	explo:Fire("Explode")

	self:Remove()
end

function ENT:Think()
	if SERVER and self.Beep and self.Beep <= CurTime() then
		self:EmitSound("Grenade.Blip")

		local time = 1

		if self.Detonate and self.Detonate - CurTime() <= 1.5 then
			time = 0.3
		end

		self.Beep = CurTime() + time
	end

	BaseClass.Think(self)

	return true
end
