-- Explicit one-shot lethal-path experiment. Only our request fact is written.
local prefix = 'jhg968_mh_native_v1_'
local watched = {
    prefix .. 'ready', prefix .. 'request', prefix .. 'dispatched',
    'kab_07_start', 'kab_07_failed', 'kab_07_jotaro_killed',
    'kab_07_no_kill', 'kab_07_done', 'kab_07_finished',
    'kab_07_fixer_car_spawns', 'kab_07_fixer_car_drives_away',
    'wat_achievement', 'sts_wat_kab_tier_1', 'sts_wat_kab_tier_1_1',
}
local overlay, attempted, monitoring = false, false, false
local elapsed, sample, buffer = 0, 0, {}
local status = 'Load the test save and collect status first.'
local function emit(line)
    local text = '[MonsterHuntNativeTrial v1] ' .. line
    print(text)
    buffer[#buffer + 1] = text
    if #buffer > 1000 then table.remove(buffer, 1) end
end
local function saveReport()
    local ok, err = pcall(function()
        local f, e = io.open('MonsterHuntNativeTrial.txt', 'w')
        if not f then error(e or 'Cannot open report') end
        local written, why = f:write(table.concat(buffer, '\n') .. '\n')
        local closed, closeError = f:close()
        if not written then error(why or 'Cannot write report') end
        if not closed then error(closeError or 'Cannot close report') end
    end)
    if not ok then print('[MonsterHuntNativeTrial v1] Report error: ' .. tostring(err)) end
end
local function read()
    assert(Game.GetPlayer(), 'Player unavailable; load a save first.')
    local q = assert(Game.GetQuestsSystem(), 'QuestsSystem unavailable.')
    local values = {}
    for _, fact in ipairs(watched) do
        local v = q:GetFactStr(fact)
        assert(type(v) == 'number', 'Cannot read fact: ' .. fact)
        values[fact] = v
    end
    return values, q
end
local function snapshot(reason)
    local ok, values = pcall(read)
    emit('SNAPSHOT ' .. reason)
    if ok then
        for _, fact in ipairs(watched) do emit(fact .. '=' .. values[fact]) end
        status = 'ready=' .. values[prefix .. 'ready'] .. ', dispatched=' .. values[prefix .. 'dispatched']
            .. ', target killed=' .. values.kab_07_jotaro_killed
            .. ', done=' .. values.kab_07_done .. ', finished=' .. values.kab_07_finished
    else
        status = tostring(values)
        emit('READ_ERROR ' .. status)
    end
    saveReport()
    return ok, values
end
local function request()
    if attempted then status = 'Already attempted this session. Reload the pre-test save to retry.'; return end
    local ok, err = pcall(function()
        local v, q = read()
        assert(v[prefix .. 'ready'] == 1, 'Injected phase not ready. Build/install the archive and check ArchiveXL log.')
        assert(v[prefix .. 'request'] == 0 and v[prefix .. 'dispatched'] == 0, 'This save already contains a trial request.')
        assert(v.kab_07_start == 1, 'Monster Hunt has not started.')
        assert(v.kab_07_failed == 0 and v.kab_07_done == 0 and v.kab_07_finished == 0, 'Quest is failed or already finishing/completed.')
        assert(v.kab_07_jotaro_killed == 0 and v.kab_07_no_kill == 0, 'A target outcome is already recorded.')
        snapshot('before_request')
        attempted = true -- Never automatically repeat after an uncertain write failure.
        emit('REQUEST lethal path; this is not a reward or completion acknowledgement.')
        saveReport()
        q:SetFactStr(prefix .. 'request', 1)
        elapsed, sample, monitoring = 0, 0, true
        status = 'Request sent. Wait for the original quest; leave the area if prompted.'
    end)
    if not ok then status = tostring(err); emit('REQUEST_STOP ' .. status); saveReport() end
end
registerForEvent('onInit', function()
    emit('Loaded. No automatic quest action. SOURCE BUILD REQUIRED.')
end)
registerForEvent('onOverlayOpen', function() overlay = true end)
registerForEvent('onOverlayClose', function() overlay = false end)
registerForEvent('onDraw', function()
    if not overlay then return end
    if ImGui.Begin('Monster Hunt Native Trial v1') then
        ImGui.TextWrapped('Experimental LETHAL path for Monster Hunt only. Use a separate save near Ho-Oh Club.')
        ImGui.TextWrapped('This does not force journal success or grant rewards. ArchiveXL injection must be ready.')
        if ImGui.Button('Collect status') then snapshot('manual') end
        if ImGui.Button('Run lethal-path trial (one attempt)') then request() end
        ImGui.TextWrapped(status)
    end
    ImGui.End()
end)
registerForEvent('onUpdate', function(delta)
    if not monitoring then return end
    elapsed = elapsed + delta
    local times = {1, 5, 15, 30, 60, 120}
    if sample < #times and elapsed >= times[sample + 1] then
        sample = sample + 1
        local ok = snapshot('after_' .. times[sample] .. '_seconds')
        if not ok then monitoring = false end
    end
    if sample >= #times then
        monitoring = false
        emit('Monitoring ended. Facts alone do not verify money, XP, journal or follow-up rewards.')
        saveReport()
    end
end)
