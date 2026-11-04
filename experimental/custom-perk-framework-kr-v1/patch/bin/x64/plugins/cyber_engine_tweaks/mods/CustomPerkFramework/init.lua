local settings = {
  version = "1.0.0",
  ui = {
    controller_type = 1
  }
}

local defaults = {}
for k, v in pairs(settings) do
  if type(v) == 'table' then
    defaults[k] = {}
    for k2, v2 in pairs(v) do
      defaults[k][k2] = v2
    end
  else
    defaults[k] = v
  end
end

local configFileName = "config.json"
local nativeSettings = nil

local function LoadSettings()
  local file = io.open(configFileName, "r")
  if file then
    local content = file:read("*all")
    file:close()
    local loaded = json.decode(content)
    if loaded then
      for k, v in pairs(loaded) do
        if type(v) == 'table' and type(settings[k]) == 'table' then
          for k2, v2 in pairs(v) do
            settings[k][k2] = v2
          end
        else
          settings[k] = v
        end
      end
    end
  end
end

local function SaveSettings()
  local file = io.open(configFileName, "w")
  if file then
    file:write(json.encode(settings))
    file:close()
  end
end

registerForEvent("onInit", function()
  print("[Custom Perk Framework] 초기화 중...")

  LoadSettings()

  Override('CustomPerkFramework.CustomPerkFrameworkConfig', 'ControllerType;', function()
    return Enum.new('CustomPerkFramework.CPFGamepadControllerType', settings.ui.controller_type - 1)
  end)


  nativeSettings = GetMod("nativeSettings")
  if nativeSettings then
    nativeSettings.addTab("/CustomPerkFramework", "Custom Perk Framework")
    nativeSettings.addSubcategory("/CustomPerkFramework/UI", "UI 설정")

    local controllerTypes = {"키보드 & 마우스", "Xbox", "PlayStation", "Stadia", "Nintendo"}
    nativeSettings.addSelectorString("/CustomPerkFramework/UI", "입력 방식",
      "올바른 버튼 아이콘을 표시하려면 사용하는 입력 장치를 선택하세요.",
      controllerTypes, settings.ui.controller_type, 1, function(value)
        settings.ui.controller_type = value
        SaveSettings()
      end)

    print("[Custom Perk Framework] Native Settings UI 등록 완료")
  end

  print("[Custom Perk Framework] 초기화 완료!")
end)

return {
  settings = settings,
  defaults = defaults
}
