AddCSLuaFile()

module("simple_weapons.Helpers", package.seeall)

function Range(range)
	local yards = (range / 0.75) / 36
	local MOA = (12 * 100) / yards

	return MOA / 60
end

function Spread(x, y)
	return Vector(Range(x), Range(y or x), 0)
end
