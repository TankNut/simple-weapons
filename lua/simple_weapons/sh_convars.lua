AddCSLuaFile()

module("simple_weapons.Convars", package.seeall)

ClassicMode = CreateConVar("simple_weapons_classic_mode", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Disables the raise/lower system.", 0, 1)

ReplaceWeapons = CreateConVar("simple_weapons_replace_weapons", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether the default HL2 weapons should be replaced.", 0, 1)

ReadyTime = CreateConVar("simple_weapons_ready_time", 0.4, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The amount of time it takes to raise/lower weapons.", 0)

InfiniteAmmo = CreateConVar("simple_weapons_infinite_ammo", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Ammo mode to use for weapons. 0 = standard behavior, 1 = infinite reserves, 2 = bottomless magazines", 0, 2)

LimitMovement = CreateConVar("simple_weapons_limit_movement", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enables raised weapons limiting player movement.", 0, 1)
WalkSpeed = CreateConVar("simple_weapons_walk_speed", 200, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The movement speed to limit players to when raised.")

LoweredReloads = CreateConVar("simple_weapons_lowered_reloads", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether weapons can be reloaded when lowered.", 0, 1)

MinDamage = CreateConVar("simple_weapons_min_damage", 0.2, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The minimum percentage of damage a weapon deals regardless of range.", 0, 1)
Falloff = CreateConVar("simple_weapons_falloff_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How aggressively damage falloff applies.", 0)

DamageMult = CreateConVar("simple_weapons_damage_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The damage modifier to use for weapons.", 0)
NPCDamageMult = CreateConVar("simple_weapons_npc_damage_mult", 0.5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The damage modifier to use for weapons when held by NPC's.", 0)
RangeMult = CreateConVar("simple_weapons_range_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The range modifier to use for weapons.", 0)
RecoilMult = CreateConVar("simple_weapons_recoil_mult", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The recoil modifier to use for weapons.", 0)

if CLIENT then
	NoAutoRaise = CreateClientConVar("simple_weapons_disable_raise", 0, true, true, "Disables left click raising your weapon.", 0, 1)

	AutoReload = CreateClientConVar("simple_weapons_auto_reload", 1, true, true, "Whether weapons should automatically reload when you fire them.")

	AimZoom = CreateClientConVar("simple_weapons_zoom", 1.25, true, true, "The amount of zoom to apply when raising a weapon.", 1, 1.5)
	UseScopes = CreateClientConVar("simple_weapons_scopes", 1, true, false, "Whether to use scopes when zooming.")

	SwayScale = CreateClientConVar("simple_weapons_swayscale", 1, true, false, "The amount of viewmodel sway to apply to weapons")
	BobScale = CreateClientConVar("simple_weapons_bobscale", 1, true, false, "The amount of viewmodel bob to apply to weapons")

	VMOffsetX = CreateClientConVar("simple_weapons_vm_offset_x", 0, true, false, "The forward/back offset to use for viewmodels.")
	VMOffsetY = CreateClientConVar("simple_weapons_vm_offset_y", 0, true, false, "The left/right offset to use for viewmodels.")
	VMOffsetZ = CreateClientConVar("simple_weapons_vm_offset_z", 0, true, false, "The up/down offset to use for viewmodelss.")
end
