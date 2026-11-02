local config = require("modules/config")
local utils = require("modules/utils")
local tweaks = require("modules/tweaks")

local settings = {
    nativeOptions = {},
    nativeSettings = nil,
    changedFromPreset = false
}

local colorPresets = {
    [2] = { red = 0, green = 255, blue = 0 },
    [3] = { red = 255, green = 0, blue = 0 },
    [4] = { red = 0, green = 255, blue = 0 },
    [5] = { red = 0, green = 0, blue = 255 },
    [6] = { red = 255, green = 165, blue = 0 },
    [7] = { red = 0, green = 255, blue = 255 },
    [8] = { red = 255, green = 255, blue = 0 }
}

local function saveColor(mod)
    config.saveFile("config/config.json", mod.settings)
    mod.runtimeData.needApply = true
end

local function addColorChannel(mod, name, label)
    local nativeSettings = settings.nativeSettings

    settings.nativeOptions[name] = nativeSettings.addRangeInt("/nightVision/color", label, "색상 채널 강도: " .. label, 0, 255, 1, mod.settings[name], mod.defaultSettings[name], function(value)
        mod.settings[name] = value

        if settings.changedFromPreset then return end

        if mod.settings.color ~= 1 then
            mod.settings.color = 1
            nativeSettings.setOption(settings.nativeOptions.color, 1)
        end

        saveColor(mod)
    end)
end

function settings.addColorSettings(mod)
    local nativeSettings = settings.nativeSettings
    local list = {
        [1] = "사용자 지정",
        [2] = "기본값",
        [3] = "빨강",
        [4] = "초록",
        [5] = "파랑",
        [6] = "주황",
        [7] = "청록",
        [8] = "노랑"
    }

    settings.nativeOptions.color = nativeSettings.addSelectorString("/nightVision/color", "색상 프리셋", "색상 프리셋을 선택하거나 색상을 직접 조절합니다.", list, mod.settings.color, mod.defaultSettings.color, function(value)
        mod.settings.color = value
        local preset = colorPresets[value]

        if preset then
            settings.changedFromPreset = true
            for _, name in ipairs({ "red", "green", "blue" }) do
                mod.settings[name] = preset[name]
                nativeSettings.setOption(settings.nativeOptions[name], preset[name])
            end
            settings.changedFromPreset = false
            saveColor(mod)
        else
            config.saveFile("config/config.json", mod.settings)
        end
    end)

    addColorChannel(mod, "red", "빨강")
    addColorChannel(mod, "green", "초록")
    addColorChannel(mod, "blue", "파랑")

    settings.nativeOptions.gamma = nativeSettings.addRangeFloat("/nightVision/color", "감마", "나이트 비전의 감마를 조절합니다.", 1.0, 6.0, 0.05, "%.2f", mod.settings.gamma, mod.defaultSettings.gamma, function(value)
        mod.settings.gamma = value
        saveColor(mod)
    end)
end

function settings.addKeybinds(mod)
    -- Keyboard
    local info = mod.inputManager.createBindingInfo()
    info.keybindLabel = "키"
    info.keybindDescription = "단축키 조합에 사용할 키를 설정합니다."
    info.isHoldLabel = "길게 누르기"
    info.supportsHold = false
    info.id = "mkbBinding"
    info.maxKeys = 2
    info.maxKeysLabel = "단축키 조합 개수"
    info.maxKeysDescription = "단축키에 사용할 키 개수를 설정합니다. 설정한 키를 모두 눌러야 기능이 활성화됩니다."
    info.nativeSettingsPath = "/nightVision/hotkeyMKB"
    info.defaultOptions = mod.defaultSettings.keyboard
    info.savedOptions = mod.settings.keyboard
    info.saveCallback = function(name, value)
        mod.settings.keyboard[name] = value
        config.saveFile("config/config.json", mod.settings)
        tweaks.applyTweaks(mod)
    end
    info.callback = function()
        mod:toggleNV()
    end
    mod.inputManager.addNativeSettingsBinding(info)

    -- Gamepad
    info = utils.deepcopy(info)
    info.supportsHold = true
    info.isHoldDescription = "아래에 지정한 키를 일정 시간 길게 눌러야 활성화되도록 설정합니다."
    info.id = "padBinding"
    info.maxKeys = 3
    info.maxKeysLabel = "단축키 조합 개수"
    info.maxKeysDescription = "단축키에 사용할 키 개수를 설정합니다. 설정한 키를 모두 눌러야 기능이 활성화됩니다."
    info.nativeSettingsPath = "/nightVision/hotkeyPad"
    info.defaultOptions = mod.defaultSettings.pad
    info.savedOptions = mod.settings.pad
    info.saveCallback = function(name, value)
        mod.settings.pad[name] = value
        config.saveFile("config/config.json", mod.settings)
        tweaks.applyTweaks(mod)
    end
    mod.inputManager.addNativeSettingsBinding(info)
end

function settings.setupNative(mod)
    local nativeSettings = GetMod("nativeSettings")
    settings.nativeSettings = nativeSettings

    if not nativeSettings then
        print("[NightVision] 정보: NativeSettings 라이브러리를 찾을 수 없습니다!")
        return
    end

    local cetVer = tonumber((GetVersion():gsub('^v(%d+)%.(%d+)%.(%d+)(.*)', function(major, minor, patch, wip) -- <-- This has been made by psiberx, all credits to him
        return ('%d.%02d%02d%d'):format(major, minor, patch, (wip == '' and 0 or 1))
    end)))

    if cetVer < 1.18 then
        print("[NightVision] 오류: CET 버전이 권장 버전보다 낮습니다!")
        return
    end

    nativeSettings.addTab("/nightVision", "나이트 비전 CW")
    nativeSettings.addSubcategory("/nightVision/color", "색상 및 감마")
    nativeSettings.addSubcategory("/nightVision/hotkeyMKB", "키보드 단축키")
    nativeSettings.addSubcategory("/nightVision/hotkeyPad", "컨트롤러 단축키")

    settings.addColorSettings(mod)
    settings.addKeybinds(mod)
end

return settings
