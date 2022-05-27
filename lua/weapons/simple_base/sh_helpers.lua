AddCSLuaFile()

simple_weapons.Include("Ammo")

function SWEP:IsReady()
	return CurTime() - self:GetLowerTime() >= self.LowerTime
end

function SWEP:GetLowerFraction()
	local frac = math.Clamp(math.Remap(CurTime() - self:GetLowerTime(), 0, self.LowerTime, 0, 1), 0, 1)

	return self:GetLowered() and frac or 1 - frac
end

local easeIn = math.ease.InQuad
local easeOut = math.ease.OutQuad

function SWEP:GetEasedLowerFraction()
	local fraction = self:GetLowerFraction()

	if self:GetLowered() then
		fraction = easeOut(fraction)
	else
		fraction = easeIn(fraction)
	end

	return fraction
end

function SWEP:HasCameraControl()
	local ply = self:GetOwner()

	if CLIENT and not ply:ShouldDrawLocalPlayer() then
		return true
	end

	return ply:GetViewEntity() == ply
end

function SWEP:FiremodeName(firemode)
	if firemode == -1 then
		return "Full-auto"
	elseif firemode == 0 then
		return "Semi-auto"
	else
		return firemode .. "-Round burst"
	end
end

function SWEP:AmmoName(ammo)
	if ammo == 0 then
		return self.DefaultAmmo
	end

	return Ammo[self.AmmoTypes[ammo]].Name
end

function SWEP:SuppressOwner(bool)
	if SERVER then
		SuppressHostEvents(bool and self:GetOwner() or NULL)
	end
end

function SWEP:GetAvailableAmmoTypes()
	local tab = {}
	local ply = self:GetOwner()

	for _, v in ipairs(self.AmmoTypes) do
		if HasAmmo(ply, v) then
			table.insert(tab, v)
		end
	end

	return tab
end

function SWEP:IsFirstPerson()
	if not IsValid(self) or not self:OwnerIsValid() then return false end
	if self:GetOwner():IsNPC() then return false end
	if CLIENT and (not game.SinglePlayer()) and self:GetOwner() ~= GetViewEntity() then return false end
	if sp and SERVER then return not self:GetOwner().TFASDLP end
	if self:GetOwner().ShouldDrawLocalPlayer and self:GetOwner():ShouldDrawLocalPlayer() then return false end
	if LocalPlayer and hook.Call("ShouldDrawLocalPlayer", GAMEMODE, self:GetOwner()) then return false end

	return true
end
