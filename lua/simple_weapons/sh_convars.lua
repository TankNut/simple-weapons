AddCSLuaFile()

module("simple_weapons.Convars", package.seeall)

InfiniteAmmo = CreateConVar("simple_weapons_infinite_ammo", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether or not weapons should have infinite ammo. 0 = no, 1 = yes, 2 = bottomless magazines", 0, 2)
