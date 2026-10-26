-- RealSkinn 2.2: loading-order fix and resource-patch diagnostics.
-- Original archive, appearance definitions and body/hiding tags are unchanged.
local SOURCE_PATHS = {
    "2bt\\gorilla_arms\\patches\\female_cco.inkcharcustomization",
    "2bt\\gorilla_arms\\patches\\male_cco.inkcharcustomization"
}
local TARGET_PATHS = {
    "base\\gameplay\\gui\\fullscreen\\main_menu\\female_cco.inkcharcustomization",
    "base\\gameplay\\gui\\fullscreen\\main_menu\\male_cco.inkcharcustomization",
    "ep1\\gameplay\\gui\\fullscreen\\main_menu\\female_cco_ep1.inkcharcustomization",
    "ep1\\gameplay\\gui\\fullscreen\\main_menu\\male_cco_ep1.inkcharcustomization"
}
local OPTION_NAMES = {
    h_strong_arms_colors_cyberware01_tpp = true,
    h_strong_arms_colors_cyberware01_fpp = true,
    u_strong_arms_colors_cyberware01_fpp = true,
    h_strong_arms_colors_cyberware01 = true,
    u_strong_arms_colors_cyberware01 = true
}
local sources, owners = {}, {}
-- GetHash() can return a fresh uint64 cdata object on each call.
-- Use its exact string form as the table key; tonumber would lose precision.
local sourceTokens, sourcePaths = {}, {}
local targetTokens, targetPaths = {}, {}
local sourceCallback, targetCallback, eventCallback
local pendingSources, sourcesReady, targetsStarted = 0, false, false
local sourceFailures, optionsLoaded = 0, 0
local earlyEvents = {}
local function log(message)
    print("[RealSkinnDiag v2] " .. message)
end
local function patchResource(resource, label)
    if resource == nil then
        log("ERROR target resource is nil: " .. label)
        return
    end
    local matched, total = 0, 0
    for _, option in ipairs(resource.armsCustomizationOptions) do
        total = total + 1
        local name = NameToString(option.name)
        local source = sources[name]
        if source ~= nil then
            option.definitions = source.definitions
            option.link = source.link
            option.randomizeCategory = source.randomizeCategory
            matched = matched + 1
            log("APPLY option=" .. name .. " source=" .. owners[name] .. " target=" .. label)
        end
    end
    log("PATCH target=" .. label .. " matched=" .. matched .. " options=" .. total)
    if matched == 0 then
        log("WARNING no matching Gorilla Arms options in target=" .. label)
    end
end
local function guarded(label, fn)
    return function(arg)
        local ok, err = pcall(fn, arg)
        if not ok then log("ERROR callback=" .. label .. " detail=" .. tostring(err)) end
    end
end
local function patchTargets()
    if targetsStarted then return end
    targetsStarted = true
    if optionsLoaded == 0 then
        log("ERROR no source options loaded; target patching skipped")
        return
    end
    sourcesReady = true
    log("SOURCES COMPLETE loadedOptions=" .. optionsLoaded .. " failures=" .. sourceFailures)
    targetCallback = NewProxy({
        OnResourceReady = {
            args = {"handle:ResourceToken"},
            callback = guarded("target-ready", function(token)
                local hash = tostring(token:GetHash())
                local label = targetPaths[hash] or tostring(hash)
                patchResource(token:GetResource(), label)
                targetTokens[hash], targetPaths[hash] = nil, nil
            end)
        }
    })
    for _, path in ipairs(TARGET_PATHS) do
        local token = Game.GetResourceDepot():LoadResource(path)
        if token == nil or token:IsFailed() then
            log("ERROR target load failed: " .. path)
        else
            local hash = tostring(token:GetHash())
            targetTokens[hash], targetPaths[hash] = token, path
            token:RegisterCallback(targetCallback:Target(), targetCallback:Function("OnResourceReady"))
        end
    end
    for _, resource in ipairs(earlyEvents) do
        patchResource(resource, "Resource/Load (deferred)")
    end
    earlyEvents = {}
end
local function loadSources()
    -- The barrier prevents an immediately completed callback from starting
    -- target loads before every source request has been scheduled.
    pendingSources = 1
    sourceCallback = NewProxy({
        OnResourceReady = {
            args = {"handle:ResourceToken"},
            callback = guarded("source-ready", function(token)
                local hash = tostring(token:GetHash())
                local label = sourcePaths[hash] or tostring(hash)
                if sourceTokens[hash] == nil then
                    log("WARNING duplicate/untracked source callback: " .. label)
                    return
                end
                local ok, err = pcall(function()
                    local resource = token:GetResource()
                    if resource == nil then error("source resource is nil") end
                    local count = 0
                    for _, option in ipairs(resource.armsCustomizationOptions) do
                        local name = NameToString(option.name)
                        if OPTION_NAMES[name] then
                            if owners[name] ~= nil and owners[name] ~= label then
                                log("WARNING source option overlap=" .. name .. " previous=" .. owners[name] .. " new=" .. label)
                            end
                            sources[name], owners[name] = option, label
                            optionsLoaded, count = optionsLoaded + 1, count + 1
                        end
                    end
                    log("SOURCE READY path=" .. label .. " matched=" .. count)
                    if count == 0 then log("WARNING source contains no matching options: " .. label) end
                end)
                if not ok then
                    sourceFailures = sourceFailures + 1
                    log("ERROR source=" .. label .. " detail=" .. tostring(err))
                end
                sourceTokens[hash], sourcePaths[hash] = nil, nil
                pendingSources = pendingSources - 1
                if pendingSources == 0 then patchTargets() end
            end)
        }
    })
    for _, path in ipairs(SOURCE_PATHS) do
        local token = Game.GetResourceDepot():LoadResource(path)
        if token == nil or token:IsFailed() then
            sourceFailures = sourceFailures + 1
            log("ERROR source load failed: " .. path)
        else
            local hash = tostring(token:GetHash())
            sourceTokens[hash], sourcePaths[hash] = token, path
            pendingSources = pendingSources + 1
            token:RegisterCallback(sourceCallback:Target(), sourceCallback:Function("OnResourceReady"))
        end
    end
    pendingSources = pendingSources - 1
    if pendingSources == 0 then patchTargets() end
end
local function setUpResourceEventListener()
    eventCallback = NewProxy({
        OnResourceLoad = {
            args = {"handle:ResourceEvent"},
            callback = guarded("resource-load", function(event)
                local resource = event:GetResource()
                if resource == nil then log("ERROR Resource/Load resource is nil"); return end
                if sourcesReady then
                    patchResource(resource, "Resource/Load")
                else
                    table.insert(earlyEvents, resource)
                    log("Resource/Load deferred until sources are ready")
                end
            end)
        }
    })
    Game.GetCallbackSystem()
        :RegisterCallback(CName.new("Resource/Load"), eventCallback:Target(), eventCallback:Function("OnResourceLoad"))
        :AddTarget(ResourceTarget.Path(TARGET_PATHS[1]))
        :AddTarget(ResourceTarget.Path(TARGET_PATHS[2]))
        :AddTarget(ResourceTarget.Path(TARGET_PATHS[3]))
        :AddTarget(ResourceTarget.Path(TARGET_PATHS[4]))
        :SetRunMode(CallbackRunMode.Forever)
end
registerForEvent("onInit", function()
    log("START: diagnostic resource patch; no archive/body/tag changes")
    setUpResourceEventListener()
    loadSources()
    log("INIT scheduled; pendingSources=" .. pendingSources .. ". This is not confirmation of visible arms.")
end)
return {}
