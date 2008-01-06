
local FactoryInterface = { }
IFrameFactory("1.0"):Register("coolDown", "Button", FactoryInterface)

local function format(self, time)
	local min, sec = math.floor(time / 60), math.floor(math.fmod(time, 60))

	if (self.min == min and self.sec == sec) then
		return
	end

	self.min, self.sec = min, sec

	return string.format("%02d:%02s", min, sec)
end

local function onUpdate(self)
	if (not self:IsVisible()) then
		return
	end

	local time = self.tbl[3] - ( GetTime() - self.tbl[2] )
	if (time > 0) then
		local label = format(self, time)
		if (label) then
			self.label:SetText(label)
		end
		self.bar:SetValue(time)
	else
		coolDown:Clear(self.tbl)
		coolDown:Update()
	end
end

function FactoryInterface:Create()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetWidth(80)
	frame:SetHeight(32)

	local backdropTable = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 12, edgeSize = 12,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
	}

	local backdropColor = coolDown.Options.backdropColor
	local barColor = coolDown.Options.barColor
	local textColor = coolDown.Options.textColor

	frame:SetBackdrop(backdropTable)
	frame:SetBackdropBorderColor(backdropColor.r, backdropColor.g, backdropColor.b, backdropColor.a)
	frame:SetBackdropColor(backdropColor.r, backdropColor.g, backdropColor.b, backdropColor.a)

	frame.bar = CreateFrame("StatusBar", nil, frame)
	frame.bar:SetPoint("Center", frame)
	frame.bar:SetWidth(70)
	frame.bar:SetHeight(22)
	frame.bar:SetStatusBarTexture("Interface\\AddOns\\coolDown\\Textures\\Smooth")
	frame.bar:SetStatusBarColor(barColor.r, barColor.g, barColor.b, barColor.a)

	frame.label = frame.bar:CreateFontString(nil, "OVERLAY")
	frame.label:SetFontObject(coolDownFont)
	frame.label:SetPoint("CENTER", frame, "CENTER", 0, 0)
	frame.label:SetJustifyH("CENTER")
	frame.label:SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
	frame:SetScript("OnUpdate", onUpdate)

	return frame
end

function FactoryInterface:Destroy(frame)
	return frame
end
