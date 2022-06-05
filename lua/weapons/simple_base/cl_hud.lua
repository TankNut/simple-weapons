function SWEP:DoDrawCrosshair(x, y)
	return self:GetLowered() or self:IsReloading()
end
