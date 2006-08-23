
coolDownOptions = { }

coolDownOptions.frameScale = 1
coolDownOptions.buttonDock = "Bottom"
coolDownOptions.iconDock = "Right"
coolDownOptions.minSpellDuration = 2.0
coolDownOptions.maxSpellDuration = 7200
coolDownOptions.minItemDuration = 3.0
coolDownOptions.backdropColor = { r = 0, g = 0, b = 0, a = 1 }
coolDownOptions.barColor = { r = 0.4, g = 0.4, b = 0.95, a = 1 }
coolDownOptions.textColor = { r = 1, g = 0.82, b = 0, a = 1 }


local function default(option, value)
	coolDownOptions[option] = coolDownOptions[option] or value
end

local frameDockTable = {
	["Top"] = { "BOTTOM", nil, "TOP", 0, -2 },
    ["Bottom"] = { "TOP", nil, "BOTTOM", 0, 2 },
    ["Left"] = { "RIGHT", nil, "LEFT", 1, 0 },
    ["Right"] = { "LEFT", nil, "RIGHT", -1, 0 },
}


function coolDownOptionsValidate()
	default("frameScale", 1)
	
	default("buttonDock", "Bottom")
	local buttonDirectionInfo = frameDockTable[coolDownOptions.buttonDock]
	if (buttonDirectionInfo == nil) then
		coolDownOptions.buttonDock = "Bottom"
	end

	default("iconDock", "Right")
	local iconDockInfo = frameDockTable[coolDownOptions.iconDock]
	if (iconDockInfo == nil) then
		coolDownOptions.iconDock = "Right"
	end

	default("minSpellDuration", 2.2)
	default("maxSpellDuration", 7200)
	default("minItemDuration", 3.0)
	default("backdropColor", { r = 0, g = 0, b = 0, a = 1 })
	default("barColor", { r = 0.4, g = 0.4, b = 0.95, a = 1 })
	default("textColor", { r = 1, g = 0.82, b = 0, a = 1 })
end
