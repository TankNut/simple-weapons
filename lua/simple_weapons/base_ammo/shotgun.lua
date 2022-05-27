AddCSLuaFile()

simple_weapons.Include("Ammo")

RegisterAmmo("base_slugs", "Slugs", function(weapon, tab)
	tab.Primary.Count = 1
	tab.Primary.Spread = weapon.Primary.Spread / 3
	tab.Primary.Damage = weapon.Primary.Damage * weapon.Primary.Count
end)
