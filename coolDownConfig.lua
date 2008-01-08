
--[[
	The default config should fit most users. It contains one dock for
	spells and one for inventory items.
]]
coolDownConfig = {
	[{ "Spells", 1, "Bottom", "Right" }] =
		[[ return function(type, start, duration, textures)
			if (type == "S" and duration > 4) then
				return  { 0, 0, 0, 1 }, { 1, 0, 0, 1 }, { 0, 1, 0, 1 }, { 0, 0, 1, 1 }
			end
		end ]],
	[{ "Items", 1, "Bottom", "Right" }] =
		[[ return function(type, start, duration, textures)
			if (type == "I" and duration > 4) then
				return  { 0, 0, 0, 1 }, { 1, 1, 0, 1 }, { 0, 1, 1, 1 }, { 1, 0, 1, 1 }
			end
		end ]],
}

