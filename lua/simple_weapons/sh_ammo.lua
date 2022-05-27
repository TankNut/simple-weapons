AddCSLuaFile()

module("simple_weapons.Ammo", package.seeall)

Ammo = Ammo or {}
NWList = NWList or {}

simple_weapons.Include("Convars")

function GetAmmoKey(id)
	local key = string.format("sw_ammo_%s", string.lower(id))

	if not NWList[key] then
		return
	end

	return key
end

function RegisterAmmo(id, name, callback)
	id = string.lower(id)

	local ammo = {
		Name = name,
		Callback = callback
	}

	local abort = hook.Run("SimpleWeapons_RegisterAmmo", id, ammo)

	if abort then
		return
	end

	ammo.ID = id

	Ammo[id] = ammo

	NWList[string.format("sw_ammo_%s", id)] = true
end

function HasAmmo(ply, id)
	local key = GetAmmoKey(id)

	if not key then
		return false
	end

	local mode = AmmoMethod:GetInt()

	if mode == 0 then
		return false
	elseif mode == 2 then
		return true
	end

	return ply:GetNWBool(key, false)
end

function SetAmmo(ply, id, bool)
	local key = GetAmmoKey(id)

	if not key or AmmoMethod:GetInt() != 1 then
		return
	end

	ply:SetNWBool(key, bool)
end

function ClearAmmo(ply)
	for k in pairs(NWList) do
		ply:SetNWBool(k, false)
	end
end

local meta = {}

function meta:__index(key)
	self[key] = setmetatable({}, meta)

	return self[key]
end

function CreateAmmoTable()
	return setmetatable({}, meta)
end

local function loadFiles(path)
	for _, v in pairs(file.Find("simple_weapons/" .. path .. "/*.lua", "LUA")) do
		include("simple_weapons/" .. path .. "/" .. v)
	end
end

hook.Add("InitPostEntity", "simple_weapons_ammo", function()
	loadFiles("base_ammo")
	loadFiles("ammo")
end)
