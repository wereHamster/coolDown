
coolDown.State = { }
local Callbacks = { }

local function insert(type, start, duration, texture)
	for _, tbl in ipairs(coolDown.State) do
		if (tbl[1] == type and tbl[2] == start and tbl[3] == duration) then
			tbl[4][texture] = true
			return
		end
	end
	for _,tbl in pairs(coolDown.State) do
		if (tbl[4][texture]) then
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
	local min = coolDown.Options.minSpellDuration
	local max = coolDown.Options.maxSpellDuration
	
	for _, type in ipairs(bookTypes) do
		local spellID = 1
		local spell = GetSpellName(spellID, type)
		
		while (spell) do
			local start, duration, hasCooldown = GetSpellCooldown(spellID, type)
			if (hasCooldown == 1 and start > 0 and duration > min and duration < max) then
				insert("S", start, duration, GetSpellTexture(spellID, type))
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
		if (hasCooldown == 1 and start > 0 and duration > coolDown.Options.minItemDuration) then
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
					if (type == "Consumable" and duration > coolDown.Options.minItemDuration) then
						insert("C", start, duration, coolDown.Shares.C[itemID] or (GetContainerItemInfo(bagIndex, invIndex)))
					end
				end
			end
		end
	end
end

local eventMap = {
	["PLAYER_ENTERING_WORLD"] = { S, I, C },
	["UPDATE_SHAPESHIFT_FORMS"] = { S },
	["SPELLS_CHANGED"] = { S },
	["SPELL_UPDATE_COOLDOWN"] = { S, I },
	["CURRENT_SPELL_CAST_CHANGED"] = { S },
	["BAG_UPDATE_COOLDOWN"] = { C },
	["UNIT_INVENTORY_CHANGED"] = { I },
}

local function onEvent(self, event)
	self:Show()

	for _, cb in pairs(eventMap[event]) do
		table.insert(Callbacks, cb)
	end

	if (event == "UNIT_INVENTORY_CHANGED") then
		for idx, tbl in ipairs(coolDown.State) do
			if (tbl[1] == "I") then
				table.remove(coolDown.State, idx)
			end
		end
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


for event in pairs(eventMap) do
	coolDown:RegisterEvent(event)
end

coolDown:SetScript("OnEvent", onEvent)
coolDown:SetScript("OnUpdate", onUpdate)

function coolDown:Clear(...)
	remove(unpack(select(1, ...)))
end
