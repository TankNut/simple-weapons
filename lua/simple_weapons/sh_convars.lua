AddCSLuaFile()

module("simple_weapons.Convars", package.seeall)

InfiniteAmmo = CreateConVar("simple_weapons_infinite_ammo", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Ammo mode to use for weapons. 0 = standard behavior, 1 = infinite reserves, 2 = bottomless magazines", 0, 2)

DamageMult = CreateConVar("simple_weapons_damage_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The damage modifier to use for weapons.", 0)
SpreadMult = CreateConVar("simple_weapons_spread_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The accuracy modifier to use for weapons. Less = more accurate", 0)
RecoilMult = CreateConVar("simple_weapons_recoil_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The recoil modifier to use for weapons.", 0)

if CLIENT then
	VMOffsetX = CreateClientConVar("simple_weapons_vm_offset_x", 0, true, false, "Use a slightly higher viewmodel position.")
	VMOffsetY = CreateClientConVar("simple_weapons_vm_offset_y", 0, true, false, "Use a slightly higher viewmodel position.")
	VMOffsetZ = CreateClientConVar("simple_weapons_vm_offset_z", 0, true, false, "Use a slightly higher viewmodel position.")
end
