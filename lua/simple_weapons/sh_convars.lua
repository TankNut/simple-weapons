AddCSLuaFile()

module("simple_weapons.Convars", package.seeall)

InfiniteAmmo = CreateConVar("simple_weapons_infinite_ammo", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Ammo mode to use for weapons. 0 = standard behavior, 1 = infinite reserves, 2 = bottomless magazines", 0, 2)

if CLIENT then
	AltOffset = CreateClientConVar("simple_weapons_alt_offset", 0, true, false, "Use a slightly higher viewmodel position.", 0, 1)
end
