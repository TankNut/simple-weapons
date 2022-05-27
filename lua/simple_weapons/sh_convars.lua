AddCSLuaFile()

module("simple_weapons.Convars", package.seeall)

InfiniteAmmo = CreateConVar("simple_weapons_infinite_ammo", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether or not weapons should have infinite ammo. 0 = no, 1 = yes, 2 = bottomless magazines", 0, 2)
AmmoMethod = CreateConVar("simple_weapons_ammo_method", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The method used to access custom ammo types. 0 = disabled, 1 = entities, 2 = always", 0, 2)
