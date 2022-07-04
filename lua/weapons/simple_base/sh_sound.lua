AddCSLuaFile()

function SWEP:EmitEmptySound()
	self:EmitSound(")weapons/pistol/pistol_empty.wav", 75, 100, 0.7, CHAN_STATIC)
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
end

function SWEP:EmitReloadSound()
	local reload = self.Primary.Reload

	if reload.Sound != "" then
		self:EmitSound(reload.Sound)
	end
end
