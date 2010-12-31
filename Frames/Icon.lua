
local FactoryInterface = { }
IFrameFactory("1.0"):Register("coolDown", "Icon", FactoryInterface)

function FactoryInterface:Create()
  local frame = CreateFrame("Frame", nil, UIParent)
  frame:SetWidth(31)
  frame:SetHeight(31)

  frame.texture = frame:CreateTexture(nil, "ARTWORK")
  frame.texture:SetWidth(29)
  frame.texture:SetHeight(29)
  frame.texture:SetPoint("CENTER", frame, "CENTER", 0, 0)

  frame.border = frame:CreateTexture(nil, "OVERLAY")
  frame.border:SetWidth(31)
  frame.border:SetHeight(31)
  frame.border:SetTexture("Interface\\Buttons\\UI-Debuff-Border")
  frame.border:SetPoint("CENTER", frame, "CENTER", 0, 0)
  frame.border:SetVertexColor(0, 0, 0, 1)

  return frame
end

function FactoryInterface:Destroy(frame)
  return frame
end
