AddCSLuaFile()

-- Boilerplate lines, required for anything to work at all. simple_base can be swapped out for different base weapons depending on your needs (e.g. scoped weapons using simple_base_scoped)

DEFINE_BASECLASS("simple_base")

SWEP.Base = "simple_base"

-- UI stuff

SWEP.PrintName = "Weapon template" -- The weapon's name used in the spawn menu and HUD
SWEP.Category = "Simple Weapons: Custom" -- The category the weapon will appear in, recommended you use your own if making a pack

SWEP.Slot = 1 -- The slot the weapon will appear in when switching weapons, add 1 to get the actual slot (e.g. a value of 1 translates to weapon slot 2, the pistol slots)

SWEP.Spawnable = false -- Set this to true to make your weapon appear in the spawnmenu, set to false to hide the template

-- Appearance

SWEP.UseHands = true -- If your viewmodel includes it's own hands (v_ model instead of a c_ model), set this to false

SWEP.ViewModelTargetFOV = 54 -- The default viewmodel FOV, SWEP.ViewModelFOV gets overwritten by the base itself

SWEP.ViewModel = Model("models/weapons/c_pistol.mdl") -- Weapon viewmodel, usually a c_ or v_ model
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl") -- Weapon worldmodel, almost always a w_ model

SWEP.HoldType = "pistol" -- Default holdtype, you can find all the options here: https://wiki.facepunch.com/gmod/Hold_Types
SWEP.LowerHoldType = "normal" -- Ditto, used when a weapon is lowered

-- Weapon stats

SWEP.Firemode = 0 -- The default firemode, -1 = full-auto, 0 = semi-auto, >1 = burst fire

SWEP.Primary = {
	Ammo = "Pistol", -- The ammo type used when reloading

	ClipSize = 18, -- The amount of ammo per magazine, -1/infinite is not supported at the moment
	DefaultClip = 18, -- How many rounds the player gets when picking up the weapon for the first time, excess ammo will be added to the player's reserves

	Damage = 13, -- Damage per shot
	Count = 1, -- Optional: Shots fired per shot

	PumpAction = false, -- Optional: Tries to pump the weapon between shots
	PumpSound = "Weapon_Shotgun.Special1", -- Optional: Sound to play when pumping

	Delay = 60 / 600, -- Delay between shots, use 60 / x for RPM (Rounds per minute) values
	BurstDelay = 60 / 1200, -- Burst only: the delay between shots during a burst
	BurstEndDelay = 0.4, -- Burst only: the delay added after a burst

	Range = 750, -- The effective range of a weapon in units, use developer 1 in singleplayer for tools
	Accuracy = 12, -- The accuracy of a weapon at Range, lower is less accurate (12 = headshots, 24 = bodyshots)

	Recoil = {
		MinAng = Angle(1, -0.3, 0), -- The minimum amount of recoil punch per shot
		MaxAng = Angle(1.2, 0.3, 0), -- The maximum amount of recoil punch per shot
		Punch = 0.2, -- The percentage of recoil added to the player's view angles, if set to 0 a player's view will always reset to the exact point they were aiming at
		Ratio = 0.4 -- The percentage of recoil that's translated into the viewmodel, higher values cause bullets to end up above the crosshair
	},

	Reload = {
		Amount = math.huge, -- Optional: Amount of ammo to reload per reload
		Shotgun = false, -- Optional: Interruptable shotgun reloads
		Sound = "Weapon_Pistol.Reload" -- Optional: Sound to play when starting a reload
	},

	Sound = "Weapon_Pistol.Single", -- Firing sound
	TracerName = "Tracer" -- Tracer effect, leave blank for no tracer
}

SWEP.ScopeZoom = {2, 6} -- Scope base only: A number (or table) containing the zoom levels the weapon can cycle through
SWEP.ScopeSound = "Default.Zoom" -- Scope base only, optional: Sound to play when cycling through zoom levels