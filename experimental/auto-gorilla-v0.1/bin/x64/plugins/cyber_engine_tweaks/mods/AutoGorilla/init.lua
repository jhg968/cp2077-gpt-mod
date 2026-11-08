local last = ""
local elapsed = 0
registerForEvent("onInit", function()
  print("[AutoGorilla] v0.1 experimental; loaded")
end)
registerForEvent("onUpdate", function(dt)
  elapsed = elapsed + dt
  if elapsed < 0.1 then return end
  elapsed = 0
  local p = Game.GetPlayer()
  if not p then last = ""; return end
  local ok, err = pcall(function()
    local defs = GetAllBlackboardDefs()
    local bb = p:GetPlayerStateMachineBlackboard()
    local state = bb:GetInt(defs.PlayerStateMachine.MeleeWeapon)
    local menu = Game.GetBlackboardSystem():Get(defs.UI_System):GetBool(defs.UI_System.IsInMenu)
    local changed = p.agWeapon and p.agWeapon ~= GameObject.GetActiveWeapon(p)
    if menu or changed or (state ~= 10 and state ~= 20) then p.agCounter = false end
    if menu or changed or not AGConfig.Pending(p) then p.agPending = false end
    local s = string.format("parry=%s counter_enter=%s hit_pipeline=%s state=%s", tostring(p.agParries), tostring(p.agCounters), tostring(p.agHits), tostring(state))
    if s ~= last then print("[AutoGorilla] " .. s); last = s end
  end)
  if not ok and last ~= "error" then
    print("[AutoGorilla] diagnostics error: " .. tostring(err))
    last = "error"
  end
end)
