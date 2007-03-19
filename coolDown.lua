
local IFrameFactory = IFrameFactory("1.0")

local frameDockTable = {
	["Top"] = { "BOTTOM", nil, "TOP", 0, -2 },
    ["Bottom"] = { "TOP", nil, "BOTTOM", 0, 2 },
    ["Left"] = { "RIGHT", nil, "LEFT", 1, 0 },
    ["Right"] = { "LEFT", nil, "RIGHT", -1, 0 },
}

IFrameManager:Register(CreateFrame("Frame", "coolDown", UIParent), IFrameManager:Interface())
coolDown:SetWidth(80)
coolDown:SetHeight(32)
coolDown:SetPoint("CENTER", UIParent, "CENTER")
coolDown:SetMovable(true)

function coolDown:Update()
	IFrameFactory:Clear("coolDown", "Button")
	IFrameFactory:Clear("coolDown", "Icon")

	local buttonDockInfo = frameDockTable[coolDown.Options.buttonDock]
	local iconDockInfo = frameDockTable[coolDown.Options.iconDock]

	local buttonParent = coolDown
	for _, tbl in ipairs(coolDown.State) do
		local buttonFrame = IFrameFactory:Create("coolDown", "Button")
		buttonFrame:SetScale(coolDown.Options.frameScale)

		buttonFrame.tbl = tbl
		buttonFrame.bar:SetMinMaxValues(0, tbl[3])

		if (buttonParent == coolDown) then
			buttonFrame:SetPoint("CENTER", coolDown, "CENTER")
		else
			buttonDockInfo[2] = buttonParent
			buttonFrame:SetPoint(unpack(buttonDockInfo))
		end

		local iconParent = buttonFrame
		for iconIndex, spellInfo in pairs(tbl[4]) do
			local iconFrame = IFrameFactory:Create("coolDown", "Icon")
			iconDockInfo[2] = iconParent
			iconFrame:SetPoint(unpack(iconDockInfo))
			iconFrame.texture:SetTexture(iconIndex)

			iconParent = iconFrame
		end

		buttonFrame:GetScript("OnUpdate")(buttonFrame)
		buttonParent = buttonFrame
	end
end
