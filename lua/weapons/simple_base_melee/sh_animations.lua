AddCSLuaFile()

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
