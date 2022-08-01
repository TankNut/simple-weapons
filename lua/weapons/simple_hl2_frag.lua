AddCSLuaFile()

if CLIENT then
	language.Add("simple_hl2_frag_ammo", "Frag Grenades")
end

game.AddAmmoType({name = "simple_hl2_frag", maxcarry = 5})

SWEP.Base = "simple_base_throwing"

SWEP.PrintName = "Frag Grenade"
SWEP.Category = "Simple Weapons: Half-Life 2"

SWEP.Slot = 4

SWEP.Spawnable = true

SWEP.UseHands = true

SWEP.ViewModelFOV = 54

SWEP.ViewModel = Model("models/weapons/c_grenade.mdl")
SWEP.WorldModel = Model("models/weapons/w_grenade.mdl")

SWEP.HoldType = "melee"

SWEP.Primary = {
	Ammo = "simple_hl2_frag",

	ThrowAct = {ACT_VM_PULLBACK_HIGH, ACT_VM_THROW},
	LobAct = {ACT_VM_PULLBACK_LOW, ACT_VM_HAULBACK},
	RollAct = {ACT_VM_PULLBACK_LOW, ACT_VM_SECONDARYATTACK}
}

if SERVER then
	function SWEP:CreateEntity()
		local ent = ents.Create("simple_ent_hl2_frag")
		local ply = self:GetOwner()

		ent:SetPos(ply:GetPos())
		ent:SetAngles(ply:EyeAngles())
		ent:SetOwner(ply)
		ent:Spawn()
		ent:Activate()

		ent:SetTimer(3)

		return ent
	end
end
