
local IFrameFactory = IFrameFactory("1.0")

coolDown = CreateFrame("Frame")
coolDown.Docks = { }


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
				btn:SetParent(dock[1])

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
					icn:SetParent(dock[1])

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

