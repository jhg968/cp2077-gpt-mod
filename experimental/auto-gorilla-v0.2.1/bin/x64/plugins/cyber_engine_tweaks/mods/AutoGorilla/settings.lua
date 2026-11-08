local M = {}
M.defaults = {parry = true, counter = true, cost = 10, interval = 1.2, damage = 1, debug = false}
local bounds = {cost = {0, 100}, interval = {0.3, 10}, damage = {0, 5}}

function M.normalize(raw)
  local result = {}
  raw = type(raw) == "table" and raw or {}
  for key, default in pairs(M.defaults) do
    local value = raw[key]
    if type(value) ~= type(default) then value = default end
    if type(value) == "number" then
      if value ~= value or value == math.huge or value == -math.huge then value = default end
      value = math.max(bounds[key][1], math.min(bounds[key][2], value))
    end
    result[key] = value
  end
  return result
end

function M.load()
  local file = io.open("settings.json", "r")
  if not file then return M.normalize({}) end
  local text = file:read("*a")
  file:close()
  local ok, decoded = pcall(json.decode, text)
  if not ok or type(decoded) ~= "table" then
    print("[AutoGorilla] Invalid settings.json; using defaults until a setting is changed.")
    return M.normalize({})
  end
  return M.normalize(decoded)
end

function M.save(values)
  local ok, err = pcall(function()
    local file = assert(io.open("settings.json", "w"))
    local written, writeErr = file:write(json.encode(M.normalize(values)))
    local closed, closeErr = file:close()
    assert(written, writeErr)
    assert(closed, closeErr)
  end)
  if not ok then print("[AutoGorilla] Cannot save settings: " .. tostring(err)) end
  return ok
end

function M.apply(player, values)
  if not player then return end
  player.agEnableParry = values.parry
  player.agEnableCounter = values.counter
  player.agCost = values.cost
  player.agInterval = values.interval
  player.agDamage = values.damage
  if not values.parry or not values.counter then player.agPending = false end
  -- An attack already in progress finishes through the game's normal exit.
  player.agSettingsReady = true
end

return M
