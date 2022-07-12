simple_weapons.Include("Convars")
simple_weapons.Include("Enums")

function SWEP:DoDrawCrosshair(x, y)
	if self.OverrideCrosshairDraw then
		return self:OverrideCrosshairDraw(x, y)
	end

	if not self:ShouldHideCrosshair() then
		return self:DrawCrosshair(x, y)
	end

	return true
end

function SWEP:ShouldHideCrosshair()
	return self:GetLowered() or self:IsReloading()
end

function SWEP:DrawCrosshair(x, y)
	return false
end

local convar = GetConVar("developer")

local function debugging()
	return game.SinglePlayer() and convar:GetBool()
end

function SWEP:DrawDebugText(text, line, color)
	surface.SetFont("BudgetLabel")

	local _, offset = surface.GetTextSize("a")

	local x = ScreenScale(5)
	local y = ScrH() * 0.5

	draw.SimpleText(text, "BudgetLabel", x, y + offset * (line or 0), color or color_white)
end

local body = 24
local head = 12

local color_red = Color(255, 0, 0)
local color_green = Color(33, 255, 0)

local sphere_red = Color(255, 0, 0, 50)

function SWEP:DrawHUDBackground()
	if not debugging() then
		return
	end

	local ply = self:GetOwner()
	local dir = (ply:GetAimVector():Angle() + ply:GetViewPunchAngles()):Forward()

	local tr = util.TraceLine({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + dir * 56756,
		mask = MASK_SHOT,
		filter = ply
	})

	local dist = tr.Fraction * 56756
	local damage = self:GetDamage()
	local range, accuracy = self:GetRange()

	self:DrawDebugText(string.format("Firemode: %s", self:GetFiremode()), -4)

	self:DrawDebugText(string.format("Recoil multiplier: %.2f", self:GetRecoilMultiplier()), -2)

	self:DrawDebugText(string.format("Weapon damage: %.2f (%.2fx)", damage, DamageMult:GetFloat()), 0)
	self:DrawDebugText(string.format("Damage falloff: %.2f", self.Primary.RangeModifier), 1)
	self:DrawDebugText(string.format("Weapon range: %.0f at %.0f units (%.2fx)", accuracy, range, RangeMult:GetFloat()), 2)


	self:DrawDebugText(string.format("Aim distance: %.2f units (%.2fx)", dist, dist / range), 4)

	local falloff = self:GetDamageFalloff(dist)

	local col = color_white

	if falloff <= MinDamage:GetFloat() then
		col = color_red
	end

	self:DrawDebugText(string.format("Approximate damage: %.2f (%.2f%%)", damage * falloff, falloff * 100), 5, col)

	local spread = accuracy * (dist / range)

	col = color_red

	if spread <= head then
		col = color_green
	elseif spread <= body then
		col = color_white
	end

	self:DrawDebugText(string.format("Approximate spread: %.2f units", spread), 6, col)

	self:DrawDebugText(string.format("Zoom: %sx", self:GetZoom()), 8)
	self:DrawDebugText(string.format("FOV: %s", self:GetFOV()), 9)

	cam.Start3D()
		render.SetColorMaterial()
		render.DrawSphere(tr.HitPos, spread, 20, 20, sphere_red)
	cam.End3D()
end

function SWEP:CustomAmmoDisplay()
	if self.AmmoType == AMMO_NONE then
		return {Draw = false}
	elseif self.AmmoType == AMMO_INTERNAL then
		return {
			Draw = true,
			PrimaryClip = self:Clip1()
		}
	end
end
