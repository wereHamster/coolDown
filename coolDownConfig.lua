
--[[
	The default config should fit most users. It contains one dock for
	spells and one for inventory items.
]]
coolDownConfig = {
	[{ "Spells", 1, "Bottom", "Right" }] =
		[[ return function(type, start, duration, textures)
			return type == "S" and duration > 4
		end ]],
	[{ "Items", 1, "Bottom", "Right" }] =
		[[ return function(type, start, duration, textures)
			return type == "I" and duration > 4
		end ]],
}

