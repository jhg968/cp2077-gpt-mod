local function log(message)
  print(message)
  if spdlog and spdlog.info then spdlog.info(message) end
end
log("[AutoGorilla] v0.4.0 native-first bootstrap")
local settings = require("settings")
local values
local native
local elapsed = 0
local ready = false
local last = ""
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
  native.addSwitch(path, "자동 패링", "고릴라 암 대기 중 정면 3m 안 상대의 공격 상태를 감지해 기본 패링 동작을 준비합니다.", values.parry, settings.defaults.parry,
    function(value) change("parry", value) end)
  native.addSwitch(path, "패링 후 자동 반격", "기본 패링 성공 이벤트와 기본 반격 경로를 사용합니다. 이미 시작한 공격은 정상 종료됩니다.", values.counter, settings.defaults.counter,
    function(value) change("counter", value) end)
  native.addRangeFloat(path, "추가 스태미나 비용", "패링 성공 1회당 추가 비용입니다. 기본 반격 자체의 비용은 별도입니다.", 0, 100, 1, "%.0f", values.cost, settings.defaults.cost,
    function(value) change("cost", value) end)
  native.addRangeFloat(path, "최소 자동 방어 시도 간격 (초)", "자동 방어 동작을 다시 시도하기까지의 간격입니다. 성공하지 않은 시도에도 적용됩니다.", 0.3, 10, 0.1, "%.1f", values.interval, settings.defaults.interval,
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
  log("[AutoGorilla] v0.4.0 native-first loaded; no synthetic parry flags/events")
end)
registerForEvent("onUpdate", function(dt)
  if not values then return end
  elapsed = elapsed + dt
  if elapsed < 0.1 then return end
  elapsed = 0
  local p = Game.GetPlayer()
  if not p then ready=false; last=""; return end
  local ok, err = pcall(function()
    settings.apply(p, values)
    if not ready then log("[AutoGorilla] native-first bridge ready"); ready=true end
    for _, line in ipairs(AGNativeTrace.Drain(p)) do log("[AutoGorilla NativeTrace] " .. line) end
    local summary = string.format("auto_deflect=%s native_parry=%s native_counter=%s sensor=%s dropped=%s",
      tostring(p.ag4DeflectCount), tostring(p.ag4ParryCount), tostring(p.ag4CounterCount), tostring(p.ag4Sensor), tostring(p.agNDropped))
    if values.debug and summary ~= last then log("[AutoGorilla] " .. summary) end
    last = summary
  end)
  if not ok and last ~= "error" then
    log("[AutoGorilla] bridge/trace error: " .. tostring(err))
    last = "error"
  end
end)
registerForEvent("onShutdown", function()
  local p = Game.GetPlayer()
  if not p then return end
  local ok, err = pcall(function()
    for _, line in ipairs(AGNativeTrace.Drain(p)) do log("[AutoGorilla NativeTrace] " .. line) end
    p.agNEnabled=false
    p.ag4Ready=false
  end)
  if not ok then log("[AutoGorilla] shutdown trace error: " .. tostring(err)) end
end)
