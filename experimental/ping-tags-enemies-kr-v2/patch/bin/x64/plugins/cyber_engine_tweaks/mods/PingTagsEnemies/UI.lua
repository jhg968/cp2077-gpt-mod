local UI = { }

local State = { 
    Open = false 
}

local Settings = require("Settings")
local nativeSettings = nil

-- Configuration for switches
local switchConfig = {
    Entities = {
        basePath = "/PingTagsEnemies/Entities",
        subcategory = "태그 대상 설정",
        switches = {
            { key = "Npcs", label = "NPC", description = "NPC 태그를 활성화할까요?", default = true },
            { key = "AccessPoints", label = "액세스 포인트", description = "액세스 포인트 태그를 활성화할까요?", default = false },
            { key = "Cameras", label = "카메라", description = "카메라 태그를 활성화할까요?", default = false },
            { key = "HackableComputers", label = "해킹 가능한 컴퓨터", description = "액세스 포인트로 작동하는 해킹 가능한 컴퓨터의 태그를 활성화할까요?", default = false },
            { key = "Turrets", label = "터렛", description = "터렛 태그를 활성화할까요?", default = false }
        }
    },
    Options = {
        basePath = "/PingTagsEnemies/Options",
        subcategory = "기능 설정",
        switches = {
            { key = "PreventTaggingInactiveCameras", label = "꺼진 카메라 태그 방지", description = "전원이 꺼진 카메라가 태그되지 않도록 할까요?", default = true },
            { key = "UntagTurnedOffCameras", label = "카메라를 끄면 태그 해제", description = "카메라의 전원을 끄면 해당 카메라의 태그를 해제할까요?", default = true },
            { key = "UntagHackedAccessPoints", label = "해킹에 성공한 액세스 포인트 태그 해제", description = "해킹 미니게임에 성공하면 해당 액세스 포인트의 태그를 해제할까요?", default = true },
            { key = "UntagNpcsOnDeath", label = "사망 시 NPC 태그 해제", description = "NPC가 사망했을 때 태그를 해제할까요?", default = false },
            { key = "TagOpticsHighlights", label = "안구 사이버웨어 하이라이트 태그", description = "안구 사이버웨어로 하이라이트된 대상을 태그할까요?", default = false }
        }
    }
}

local function SetupCategory(category)
    local config = switchConfig[category]
    nativeSettings.addSubcategory(config.basePath, config.subcategory)
    for _, switch in ipairs(config.switches) do
        nativeSettings.addSwitch(config.basePath, switch.label, switch.description, Settings[category][switch.key], switch.default, function(state)
            Settings[category][switch.key] = state
            Settings:Save()
        end)
    end
end

local function SetupNativeUI()
    if nativeSettings.pathExists("/PingTagsEnemies") then
        return
    end

    nativeSettings.addTab("/PingTagsEnemies", "핑으로 적 태그")
    SetupCategory("Entities")
    SetupCategory("Options")
    nativeSettings.refresh()
end

function UI.Show() 
    State.Open = true 
end

function UI.Hide() 
    State.Open = false 
end

function UI.DrawImGui()
    if nativeSettings or not State.Open then 
        return 
    end
    
    ImGui.SetNextWindowPos(200, 200, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(350, 390, ImGuiCond.Appearing)

    if not ImGui.Begin("핑으로 적 태그", true) then 
        return 
    end
    ImGui.SetWindowFontScale(0.9)

    local doSave = false
    for category, config in pairs(switchConfig) do
        if ImGui.CollapsingHeader(config.subcategory, ImGuiTreeNodeFlags.DefaultOpen) then
            for i, switch in ipairs(config.switches) do
                Settings[category][switch.key], changed = ImGui.Checkbox(switch.label, Settings[category][switch.key])
                doSave = doSave or changed
            end
        end
        ImGui.Spacing()
    end
    ImGui.End()

    if doSave then
        Settings:Save()
    end
end

function UI.Init()
    nativeSettings = GetMod("nativeSettings")
    if nativeSettings then 
        SetupNativeUI()
    end
end

return UI
