AddCSLuaFile()

SWEP.Kind = WEAPON_NONE

SWEP.AutoSpawnable = false

SWEP.CanBuy = nil
SWEP.InLoadoutFor = nil

SWEP.AllowDrop = true
SWEP.IsSilent = false

SWEP.fingerprints = {}

if CLIENT then
	SWEP.EquipMenuData = nil
	SWEP.Icon = "vgui/ttt/icon_nades"
end

function SWEP:IsEquipment()
	return WEPS.IsEquipment(self)
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
	return self.Primary.Count > 1 and 1 or 2
end

if CLIENT then
	local sights_opacity = CreateConVar("ttt_ironsights_crosshair_opacity", "0.8", FCVAR_ARCHIVE)
	local crosshair_brightness = CreateConVar("ttt_crosshair_brightness", "1.0", FCVAR_ARCHIVE)
	local crosshair_size = CreateConVar("ttt_crosshair_size", "1.0", FCVAR_ARCHIVE)
	local disable_crosshair = CreateConVar("ttt_disable_crosshair", "0", FCVAR_ARCHIVE)

	local function yres(y)
		return y * (ScrH() / 480)
	end

	function SWEP:OverrideCrosshairDraw(x, y)
		if disable_crosshair:GetBool() then
			return
		end

		local ply = LocalPlayer()

		local alpha = sights_opacity:GetFloat() or 1
		local brightness = crosshair_brightness:GetFloat() or 1

		if ply.IsTraitor and ply:IsTraitor() then
			surface.SetDrawColor(brightness * 255, brightness * 50, brightness * 50, alpha * 255)
		else
			surface.SetDrawColor(0, brightness * 255, 0, alpha * 255)
		end

		local fov = math.rad(ply:GetFOV()) * 0.5

		local frac = (1 - self:GetLowerFraction())

		local gap = yres(self:GetSpread().x * 320 / math.tan(fov)) * frac
		local size = math.max(crosshair_size:GetFloat() * 6 * frac, 1)

		surface.DrawLine(x - gap - size, y, x - gap, y)
		surface.DrawLine(x + gap, y, x + gap + size, y)

		surface.DrawLine(x, y - gap - size, x, y - gap)
		surface.DrawLine(x, y + gap, x, y + gap + size)

		return true
	end
else
	function SWEP:DampenDrop()
		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:SetVelocityInstantaneous(Vector(0, 0, -75) + phys:GetVelocity() * 0.001)
			phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
		end
	end
end
