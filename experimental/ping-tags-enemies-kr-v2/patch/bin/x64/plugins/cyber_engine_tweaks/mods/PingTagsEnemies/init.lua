local PingTagsEnemies = require("PingTagsEnemies")
local Settings = require("Settings")
local UI = require("UI")

--Events
registerForEvent("onInit", function()
    Settings:Load()
    UI.Init()
    PingTagsEnemies.Init()
    print("PingTagsEnemies: Loaded.")
end)

registerForEvent('onOverlayOpen', UI.Show)

registerForEvent('onOverlayClose', UI.Hide)

registerForEvent('onDraw', UI.DrawImGui)

--Bindings
registerInput("untag_all_key", "전체 태그 해제", PingTagsEnemies.OnKey_UntagAll)