AddCSLuaFile()

DEFINE_BASECLASS("weapon_base")

local index = {
	["pistol"]		= ACT_HL2MP_IDLE_PISTOL,
	["smg"]			= ACT_HL2MP_IDLE_SMG1,
	["grenade"]		= ACT_HL2MP_IDLE_GRENADE,
	["ar2"]			= ACT_HL2MP_IDLE_AR2,
	["shotgun"]		= ACT_HL2MP_IDLE_SHOTGUN,
	["rpg"]			= ACT_HL2MP_IDLE_RPG,
	["physgun"]		= ACT_HL2MP_IDLE_PHYSGUN,
	["crossbow"]	= ACT_HL2MP_IDLE_CROSSBOW,
	["melee"]		= ACT_HL2MP_IDLE_MELEE,
	["slam"]		= ACT_HL2MP_IDLE_SLAM,
	["normal"]		= ACT_HL2MP_IDLE,
	["fist"]		= ACT_HL2MP_IDLE_FIST,
	["melee2"]		= ACT_HL2MP_IDLE_MELEE2,
	["passive"]		= ACT_HL2MP_IDLE_PASSIVE,
	["knife"]		= ACT_HL2MP_IDLE_KNIFE,
	["duel"]		= ACT_HL2MP_IDLE_DUEL,
	["camera"]		= ACT_HL2MP_IDLE_CAMERA,
	["magic"]		= ACT_HL2MP_IDLE_MAGIC,
	["revolver"]	= ACT_HL2MP_IDLE_REVOLVER
}

local replacements = {
	-- Pistol
	[ACT_HL2MP_IDLE_PISTOL] = ACT_HL2MP_IDLE_REVOLVER,
	[ACT_HL2MP_WALK_PISTOL] = ACT_HL2MP_WALK_REVOLVER,
	[ACT_HL2MP_RUN_PISTOL] = ACT_HL2MP_RUN_REVOLVER,
	-- Shotgun
	[ACT_HL2MP_IDLE_SHOTGUN] = ACT_HL2MP_IDLE_AR2,
	[ACT_HL2MP_IDLE_CROUCH_SHOTGUN] = ACT_HL2MP_IDLE_CROUCH_AR2,
	[ACT_HL2MP_WALK_SHOTGUN] = ACT_HL2MP_WALK_AR2,
	[ACT_HL2MP_WALK_CROUCH_SHOTGUN] = ACT_HL2MP_WALK_CROUCH_AR2,
	[ACT_HL2MP_RUN_SHOTGUN] = ACT_HL2MP_RUN_AR2,
	-- Passive
	[ACT_HL2MP_WALK_CROUCH_PASSIVE] = ACT_HL2MP_WALK_CROUCH,
	[ACT_HL2MP_IDLE_CROUCH_PASSIVE] = ACT_HL2MP_IDLE_CROUCH
}

function SWEP:TranslateWeaponAnim(act)
	return act
end

function SWEP:SendTranslatedWeaponAnim(act)
	act = self:TranslateWeaponAnim(act)

	if not act then
		return
	end

	self:SendWeaponAnim(act)
end

function SWEP:TranslateActivity(act)
	local translated

	if self:GetLowered() and (act == ACT_MP_RELOAD_STAND or act == ACT_MP_RELOAD_CROUCH) and index[self.HoldType] then
		translated = index[self.HoldType] + 6
	end

	local custom = self:GetLowered() and self.CustomLowerHoldType or self.CustomHoldType

	if custom[act] then
		return custom[act]
	end

	if not translated then
		translated = BaseClass.TranslateActivity(self, act)
	end

	return replacements[translated] and replacements[translated] or translated
end
