function SWEP:GetCapabilities()
	return bit.bor(CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1)
end

function SWEP:GetNPCBulletSpread(prof)
	return 5 - prof
end

function SWEP:GetNPCBurstSettings()
	local npc = self.NPCData

	return npc.Burst[1], npc.Burst[2], npc.Delay
end

function SWEP:GetNPCRestTimes()
	local npc = self.NPCData

	return npc.Rest[1], npc.Rest[2]
end
