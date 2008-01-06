
local IFrameFactory = IFrameFactory("1.0")

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


CreateFrame("Frame", "coolDown", UIParent)
coolDown:SetWidth(80)
coolDown:SetHeight(32)
coolDown:SetPoint("CENTER", UIParent, "CENTER")

coolDown.Docks = { }

local f = CreateFrame("Frame")
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function()
	for conf, func in pairs(coolDownConfig) do
		local dock = CreateFrame("Frame", "cD:"..conf[1], UIParent)
		IFrameManager:Register(dock, IFrameManager:Interface())

		dock:SetWidth(80)
		dock:SetHeight(32)
		dock:SetPoint("CENTER", UIParent, "CENTER")
		dock:SetScale(conf[2])

		coolDown.Docks[{ dock, conf[3], conf[4] }] = loadstring(func)()
	end
end)

local frameDockTable = {
	["Top"] = { "BOTTOM", nil, "TOP", 0, -2 },
	["Bottom"] = { "TOP", nil, "BOTTOM", 0, 2 },
	["Left"] = { "RIGHT", nil, "LEFT", 1, 0 },
	["Right"] = { "LEFT", nil, "RIGHT", -1, 0 },
}

function coolDown:Update()
	IFrameFactory:Clear("coolDown", "Button")
	IFrameFactory:Clear("coolDown", "Icon")

	for dock, func in pairs(coolDown.Docks) do
		local buttonDockInfo = frameDockTable[dock[2]]
		local iconDockInfo = frameDockTable[dock[3]]

		local btnParent = dock[1]
		for _, tbl in ipairs(coolDown.State) do
			if (func(unpack(tbl))) then
				local btn = IFrameFactory:Create("coolDown", "Button")
				btn:SetParent(btnParent)

				btn.tbl = tbl
				btn.bar:SetMinMaxValues(0, tbl[3])

				if (btnParent == dock[1]) then
					btn:SetPoint("CENTER", dock[1], "CENTER")
				else
					buttonDockInfo[2] = btnParent
					btn:SetPoint(unpack(buttonDockInfo))
				end

				local icnParent = btn
				for tex in pairs(tbl[4]) do
					local icn = IFrameFactory:Create("coolDown", "Icon")
					icn:SetParent(icnParent)

					iconDockInfo[2] = icnParent
					icn:SetPoint(unpack(iconDockInfo))

					icn.texture:SetTexture(tex)

					icnParent = icn
				end

				btn:GetScript("OnUpdate")(btn)
				btnParent = btn
			end
		end
	end
end

