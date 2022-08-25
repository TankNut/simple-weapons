AddCSLuaFile()

simple_weapons.Include("Convars")

function SWEP:ApplyRecoil(recoil)
	local ply = self:GetOwner()

	if not ply:IsPlayer() then
		return
	end

	recoil = recoil or self.Primary.Recoil

	local seed = ply:GetCurrentCommand():CommandNumber()
	local mult = self:GetRecoilMultiplier()

	local pitch = -util.SharedRandom(self:EntIndex() .. seed .. "1", recoil.MinAng.p, recoil.MaxAng.p) * mult
	local yaw = util.SharedRandom(self:EntIndex() .. seed .. "2", recoil.MinAng.y, recoil.MaxAng.y) * mult

	if game.SinglePlayer() or (CLIENT and IsFirstTimePredicted()) then
		ply:SetEyeAngles(ply:EyeAngles() + Angle(pitch, yaw, 0) * recoil.Punch)
	end

	ply:ViewPunch(Angle(pitch, yaw, 0))
end

function SWEP:ApplyStaticRecoil(ang, recoil)
	local ply = self:GetOwner()

	if not ply:IsPlayer() then
		return
	end

	recoil = recoil or self.Primary.Recoil

	local mult = self:GetRecoilMultiplier()

	local pitch = ang.p * mult
	local yaw = ang.y * mult

	if game.SinglePlayer() or (CLIENT and IsFirstTimePredicted()) then
		ply:SetEyeAngles(ply:EyeAngles() + Angle(pitch, yaw, 0) * recoil.Punch)
	end

	ply:ViewPunch(Angle(pitch, yaw, 0))
end
