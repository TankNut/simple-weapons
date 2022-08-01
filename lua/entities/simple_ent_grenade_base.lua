AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.AutomaticFrameAdvance = true

ENT.Model = Model("models/weapons/w_npcnade.mdl")

function ENT:SetTimer(delay)
	self.Detonate = CurTime() + delay

	self:NextThink(CurTime())
end

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(5) -- Heavy enough to break windows
		end
	end
end

function ENT:Explode()
	self:Remove()
end

function ENT:Think()
	if CLIENT then
		return
	end

	if self.Detonate and self.Detonate <= CurTime() then
		self:Explode()
		self:NextThink(math.huge)

		return true
	end

	self:NextThink(CurTime() + 0.1)

	return true
end
