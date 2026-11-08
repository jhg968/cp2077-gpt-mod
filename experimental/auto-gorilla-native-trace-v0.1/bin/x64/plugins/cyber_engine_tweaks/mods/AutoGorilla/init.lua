local enabled = true
local elapsed = 0
local ready = false
local lastDropped = 0

local function log(message)
  local line = "[AutoGorilla NativeTrace] " .. message
  print(line)
  if spdlog and spdlog.info then spdlog.info(line) end
end

registerForEvent("onInit", function()
  log("native-only tracer loaded; this package does not implement automatic parry")
  local ui = GetMod("nativeSettings")
  if ui then
    ui.addTab("/autoGorillaNativeTrace", "AutoGorilla Native Trace")
    ui.addSwitch("/autoGorillaNativeTrace", "수동 패링 추적", "전투 판정을 바꾸지 않고 기본 입력·방어·반격 경로만 기록합니다.", enabled, true, function(value)
      enabled = value
      local p = Game.GetPlayer()
      if p then p.agNEnabled = enabled end
      log("capture=" .. tostring(enabled))
    end)
    ui.addButton("/autoGorillaNativeTrace", "테스트 구간 표시", "이 버튼을 누른 뒤 수동 패링을 시작하세요.", "기록 표시", 30, function()
      log("========== MANUAL TEST MARKER ==========")
    end)
  end
end)

registerForEvent("onUpdate", function(dt)
  elapsed = elapsed + dt
  if elapsed < 0.1 then return end
  elapsed = 0
  local p = Game.GetPlayer()
  if not p then ready = false; return end
  local ok, err = pcall(function()
    p.agNEnabled = enabled
    if not ready then
      log("bridge ready; capture=" .. tostring(enabled))
      ready = true
    end
    for _, line in ipairs(AGNativeTrace.Drain(p)) do log(line) end
    if p.agNDropped ~= lastDropped then
      log("buffer_dropped=" .. tostring(p.agNDropped))
      lastDropped = p.agNDropped
    end
  end)
  if not ok and ready ~= "error" then
    log("trace error: " .. tostring(err))
    ready = "error"
  end
end)

registerForEvent("onShutdown", function()
  local p = Game.GetPlayer()
  if not p then return end
  local ok, err = pcall(function()
    for _, line in ipairs(AGNativeTrace.Drain(p)) do log(line) end
    p.agNEnabled = false
  end)
  if not ok then log("shutdown trace error: " .. tostring(err)) end
end)
