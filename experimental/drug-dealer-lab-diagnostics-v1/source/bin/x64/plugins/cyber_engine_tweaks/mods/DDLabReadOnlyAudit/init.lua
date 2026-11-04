-- Drug Dealer 7.3 lab diagnostics. Reads state only; writes output to CET logs.
local prefix = '[DDLabAudit] '
local locations = {
    {'Watson Northside', -1511.1562, 2182.027, 18.206032, 1.5},
    {'Watson bridge', -1019.01764, 2681.1836, 23.230003, 2.5},
    {'Watson alternative', -615.6574, 2614.8918, 53.78, 1.0},
    {'Santo Domingo', -324.8383, -1646.3445, 7.810066, 2.5},
    {'Badlands RV', 3449.4902, -1125.8821, 101.88655, 2.3},
    {'Westbrook', -271.00928, 1452.3224, 42.1, 1.2},
    {'Heywood', -1171.7756, -1092.9213, 12.841637, 1.2},
    {'Pacifica', -2780.8901, -2485.274, 29.900002, 1.2},
    {'Urban Garden (optional)', 127.36586, -1798.8032, -10.097549, 2.0},
}
local function emit(name, value)
    print(prefix .. name .. '=' .. tostring(value))
end
local function read(name, fn)
    local ok, value = pcall(fn)
    if ok then emit(name, value) else emit(name .. '.read_error', value) end
    return ok, value
end
local function exists(value)
    if value == nil then return false end
    local ok, result = pcall(IsDefined, value)
    return ok and result or (not ok and value ~= nil)
end
local function system(class)
    return Game.GetScriptableSystemsContainer():Get(CName.new(class))
end
local function dump()
    print(prefix .. 'BEGIN v1 (reference locations: original Drug Dealer 7.3)')
    local ok, player = pcall(function() return Game.GetPlayer() end)
    if not ok or not exists(player) then
        emit('player_available', false)
        print(prefix .. 'END')
        return
    end
    local posOk, pos = pcall(function() return player:GetWorldPosition() end)
    if posOk and pos then
        local calcOk, calcError = pcall(function()
            emit('player_position', string.format('x=%.5f y=%.5f z=%.5f', pos.x, pos.y, pos.z))
            local ranked = {}
            for _, lab in ipairs(locations) do
                local dx, dy, dz = pos.x - lab[2], pos.y - lab[3], pos.z - lab[4]
                ranked[#ranked + 1] = {lab=lab, distance=math.sqrt(dx*dx+dy*dy+dz*dz), vertical=math.abs(dz)}
            end
            table.sort(ranked, function(a,b) return a.distance < b.distance end)
            for i=1,math.min(3,#ranked) do
                local r=ranked[i]
                emit('nearest_'..i, string.format('%s distance=%.3fm radius=%.2fm vertical=%.3fm inside=%s', r.lab[1],r.distance,r.lab[5],r.vertical,tostring(r.distance<=r.lab[5])))
            end
        end)
        if not calcOk then emit('position.read_error',calcError) end
    else
        emit('position.read_error', pos)
    end
    local controllerOk, controller = pcall(system, 'DrugDealer.Lab.LabInteractionController')
    emit('lab_controller_exists', controllerOk and exists(controller))
    if controllerOk and exists(controller) then
        read('interaction_shown', function() return controller:IsInteractionShown() end)
        local nearOk, near = pcall(function() return controller:GetNearLabLocation() end)
        if nearOk and near then
            read('controller_near_radius', function() return near.proximityRadius end)
            read('controller_near_position', function()
                return string.format('x=%.5f y=%.5f z=%.5f',near.location.x,near.location.y,near.location.z)
            end)
        else
            emit('controller_near.read_error', near)
        end
    elseif not controllerOk then
        emit('lab_controller.read_error', controller)
    end
    for _, class in ipairs({'NightlyNow.Notification.NotificationSystem','DrugDealer.Lab.LabCookingSystem'}) do
        read(class .. '.exists',function() return exists(system(class)) end)
    end
    for _, key in ipairs({'DD.Lab.MainInteractionTitle','DD.Lab.SecondaryInteractionTitle'}) do
        read('localized.'..key,function() return GetLocalizedTextByKey(key) end)
    end
    print(prefix .. 'END')
end
registerForEvent('onInit', function()
    print(prefix .. 'Loaded. Stand at the lab and open CET to capture state. No settings, inventory, quest or player state changes.')
end)
registerForEvent('onOverlayOpen', dump)
registerHotkey('DDLabReadOnlyAuditDump', 'Drug Dealer: capture lab diagnostics', dump)
