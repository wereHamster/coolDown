
local IFrameFactory = IFrameFactory("1.0")

local frameDockTable = {
	["Top"] = { "BOTTOM", nil, "TOP", 0, -2 },
    ["Bottom"] = { "TOP", nil, "BOTTOM", 0, 2 },
    ["Left"] = { "RIGHT", nil, "LEFT", 1, 0 },
    ["Right"] = { "LEFT", nil, "RIGHT", -1, 0 },
}

CreateFrame("Frame", "coolDown", UIParent)
coolDown:SetWidth(80)
coolDown:SetHeight(32)
coolDown:SetPoint("CENTER", UIParent, "CENTER")
coolDown:SetMovable(true)

IFrameManager:Register(coolDown, IFrameManager:Interface())

function coolDown:Update()
	IFrameFactory:Clear("coolDown", "Button")
	IFrameFactory:Clear("coolDown", "Icon")
	
    local buttonDockInfo = frameDockTable[coolDown.Options.buttonDock]
    local iconDockInfo = frameDockTable[coolDown.Options.iconDock]
	local frameParent = coolDown
	for _, tbl in ipairs(coolDown.State) do
		local buttonFrame = IFrameFactory:Create("coolDown", "Button")
		buttonFrame:SetScale(coolDown.Options.frameScale)
		
		buttonFrame.tbl = tbl
		buttonFrame.bar:SetMinMaxValues(0, tbl[3])
		buttonFrame:ClearAllPoints()
		buttonDockInfo[2] = frameParent
		if (frameParent == coolDown) then
			buttonFrame:SetPoint("CENTER", coolDown, "CENTER")
		else
			buttonFrame:SetPoint(unpack(buttonDockInfo))
		end

		local iconParent = buttonFrame

		for iconIndex, spellInfo in pairs(tbl[4]) do
			local iconFrame = IFrameFactory:Create("coolDown", "Icon")
			
			iconFrame:ClearAllPoints()
			iconDockInfo[2] = iconParent
			iconFrame:SetPoint(unpack(iconDockInfo))
			iconFrame.texture:SetTexture(iconIndex)
			iconFrame:SetParent(buttonFrame)

			iconParent = iconFrame
		end

		frameParent = buttonFrame
	end
end
