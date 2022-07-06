module("simple_weapons", package.seeall)

local blacklist = {
	["BaseClass"] = true,
	["_M"] = true,
	["_NAME"] = true,
	["_PACKAGE"] = true
}

function Include(name, tab)
	local lib = getfenv(1)

	if not lib[name] then
		return
	end

	local fenv = getfenv(2)

	if fenv == _G then
		fenv = setmetatable({}, {__index = _G})

		setfenv(2, fenv)
	end

	if tab then
		fenv[tab] = lib[name]
	else
		for k, v in pairs(lib[name]) do
			if blacklist[k] or isnumber(k) then
				continue
			end

			fenv[k] = v
		end
	end
end

function FormatViewModelAttachment(nFOV, vOrigin, bFrom)
	local vEyePos = EyePos()
	local aEyesRot = EyeAngles()
	local vOffset = vOrigin - vEyePos
	local vForward = aEyesRot:Forward()

	local nViewX = math.tan(nFOV * math.pi / 360)

	if (nViewX == 0) then
		vForward:Mul(vForward:Dot(vOffset))
		vEyePos:Add(vForward)

		return vEyePos
	end

	-- FIXME: LocalPlayer():GetFOV() should be replaced with EyeFOV() when it's binded
	local nWorldX = math.tan(LocalPlayer():GetFOV() * math.pi / 360)

	if (nWorldX == 0) then
		vForward:Mul(vForward:Dot(vOffset))
		vEyePos:Add(vForward)

		return vEyePos
	end

	local vRight = aEyesRot:Right()
	local vUp = aEyesRot:Up()

	if (bFrom) then
		local nFactor = nWorldX / nViewX
		vRight:Mul(vRight:Dot(vOffset) * nFactor)
		vUp:Mul(vUp:Dot(vOffset) * nFactor)
	else
		local nFactor = nViewX / nWorldX
		vRight:Mul(vRight:Dot(vOffset) * nFactor)
		vUp:Mul(vUp:Dot(vOffset) * nFactor)
	end

	vForward:Mul(vForward:Dot(vOffset))

	vEyePos:Add(vRight)
	vEyePos:Add(vUp)
	vEyePos:Add(vForward)

	return vEyePos
end

include("simple_weapons/sh_convars.lua")
include("simple_weapons/sh_enums.lua")
include("simple_weapons/sh_hooks.lua")

AddCSLuaFile("simple_weapons/cl_ui.lua")

if CLIENT then
	include("simple_weapons/cl_ui.lua")
else
	resource.AddWorkshop("2821862386")
end
