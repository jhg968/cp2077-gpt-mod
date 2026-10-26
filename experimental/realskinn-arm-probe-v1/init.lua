-- Read-only runtime inspection. No entity/resource setters or appearance edits.
local prefix = "[RealSkinnArmProbe v1] "
local function log(s) print(prefix .. s) end
local function get(fn)
    local ok, value = pcall(fn)
    if ok then return value end
    return nil
end
local function text(value)
    if value == nil then return "<unavailable>" end
    return get(function() return NameToString(value) end) or tostring(value)
end
local function refText(value)
    if value == nil then return "<unavailable>" end
    local path = get(function() return ResourceAsyncRef.GetPath(value) end)
    if path ~= nil then
        return get(function() return ResRef.ToString(path) end) or tostring(path)
    end
    return get(function() return ResRef.ToString(value) end) or tostring(value)
end
local function inspectEntity(entity, label)
    if entity == nil then log("ENTITY " .. label .. " absent"); return end
    local components = get(function() return entity:GetComponents() end)
    if components == nil then log("ERROR GetComponents unavailable for " .. label); return end
    local count, matched = 0, 0
    for _, c in ipairs(components) do
        count = count + 1
        local name = text(get(function() return c.name end))
        if name == "<unavailable>" then name = text(get(function() return c:GetName() end)) end
        local lower = name:lower()
        if lower:find("arm", 1, true) or lower:find("hand", 1, true) or lower:find("fist", 1, true) or lower:find("a0_", 1, true) then
            matched = matched + 1
            log("COMP entity=" .. label .. " name=" .. name
                .. " enabled=" .. tostring(get(function() return c.isEnabled end))
                .. " chunkMask=" .. tostring(get(function() return c.chunkMask end))
                .. " meshAppearance=" .. text(get(function() return c.meshAppearance end))
                .. " mesh=" .. refText(get(function() return c.mesh end))
                .. " originAppearance=" .. text(get(function() return c.appearanceName end))
                .. " originPath=" .. refText(get(function() return c.appearancePath end))
                .. " renderLayer=" .. tostring(get(function() return c.renderSceneLayerMask end)))
        end
    end
    log("ENTITY " .. label .. " components=" .. count .. " armMatches=" .. matched)
end
local heldTokens, resourceProxy = {}, nil
local function inspectCustomization(path)
    local token = Game.GetResourceDepot():LoadResource(path)
    if token == nil or token:IsFailed() then log("ERROR inspect resource failed: " .. path); return end
    local key = tostring(token:GetHash())
    heldTokens[key] = {token=token, path=path}
    token:RegisterCallback(resourceProxy:Target(), resourceProxy:Function("OnResourceReady"))
end
local function snapshot(label)
    local player = Game.GetPlayer()
    if player == nil then log("No player for " .. label); return end
    log("SNAPSHOT " .. label)
    inspectEntity(player, "player")
    for _, slot in ipairs({"AttachmentSlots.ArmsCyberware", "AttachmentSlots.WeaponRight", "AttachmentSlots.WeaponLeft"}) do
        local item = get(function() return Game.GetTransactionSystem():GetItemInSlot(player, TweakDBID.new(slot)) end)
        inspectEntity(item, slot)
    end
end
local elapsed, index = 0, 1
local times = {3, 10, 20}
registerForEvent("onInit", function()
    log("START read-only; captures at 3/10/20 seconds after player available")
    resourceProxy = NewProxy({OnResourceReady={args={"handle:ResourceToken"}, callback=function(token)
        local key = tostring(token:GetHash())
        local held = heldTokens[key]
        local path = held and held.path or key
        local ok, err = pcall(function()
            local r = token:GetResource()
            if r == nil then log("ERROR resource nil: " .. path); return end
            for _, option in ipairs(r.armsCustomizationOptions) do
                local name = text(option.name)
                if name:find("strong_arms", 1, true) then
                    log("OPTION path=" .. path .. " name=" .. name .. " resource=" .. refText(get(function() return option.resource end)) .. " link=" .. text(option.link))
                    local defs = get(function() return option.definitions end)
                    if defs ~= nil then
                        local n = 0
                        for _, def in ipairs(defs) do
                            n = n + 1
                            if n <= 40 then log("DEFINITION option=" .. name .. " ordinal=" .. n .. " index=" .. tostring(def.index) .. " name=" .. text(def.name)) end
                        end
                        log("DEFINITION COUNT option=" .. name .. " total=" .. n)
                    end
                end
            end
        end)
        if not ok then log("ERROR resource callback: " .. tostring(err)) end
        heldTokens[key] = nil
    end}})
end)
registerForEvent("onUpdate", function(dt)
    if index > #times or Game.GetPlayer() == nil then return end
    elapsed = elapsed + dt
    if elapsed < times[index] then return end
    local ok, err = pcall(function()
        snapshot("automatic-" .. index)
        if index == 1 then
            inspectCustomization("2bt\\gorilla_arms\\patches\\female_cco.inkcharcustomization")
            inspectCustomization("base\\gameplay\\gui\\fullscreen\\main_menu\\female_cco.inkcharcustomization")
            inspectCustomization("ep1\\gameplay\\gui\\fullscreen\\main_menu\\female_cco_ep1.inkcharcustomization")
        end
    end)
    if not ok then log("ERROR snapshot: " .. tostring(err)) end
    index = index + 1
end)
registerHotkey("realskinn_arm_probe_snapshot", "RealSkinn: read-only arm snapshot", function()
    local ok, err = pcall(function() snapshot("manual") end)
    if not ok then log("ERROR manual: " .. tostring(err)) end
end)
return {}
