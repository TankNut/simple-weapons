module("simple_weapons", package.seeall)

local blacklist = {
	["BaseClass"] = true,
	["_M"] = true,
	["_NAME"] = true,
	["_PACKAGE"] = true
}

Weapons = Weapons or {}

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

include("simple_weapons/sh_convars.lua")
include("simple_weapons/sh_helpers.lua")
