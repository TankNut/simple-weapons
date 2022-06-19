AddCSLuaFile()

module("simple_weapons.Convars", package.seeall)

ReadyTime = CreateConVar("simple_weapons_ready_time", 0.4, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The amount of time it takes to raise/lower weapons.", 0)

InfiniteAmmo = CreateConVar("simple_weapons_infinite_ammo", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Ammo mode to use for weapons. 0 = standard behavior, 1 = infinite reserves, 2 = bottomless magazines", 0, 2)

DamageMult = CreateConVar("simple_weapons_damage_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The damage modifier to use for weapons.", 0)
SpreadMult = CreateConVar("simple_weapons_spread_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The accuracy modifier to use for weapons. Less = more accurate", 0)
RecoilMult = CreateConVar("simple_weapons_recoil_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The recoil modifier to use for weapons.", 0)

if CLIENT then
	AimZoom = CreateClientConVar("simple_weapons_zoom", 1.25, true, true, "The amount of zoom to apply when raising a weapon.", 1, 1.5)

	AutoReload = CreateClientConVar("simple_weapons_auto_reload", 1, true, true, "Whether weapons should automatically reload when you fire them.")

	VMOffsetX = CreateClientConVar("simple_weapons_vm_offset_x", 0, true, false, "The forward/back offset to use for viewmodels.")
	VMOffsetY = CreateClientConVar("simple_weapons_vm_offset_y", 0, true, false, "The left/right offset to use for viewmodels.")
	VMOffsetZ = CreateClientConVar("simple_weapons_vm_offset_z", 0, true, false, "The up/down offset to use for viewmodelss.")
end
