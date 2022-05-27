simple_weapons.Include("Ammo")

local color_bg = Color(0, 0, 0, 76)
local color_fg = Color(255, 235, 20)
local color_fga = Color(255, 48, 0)
local color_fgd = Color(255, 235, 20, 20)

function SWEP:BuildRadialMenu()
	local options = {
		{},
		{"Set Firemode", self.BuildFiremodeMenu, not istable(self.Firemodes)},
		{},
		{"Switch Ammo", self.BuildAmmoMenu, #self:GetAvailableAmmoTypes() < 1},
		{},
		{}
	}

	return options
end

function SWEP:BuildFiremodeMenu()
	local options = {}

	for k, v in ipairs(self.Firemodes) do
		options[k] = {self:FiremodeName(v), function()
			self:SetFiremode(v)

			net.Start("simple_set_firemode")
				net.WriteUInt(k, 3)
			net.SendToServer()

			return true
		end}
	end

	return options
end

function SWEP:BuildAmmoMenu()
	local options = {
		{self.DefaultAmmo, function()
			self:SetAmmoType(0)

			net.Start("simple_set_ammo")
				net.WriteUInt(0, 3)
			net.SendToServer()

			return true
		end}
	}

	for _, v in ipairs(self:GetAvailableAmmoTypes()) do
		local index = table.KeyFromValue(self.AmmoTypes, v)

		table.insert(options, {
			Ammo[v].Name, function()
				self:SetAmmoType(index)

				net.Start("simple_set_ammo")
					net.WriteUInt(index, 3)
				net.SendToServer()

				return true
			end
		})
	end

	return options
end

-- Internal stuff only beyond this point

local circles = include("simple_weapons/circles.lua")

local radius = ScreenScale(100)
local thickness = ScreenScale(50)

function SWEP:OpenRadialMenu(options)
	local background = circles.New(CIRCLE_OUTLINED, radius, ScrW() * 0.5, ScrH() * 0.5, thickness)

	background:SetMaterial(true)
	background:SetColor(color_bg)

	local wedge = circles.New(CIRCLE_OUTLINED, radius, ScrW() * 0.5, ScrH() * 0.5, thickness)

	wedge:SetMaterial(true)
	wedge:SetColor(color_bg)

	wedge:SetEndAngle(360 / #options)

	self.RadialMenu = {
		Options = options,
		Offset = -90 - 360 / #options * 0.5,
		Background = background,
		Wedge = wedge
	}

	gui.EnableScreenClicker(true)
end

function SWEP:CloseRadialMenu()
	self.RadialMenu = nil

	gui.EnableScreenClicker(false)
end

function SWEP:RadialMenuClick()
	local option = self.RadialMenu.Options[self:FindRadialMenuSelection()]

	if option[3] then
		return
	end

	if not option[2] then
		return
	end

	local options = option[2](self)

	if options == true then -- Close menu
		self:CloseRadialMenu()
	elseif istable(options) then -- New menu
		self:OpenRadialMenu(options)
	end
end

function SWEP:FindRadialMenuSelection()
	local radial = self.RadialMenu

	local mouse = Vector(input.GetCursorPos()) - Vector(ScrW() * 0.5, ScrH() * 0.5)
	local ang = math.atan2(mouse[2], mouse[1]) * 180 / math.pi

	ang = ang - radial.Offset

	if ang < 0 then
		ang = 360 + ang
	end

	local mult = 360 / #radial.Options
	local index = math.floor(ang / mult) % #radial.Options

	return index + 1, index * mult + radial.Offset
end

function SWEP:DrawRadialMenu()
	local radial = self.RadialMenu

	radial.Background()

	local selection, rotation = self:FindRadialMenuSelection()

	radial.Wedge:SetRotation(rotation)
	radial.Wedge()

	local size = 360 / #radial.Options

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	for k, v in ipairs(radial.Options) do
		local a = math.rad(size * (k - 1) + size / 2 + radial.Offset)

		local x2 = x + math.cos(a) * Lerp(0.5, thickness, radius)
		local y2 = y + math.sin(a) * Lerp(0.5, thickness, radius)

		local color = color_fg

		if v[3] then
			color = color_fgd
		elseif selection == k then
			color = color_fga
		end

		draw.SimpleText(v[1] or "", "HudDefault", x2, y2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end
