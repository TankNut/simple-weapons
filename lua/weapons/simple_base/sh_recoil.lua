AddCSLuaFile()

simple_weapons.Include("Convars")

function SWEP:ApplyRecoil(ply)
	local seed = 0

	if GetPredictionPlayer() == ply then
		seed = ply:GetCurrentCommand():CommandNumber()
	end

	local recoil = self.Primary.Recoil
	local mult = self:GetRecoilMultiplier()

	local pitch = -util.SharedRandom(self:EntIndex() .. seed .. "1", recoil.MinAng.p, recoil.MaxAng.p) * mult
	local yaw = util.SharedRandom(self:EntIndex() .. seed .. "2", recoil.MinAng.y, recoil.MaxAng.y) * mult

	if game.SinglePlayer() or (CLIENT and IsFirstTimePredicted()) then
		ply:SetEyeAngles(ply:EyeAngles() + Angle(pitch, yaw, 0) * recoil.Punch)
	end

	ply:ViewPunch(Angle(pitch, yaw, 0))
end
