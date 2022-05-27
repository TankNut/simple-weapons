AddCSLuaFile()

simple_weapons.Include("Convars")

function SWEP:IsReloading()
	return self:GetFinishReload() != 0
end

function SWEP:CanReload()
	if self:IsReloading() or self:Clip1() >= self.Primary.ClipSize then
		return false
	end

	if InfiniteAmmo:GetInt() == 0 and self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then
		return false
	end

	return true
end

function SWEP:Reload()
	if not self:CanReload() then
		return
	end

	self:StartReload()
end

function SWEP:StartReload()
	local reload = self.Primary.Reload

	self:GetOwner():SetAnimation(PLAYER_RELOAD)

	if reload.Shotgun then
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

		self:SetFirstReload(true)
	else
		self:SendWeaponAnim(ACT_VM_RELOAD)

		if reload.Sound != "" then
			self:EmitSound(reload.Sound)
		end
	end

	local duration = self:SequenceDuration()

	self:SetFinishReload(CurTime() + duration)
	self:SetNextIdle(CurTime() + duration)
end

function SWEP:FinishReload()
	local primary = self.Primary
	local reload = primary.Reload
	local ply = self:GetOwner()

	local amount = math.min(primary.ClipSize - self:Clip1(), reload.Amount)
	local first = self:GetFirstReload()

	if InfiniteAmmo:GetInt() == 0 and not first then
		amount = math.min(amount, ply:GetAmmoCount(primary.Ammo))

		ply:RemoveAmmo(amount, primary.Ammo)
	end

	if reload.Shotgun then
		if not self:GetFirstReload() then
			self:SetClip1(self:Clip1() + amount)
		end

		if self:Clip1() >= primary.ClipSize or amount <= 0 or self:GetAbortReload() then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

			local duration = self:SequenceDuration()

			self:SetNextPrimaryFire(CurTime() + duration)
			self:SetNextIdle(CurTime() + duration)

			self:SetAbortReload(false)
			self:SetFinishReload(0)
		else
			self:SendWeaponAnim(ACT_VM_RELOAD)

			if self:GetFirstReload() then
				self:SetFirstReload(false)
			end

			if reload.Sound != "" then
				self:EmitSound(reload.Sound)
			end

			local duration = self:SequenceDuration()

			self:SetNextIdle(CurTime() + duration)
			self:SetFinishReload(CurTime() + duration)
		end
	else
		self:SetClip1(self:Clip1() + amount)
		self:SetFinishReload(0)
	end
end
