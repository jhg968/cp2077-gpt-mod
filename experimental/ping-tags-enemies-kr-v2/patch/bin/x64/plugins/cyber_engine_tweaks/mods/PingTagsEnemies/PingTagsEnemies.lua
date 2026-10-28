local PingTagsEnemies = {
    Version = "1.3.2"
}
local Settings = require("Settings")

local validEventReasons = {
    PingQuickhack = 1,
    network = 1,
    highlightEffector = 2
}

local function ShouldTagEntity(gameObject)
    --entity is already tagged
    if gameObject:IsTaggedinFocusMode() then 
        return false 
    end

    --entity type check
    if gameObject:IsNPC() then
        return Settings.Entities.Npcs and not (Settings.Options.UntagNpcsOnDeath and (gameObject:IsDead() or gameObject:IsIncapacitated()))
    elseif gameObject:IsAccessPoint() and gameObject:IsActiveBackdoor() then
        return Settings.Entities.AccessPoints
    elseif gameObject:IsSensor() then
        -- Skip if the camera is turned off and we want to prevent tagging inactive cameras
        if not Settings.Entities.Cameras or (Settings.Options.PreventTaggingInactiveCameras and not (gameObject:GetDevicePS()):IsON()) then
            return false
        end
        return true
    elseif gameObject:IsTurret() then
        return Settings.Entities.Turrets
    elseif gameObject:IsDevice() and gameObject:IsActiveBackdoor() then --Hackable Computer (AP)
        return Settings.Entities.HackableComputers
    end
    return false
end

local function TagRevealedEntities(instance, evt)    
    local eventReasonVal = validEventReasons[evt.reason.reason.value] or 0
    if evt.state == ERevealState.STOPPED or eventReasonVal == 0 then
        return
    end

    -- Check setting for optics cyberware
    if eventReasonVal == 2 and not Settings.Options.TagOpticsHighlights then
        return
    end

    local owner = instance:GetOwner()
    if not ShouldTagEntity(owner) then
        return
    end

    GameObject.TagObject(owner)
end

local function UntagTurnedOffCameras(instance, ...)
    if not Settings.Options.UntagTurnedOffCameras then
        return
    end    
    GameObject.UntagObject(instance)
end

local function UntagHackedAccessPoints(instance, evt)   
    if evt.minigameState ~= gameuiHackingMinigameState.Succeeded or not Settings.Options.UntagHackedAccessPoints then 
        return 
    end
    GameObject.UntagObject(instance)
end

local function UntagNpcsOnDeath(instance, ...)
    if not Settings.Options.UntagNpcsOnDeath then
        return
    end
    GameObject.UntagObject(instance)
end

function PingTagsEnemies.OnKey_UntagAll(keypress)
    if not keypress then 
        return 
    end

    local player = Game.GetPlayer()
    if not player then 
        return 
    end

    local tagSystem = player:GetTaggingSystem()
    if not tagSystem then
        return
    end

    tagSystem:RequestUntagAll()
end

function PingTagsEnemies.Init()
    --Observes
    ObserveAfter("ScanningComponent", "OnRevealStateChanged", TagRevealedEntities)   
    ObserveAfter("SensorDevice", "TurnOffDevice", UntagTurnedOffCameras)     
    ObserveAfter("SensorDevice", "OnDeath", UntagTurnedOffCameras)     
    ObserveAfter("Device", "OnAccessPointMiniGameStatus", UntagHackedAccessPoints)
    ObserveAfter("NPCPuppet", "OnDeath", UntagNpcsOnDeath)
    ObserveAfter("NPCPuppet", "OnIncapacitated", UntagNpcsOnDeath)    
end

return PingTagsEnemies