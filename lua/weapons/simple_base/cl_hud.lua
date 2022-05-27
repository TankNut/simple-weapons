local color_bg = Color(0, 0, 0, 76)
local color_fg = Color(255, 235, 20)

local box = function(x, y, w, h, margin)
	draw.RoundedBox(8, x - margin, y - margin, w + margin * 2, h + margin * 2, color_bg)
end

function SWEP:DrawHUD()
	local text = {}

	if #self.AmmoTypes > 0 then
		table.insert(text, self:AmmoName(self:GetAmmoIndex()))
	end

	if istable(self.Firemodes) then
		table.insert(text, self:FiremodeName(self:GetFiremode()))
	end

	if #text > 0 then
		local x = ScrW() - 45
		local y = ScrH() - 118

		text = table.concat(text, ", ")

		surface.SetFont("HudDefault")

		local w, h = surface.GetTextSize(text)

		box(x - w, y - h, w, h, 5)

		draw.SimpleText(text, "HudDefault", x - w, y - h, color_fg, TEXT_ALIGN_TOP, TEXT_ALIGN_LEFT)
	end

	if self.RadialMenu then
		self:DrawRadialMenu()
	end
end

function SWEP:DoDrawCrosshair(x, y)
	return self:GetLowered()
end
