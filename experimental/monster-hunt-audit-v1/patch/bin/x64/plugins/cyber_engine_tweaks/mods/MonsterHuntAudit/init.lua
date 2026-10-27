-- CP2077 2.50 Monster Hunt / sts_wat_kab_07: observation only.
-- No quest, journal, inventory, reward, or player state is written.
local facts = {
    "#kab_07_enemies_alerted",
    "holo_reggie_calls_v_end_activate",
    "holo_reggie_calls_v_start_activate",
    "kab_07_2nd_floor_cleared",
    "kab_07_done",
    "kab_07_enemies_alerted",
    "kab_07_failed",
    "kab_07_finished",
    "kab_07_fixer_car_drives_away",
    "kab_07_fixer_car_spawns",
    "kab_07_gang_retaliation",
    "kab_07_hologram_distrac_001",
    "kab_07_jotaro_killed",
    "kab_07_no_kill",
    "kab_07_smoke_spread",
    "kab_07_start",
    "kab_07_testdef",
    "sts_tygerclaws_retaliation",
    "sts_wat_kab_tier_1",
    "sts_wat_kab_tier_1_1",
    "sts_wat_kab_tier_1_2",
    "sts_wat_kab_tier_1_3",
    "sts_wat_kab_tier_1_4",
    "sts_wat_kab_tier_2",
    "sts_wat_kab_tier_2_1",
    "sts_wat_kab_tier_2_2",
    "sts_wat_kab_tier_3",
    "sts_wat_kab_tier_3_2",
    "wat_achievement",
    "welcome_holocall_skipped",
    "kab_02_finished",
    "kab_03_finished",
    "kab_04_finished",
    "kab_05_finished",
    "kab_06_finished",
    "kab_08_finished",
    "kab_101_finished",
    "kab_102_finished",
    "kab_107_finished",
}
local elapsed, collected, overlay = 0, false, false
local status = 'Load your save; one snapshot will be collected automatically.'

local function snapshot(reason)
    local playerOK, player = pcall(function() return Game.GetPlayer() end)
    if not playerOK or not player then
        status = 'Player unavailable. Load your save and try again.'
        return false
    end
    local questsOK, quests = pcall(function() return Game.GetQuestsSystem() end)
    if not questsOK or not quests then
        status = 'QuestsSystem unavailable. Try again after loading.'
        return false
    end
    local lines = {
        '[MonsterHuntAudit v1] BEGIN reason=' .. reason,
        '[MonsterHuntAudit v1] scope=sts_wat_kab_07 read_only=true',
        '[MonsterHuntAudit v1] NOTE: 0 alone cannot distinguish unset from explicitly zero.',
        '[MonsterHuntAudit v1] NOTE: facts alone do not prove reward delivery or journal success.'
    }
    local failures = 0
    for _, name in ipairs(facts) do
        local ok, value = pcall(function() return quests:GetFactStr(name) end)
        if not ok or value == nil then
            failures = failures + 1
            lines[#lines + 1] = '[MonsterHuntAudit v1] ' .. name .. '=READ_ERROR ' .. tostring(value)
        else
            lines[#lines + 1] = '[MonsterHuntAudit v1] ' .. name .. '=' .. tostring(value)
        end
    end
    lines[#lines + 1] = '[MonsterHuntAudit v1] END read_errors=' .. failures
    for _, line in ipairs(lines) do print(line) end
    local fileOK, fileError = pcall(function()
        local file, err = io.open('MonsterHuntAudit.txt', 'w')
        if not file then error(err or 'Cannot open output file') end
        local ok, writeError = file:write(table.concat(lines, '\n') .. '\n')
        local closeOK, closeError = file:close()
        if not ok then error(writeError or 'Write failed') end
        if not closeOK then error(closeError or 'Close failed') end
    end)
    if not fileOK then print('[MonsterHuntAudit v1] File output failed: ' .. tostring(fileError)) end
    status = 'Snapshot collected; read errors: ' .. failures .. '. See MonsterHuntAudit.txt or scripting.log.'
    return true
end

registerForEvent('onInit', function()
    print('[MonsterHuntAudit v1] Loaded. Observation only; awaiting player.')
end)
registerForEvent('onUpdate', function(delta)
    if collected then return end
    elapsed = elapsed + delta
    if elapsed < 10 then return end
    elapsed = 0
    collected = snapshot('automatic')
end)
registerForEvent('onOverlayOpen', function() overlay = true end)
registerForEvent('onOverlayClose', function() overlay = false end)
registerForEvent('onDraw', function()
    if not overlay then return end
    if ImGui.Begin('Monster Hunt Audit v1') then
        ImGui.TextWrapped('Read-only quest fact snapshot. This does not complete the gig.')
        if ImGui.Button('Collect snapshot') then snapshot('button') end
        ImGui.TextWrapped(status)
    end
    ImGui.End()
end)
