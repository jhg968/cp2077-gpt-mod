local settings = require("settings")
local values
local last = ""
local elapsed = 0
local native

local function change(key, value)
  values[key] = value
  values = settings.normalize(values)
  settings.apply(Game.GetPlayer(), values)
  settings.save(values)
end

local function setupUI()
  native = GetMod("nativeSettings")
  if not native then
    print("[AutoGorilla] Install Native Settings UI (Nexus 3518) for the Mods settings menu.")
    return
  end
  native.addTab("/autoGorilla", "AutoGorilla")
  native.addSubcategory("/autoGorilla/gorilla", "고릴라 암 자동 패링·반격")
  local path = "/autoGorilla/gorilla"
  native.addSwitch(path, "자동 패링", "고릴라 암 근접 대기 중 정면의 일반 근접 공격을 자동 패링합니다.", values.parry, settings.defaults.parry,
    function(value) change("parry", value) end)
  native.addSwitch(path, "패링 후 자동 반격", "자동 패링 성공 후 기본 반격을 요청합니다. 이미 시작한 공격은 정상 종료됩니다.", values.counter, settings.defaults.counter,
    function(value) change("counter", value) end)
  native.addRangeFloat(path, "추가 스태미나 비용", "패링 성공 1회당 추가 비용입니다. 기본 반격 자체의 비용은 별도입니다.", 0, 100, 1, "%.0f", values.cost, settings.defaults.cost,
    function(value) change("cost", value) end)
  native.addRangeFloat(path, "최소 발동 간격 (초)", "변경한 간격은 다음 패링부터 적용됩니다. 진행 중 쿨다운은 유지됩니다.", 0.3, 10, 0.1, "%.1f", values.interval, settings.defaults.interval,
    function(value) change("interval", value) end)
  native.addRangeFloat(path, "반격 피해 배율", "기본 반격 피해에 곱합니다. 1.0이 기본 피해입니다.", 0, 5, 0.1, "%.1f", values.damage, settings.defaults.damage,
    function(value) change("damage", value) end)
  native.addSwitch(path, "진단 로그", "CET 콘솔에 패링·반격·타격 경로 횟수를 표시합니다.", values.debug, settings.defaults.debug,
    function(value) change("debug", value) end)
end

registerForEvent("onInit", function()
  values = settings.load()
  settings.apply(Game.GetPlayer(), values)
  setupUI()
  print("[AutoGorilla] v0.2 experimental; settings loaded")
end)

registerForEvent("onUpdate", function(dt)
  if not values then return end
  elapsed = elapsed + dt
  if elapsed < 0.1 then return end
  elapsed = 0
  local p = Game.GetPlayer()
  if not p then last = ""; return end
  local ok, err = pcall(function()
    -- Also restores configuration after loading a save/new player instance.
    settings.apply(p, values)
    local defs = GetAllBlackboardDefs()
    local bb = p:GetPlayerStateMachineBlackboard()
    local state = bb:GetInt(defs.PlayerStateMachine.MeleeWeapon)
    local menu = Game.GetBlackboardSystem():Get(defs.UI_System):GetBool(defs.UI_System.IsInMenu)
    local changed = p.agWeapon and p.agWeapon ~= GameObject.GetActiveWeapon(p)
    if menu or changed or (state ~= 10 and state ~= 20) then p.agCounter = false end
    if menu or changed or not AGConfig.Pending(p) then p.agPending = false end
    local s = string.format("parry=%s counter_enter=%s hit_pipeline=%s state=%s", tostring(p.agParries), tostring(p.agCounters), tostring(p.agHits), tostring(state))
    if values.debug and s ~= last then print("[AutoGorilla] " .. s) end
    last = s
  end)
  if not ok and last ~= "error" then
    print("[AutoGorilla] diagnostics error: " .. tostring(err))
    last = "error"
  end
end)
