AddCSLuaFile()

simple_weapons.Include("Convars")

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.AutomaticFrameAdvance = true

ENT.Model = Model("models/weapons/ar2_grenade.mdl")

ENT.Damage = 100

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInitBox(Vector(-0.3, -0.3, -0.3), Vector(0.3, 0.3, 0.3))
		self:SetMoveType(MOVETYPE_FLYGRAVITY, MOVECOLLIDE_FLY_BOUNCE)

		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

		self:SetGravity(0.5)

		local trail = ents.Create("env_smoketrail")

		trail:SetSaveValue("m_Opacity", 0.2)
		trail:SetSaveValue("m_SpawnRate", 48)
		trail:SetSaveValue("m_ParticleLifetime", 1)

		trail:SetSaveValue("m_StartColor", Vector(0.1, 0.1, 0.1))
		trail:SetSaveValue("m_EndColor", Vector(0, 0, 0))

		trail:SetSaveValue("m_StartSize", 12)
		trail:SetSaveValue("m_EndSize", 48)

		trail:SetSaveValue("m_SpawnRadius", 4)

		trail:SetSaveValue("m_MinSpeed", 4)
		trail:SetSaveValue("m_MaxSpeed", 24)

		trail:SetPos(self:GetPos())
		trail:SetAngles(self:GetAngles())

		trail:SetParent(self)

		trail:Spawn()
		trail:Activate()

		self:DeleteOnRemove(trail)
	end
end

function ENT:Think()
	self:SetAngles(self:GetVelocity():Angle())
end

if SERVER then
	function ENT:Touch(ent)
		if self:GetTouchTrace().HitSky then
			SafeRemoveEntity(self)

			return
		end

		if bit.band(ent:GetSolidFlags(), FSOLID_VOLUME_CONTENTS + FSOLID_TRIGGER) > 0 then
			local takedamage = ent:GetSaveTable().m_takedamage

			if takedamage == 0 or takedamage == 1 then
				return
			end
		end

		local pos = self:WorldSpaceCenter()

		local explo = ents.Create("env_explosion")
		explo:SetOwner(self:GetOwner())
		explo:SetPos(pos)
		explo:SetKeyValue("iMagnitude", self.Damage * DamageMult:GetFloat())
		explo:SetKeyValue("spawnflags", 32)
		explo:Spawn()
		explo:Activate()
		explo:Fire("Explode")

		SafeRemoveEntity(self)
	end
end
