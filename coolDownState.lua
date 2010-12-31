
local function insert(type, start, duration, texture)
  for _, tbl in ipairs(coolDown.State) do
    if (tbl[1] == type and (tbl[2] == start and tbl[3] == duration or tbl[4][texture])) then
      tbl[2] = start
      tbl[3] = duration
      tbl[4][texture] = true

      return
    end
  end
  table.insert(coolDown.State, { type, start, duration, { [texture] = true } })
end

local function remove(type, start, duration)
  for idx, tbl in ipairs(coolDown.State) do
    if (tbl[1] == type and tbl[2] == start and tbl[3] == duration) then
      table.remove(coolDown.State, idx)
    end
  end
end

local function sort(left, right)
  local now = GetTime()
  return (left[3] - (now - left[2])) < (right[3] - (now - right[2]))
end


local bookTypes = { BOOKTYPE_SPELL, BOOKTYPE_PET }
local function S()
  for _, type in ipairs(bookTypes) do
    local spellID = 1
    local spell = GetSpellBookItemName(spellID, type)

    while (spell) do
      local start, duration, hasCooldown = GetSpellCooldown(spellID, type)
      if (hasCooldown == 1 and start > 0 and duration > 2) then
        insert("S", start, duration, GetSpellTexture(spellID, type))
      end
      
      spellID = spellID + 1
      spell = GetSpellBookItemName(spellID, type)
    end
  end
end

local function I()
  for i=0, 1 do
    local slotID = GetInventorySlotInfo("Trinket"..i.."Slot")
    local start, duration, hasCooldown = GetInventoryItemCooldown("player", slotID)
    if (hasCooldown == 1 and start > 0 and duration > 2) then
      insert("I", start, duration, GetInventoryItemTexture("player", slotID))
    end
  end
end

local function C()
  for bagIndex=0, 4 do
    for invIndex=1, GetContainerNumSlots(bagIndex) do
      local itemLink = GetContainerItemLink(bagIndex, invIndex)
      if (itemLink) then
        local start, duration, hasCooldown = GetContainerItemCooldown(bagIndex, invIndex)   
            if (start > 0) then
          local itemID, _, _, _, _, type = GetItemInfo(itemLink)  
          if (type == "Consumable" and duration > 2) then
            insert("C", start, duration, coolDown.Shares.C[itemID] or (GetContainerItemInfo(bagIndex, invIndex)))
          end
        end
      end
    end
  end
end

local Callbacks = { }
local eventMap = {
  ["PLAYER_ENTERING_WORLD"] = { S, I, C },
  ["UPDATE_SHAPESHIFT_FORMS"] = { S },
  ["SPELLS_CHANGED"] = { S },
  ["SPELL_UPDATE_COOLDOWN"] = { S, I },
  ["CURRENT_SPELL_CAST_CHANGED"] = { S },
  ["BAG_UPDATE_COOLDOWN"] = { C },
  ["UNIT_INVENTORY_CHANGED"] = { I },
}

local function onEvent(self, event, ...)
  self:Show()

  for _, cb in ipairs(eventMap[event]) do
    Callbacks[cb] = cb
  end
end

coolDown.State = { }
local function onUpdate(self)
  self:Hide()

  for func in pairs(Callbacks) do
    Callbacks[func] = nil
    func()
  end
  
  table.sort(self.State, sort)
  coolDown:Update()
end

coolDown:RegisterEvent("ADDON_LOADED")
coolDown:SetScript("OnUpdate", onUpdate)
coolDown:SetScript("OnEvent", function(self, event, ...)
	for name, conf in pairs(coolDownConfig) do
		local dock = CreateFrame("Frame", "cD:"..name, UIParent)
		IFrameManager:Register(dock, IFrameManager:Interface())

		dock:SetWidth(80)
		dock:SetHeight(32)
		dock:SetPoint("CENTER", UIParent, "CENTER")
		dock:SetScale(conf[1][1])

		coolDown.Docks[{ dock, conf[1][2], conf[1][3] }] = loadstring(conf[2])()
	end

  coolDown:UnregisterAllEvents()
  for event in pairs(eventMap) do
    coolDown:RegisterEvent(event)
  end
  coolDown:SetScript("OnEvent", onEvent)
end)

function coolDown:Clear(...)
  remove(unpack(select(1, ...)))
end
