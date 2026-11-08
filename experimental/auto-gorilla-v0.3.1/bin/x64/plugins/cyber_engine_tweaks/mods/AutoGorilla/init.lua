local function log(message)
  print(message)
  if spdlog and spdlog.info then spdlog.info(message) end
end
log("[AutoGorilla] v0.3.1 bootstrap")
local settings = require("settings")
local values
local last = ""
local elapsed = 0
local native
local bridgeLogged = false

local function change(key, value)
  values[key] = value
  values = settings.normalize(values)
  settings.apply(Game.GetPlayer(), values)
  settings.save(values)
end

local function setupUI()
  native = GetMod("nativeSettings")
  if not native then
    log("[AutoGorilla] Install Native Settings UI (Nexus 3518) for the Mods settings menu.")
    return
  end
  native.addTab("/autoGorilla", "AutoGorilla")
  native.addSubcategory("/autoGorilla/gorilla", "고릴라 암 자동 패링·반격")
  local path = "/autoGorilla/gorilla"
  native.addSwitch(path, "자동 패링", "고릴라 암 근접 대기 중 정면의 패링 가능한 근접 공격을 자동 패링합니다. 상대 등급·적대 관계로 제외하지 않습니다.", values.parry, settings.defaults.parry,
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
  log("[AutoGorilla] onInit entered")
  values = settings.load()
  settings.apply(Game.GetPlayer(), values)
  setupUI()
  log("[AutoGorilla] v0.3.1 experimental; settings loaded")
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
    if not bridgeLogged then
      log("[AutoGorilla] bridge ready; parry=" .. tostring(p.agEnableParry) .. " counter=" .. tostring(p.agEnableCounter))
      bridgeLogged = true
    end
    local defs = GetAllBlackboardDefs()
    local bb = p:GetPlayerStateMachineBlackboard()
    local state = bb:GetInt(defs.PlayerStateMachine.MeleeWeapon)
    local menu = Game.GetBlackboardSystem():Get(defs.UI_System):GetBool(defs.UI_System.IsInMenu)
    local changed = p.agWeapon and p.agWeapon ~= GameObject.GetActiveWeapon(p)
    if menu or changed then
      p.agCounter = false
      p.agCounterWeapon = nil
      p.agAutoDeflect = false
      p.agCounterArmed = false
    end
    if not AGConfig.Fresh(p) then p.agCounterArmed = false; p.agAutoDeflect = false end
    if menu or changed or not AGConfig.Pending(p) then p.agPending = false end
    local weapon = GameObject.GetActiveWeapon(p)
    local strong = weapon and weapon:WeaponHasTag("StrongArms") or false
    local canDeflect = weapon and AGConfig.WeaponDeflectStat(p) or -1
    local s = string.format("seen=%s reason=%s parry=%s counter_enter=%s hit_pipeline=%s state=%s StrongArms=%s CanDeflect=%s effect_started=%s stamina=%.1f parry_stamina=%.1f->%.1f pending=%s deflect_enter=%s effect_attempt=%s outgoing=%s route=%s counter_checks=%s", tostring(p.agSeenHits), tostring(p.agReason), tostring(p.agParries), tostring(p.agCounters), tostring(p.agHits), tostring(state), tostring(strong), tostring(canDeflect), tostring(p.agEffects), AGConfig.Stamina(p), p.agStaminaBefore, p.agStaminaAfter, tostring(p.agPending), tostring(p.agDeflects), tostring(p.agEffectAttempts), tostring(p.agOutgoing), tostring(p.agRoute), tostring(p.agCounterChecks))
    if values.debug and s ~= last then log("[AutoGorilla] " .. s) end
    last = s
  end)
  if not ok and last ~= "error" then
    log("[AutoGorilla] diagnostics error: " .. tostring(err))
    last = "error"
  end
end)
