
coolDown.State = { }
local Callbacks = { }

local function insert(type, start, duration, texture)
	for _, tbl in ipairs(coolDown.State) do
		if (tbl[1] == type and tbl[2] == start and tbl[3] == duration) then
			tbl[4][texture] = true
			return
		end
	end
	
	local tbl = { type, start, duration, { [texture] = true } }
	table.insert(coolDown.State, tbl)
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
	local min = coolDown.Options.minSpellDuration
	local max = coolDown.Options.maxSpellDuration
	
	for _, type in ipairs(bookTypes) do
		local spellID = 1
		local spell = GetSpellName(spellID, type)
		
		while (spell) do
			local start, duration, hasCooldown = GetSpellCooldown(spellID, type)
			if (hasCooldown == 1) then
				if (start > 0) then
					if (duration > min and duration < max) then
						insert("S", start, duration, GetSpellTexture(spellID, type))
					end
				end
			end
			
			spellID = spellID + 1
			spell = GetSpellName(spellID, type)
		end
	end
end

local function I()
	for i=0, 1 do
		local slotID = GetInventorySlotInfo("Trinket"..i.."Slot")
		local start, duration, hasCooldown = GetInventoryItemCooldown("player", slotID)
		if (hasCooldown == 1) then
			if (start > 0) then
				if (duration > coolDown.Options.minItemDuration) then
					insert("I", start, duration, GetInventoryItemTexture("player", slotID))
				end
			end
		end
	end
end

local function C()
	for bagIndex=0, 4 do
		for invIndex=1, GetContainerNumSlots(bagIndex) do
			local link = GetContainerItemLink(bagIndex, invIndex)
			if (link) then
				local start, duration, hasCooldown = GetContainerItemCooldown(bagIndex, invIndex)		
	    		if (start > 0) then
	    			local itemID = string.match(link, "item:(%d+):")
					local _, _, _, _, _, type = GetItemInfo(itemID)	
					if (type == "Consumable") then
						if (duration > coolDown.Options.minItemDuration) then
							local texture = coolDown.Shares.C[tonumber(itemID)] or (GetContainerItemInfo(bagIndex, invIndex))
							insert("C", start, duration, texture)
						end
					end
				end
			end
		end
	end
end


local function onEvent(self, event)
	self:Show()
	
	if (event == "PLAYER_ENTERING_WORLD") then
		coolDown.State = { }
		table.insert(Callbacks, S)
		table.insert(Callbacks, I)
		table.insert(Callbacks, C)
	elseif (event == "UPDATE_SHAPESHIFT_FORMS") then
		table.insert(Callbacks, S)
	elseif (event == "SPELLS_CHANGED") then
		table.insert(Callbacks, S)
	elseif (event == "SPELL_UPDATE_COOLDOWN") then
		table.insert(Callbacks, S)
		table.insert(Callbacks, I)
	elseif (event == "CURRENT_SPELL_CAST_CHANGED") then
		table.insert(Callbacks, S)
	elseif (event == "BAG_UPDATE_COOLDOWN") then
		table.insert(Callbacks, C)
	elseif (event == "UNIT_INVENTORY_CHANGED") then
		for idx, tbl in ipairs(coolDown.State) do
			if (tbl[1] == "I") then
				table.remove(coolDown.State, idx)
			end
		end
		table.insert(Callbacks, I)
	end
end

local function onUpdate(self)
	self:Hide()
	coolDownOptionsValidate()
	
	while next(Callbacks) do
		table.remove(Callbacks)()
	end
	
	table.sort(self.State, sort)
	coolDown:Update()
end


coolDown:RegisterEvent("PLAYER_ENTERING_WORLD")
coolDown:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
coolDown:RegisterEvent("SPELLS_CHANGED")
coolDown:RegisterEvent("SPELL_UPDATE_COOLDOWN")
coolDown:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
coolDown:RegisterEvent("BAG_UPDATE_COOLDOWN")
coolDown:RegisterEvent("UNIT_INVENTORY_CHANGED")

coolDown:SetScript("OnEvent", onEvent)
coolDown:SetScript("OnUpdate", onUpdate)

function coolDown:Clear(...)
	remove(unpack(select(1, ...)))
end
