local Set = require('libs/Set')

local ft = {
    uiVisible = false
}

local function log(message)
    print("[KiasuBurgerReplacer] " .. message)
end

local left_nails = {
    "a0_000_pwa_base_nails_l",
    "a0_000_pwa_base__nails_l",
    "a0_000_pwa_fpp__nails_l",
    "a0_000_pma_base__nails_l",
    "a0_003_wa__mantisblade_nails_l",
    "a0_003_ma__mantisblade_nails_l",
    "a0_006_wa__launcher_nails_l",
    "a0_006_ma__launcher_nails_l"
}

local right_nails = {
    "a0_000_pwa_base_nails_r",
    "a0_000_pwa_base__nails_r",
    "a0_000_pwa_fpp__nails_r",
    "a0_000_pma_base__nails_r",
    "a0_003_wa__mantisblade_nails_r",
    "a0_003_ma__mantisblade_nails_r",
    "a0_006_wa__launcher_nails_r",
    "a0_006_ma__launcher_nails_r",
}

local personal_link = {
    "a0_001__personal_link_tpp4537",
    "a0_001__personal_link_default_holstered",
}

local function generate_file_name(playthrough_id)
    return playthrough_id .. ".json"
end

function ft:dump_current_json()
    local playthrough_id = KiasuBurger_Replacer_ReplacerSystem.GetId()

    if playthrough_id == "" then
        log("불러온 세이브가 없어 JSON을 덤프할 수 없습니다")
        return
    end

    local file_name = generate_file_name(playthrough_id)

    log("덤프 중: " .. file_name)
    local storage = KiasuBurger_Replacer_ReplacerService.GetStorage()
    if not IsDefined(storage) then
        log("저장소 접근이 거부되었습니다")
        return
    end

    local file = storage:GetFile(file_name)
    if not IsDefined(file) then
        log("JSON 파일을 불러올 수 없습니다")
        return
    end

    local text = file:ReadAsText()
    print(text)
end

function ft:save_current_loadout()
    local storage = KiasuBurger_Replacer_ReplacerService.GetStorage()
    if not IsDefined(storage) then
        log("저장소 접근이 거부되었습니다")
        return
    end

    local puppet = GetPlayer()
    local gender = NameToString(puppet:GetResolvedGenderName())
    local wrong_gender_condition = "";
    local playthrough_id = KiasuBurger_Replacer_ReplacerSystem.GetId()

    if playthrough_id == "" then
        log("불러온 세이브가 없어 JSON을 저장할 수 없습니다")
        return
    end

    local file_name = generate_file_name(playthrough_id)
    local file = storage:GetFile(file_name)
    if not IsDefined(file) then
        log("JSON 파일을 쓰기용으로 열 수 없습니다")
        return
    end

    if gender == "Female" then
        wrong_gender_condition = "gender=m"
    else
        wrong_gender_condition = "gender=w"
    end

    local attachment_slots = {}
    local record = puppet:GetRecord()
    for _, slot in ipairs(record:AttachmentSlots()) do
        local id = slot:GetID()
        table.insert(attachment_slots, id)
    end

    local transactionSystem = Game.GetTransactionSystem()
    local found_tags = Set()
    for _, slot in ipairs(attachment_slots) do
        local item = transactionSystem:GetItemInSlot(puppet, slot)
        if IsDefined(item) then
            local tags = transactionSystem:GetVisualTags(item, false)
            for _, tag in ipairs(tags) do
                found_tags.insert(NameToString(tag))
            end
        end
    end

    local resourceDepot = Game.GetResourceDepot()

    local components = puppet:GetComponents()
    local hide_weapon_grip = false
    local hide_body_mask = 0
    local hide_legs_mask = 0

    local json = JsonObject.new()
    local jsonComponents = JsonArray.new()
    json:SetKey("components", jsonComponents)

    local componentsToProcess = {}
    local processedComponents = {}

    local function finish_save()
        local hasInorganicMaterials = false
        -- If the Inorganic Materials mod is installed, save the current inorganic materials to the JSON file.
        if KiasuBurger_InorganicMaterials_InorganicMaterials then
            local inorganicMaterials = KiasuBurger_InorganicMaterials_InorganicMaterials.GetCurrentInorganicMaterials()
            for _, material in ipairs(inorganicMaterials) do
                if NameToString(material) ~= "None" then
                    hasInorganicMaterials = true
                end
            end
            json:SetKeyString("left_arm_material", NameToString(inorganicMaterials[1]))
            json:SetKeyString("right_arm_material", NameToString(inorganicMaterials[2]))
            json:SetKeyString("left_forearm_material", NameToString(inorganicMaterials[3]))
            json:SetKeyString("right_forearm_material", NameToString(inorganicMaterials[4]))
            json:SetKeyString("legs_material", NameToString(inorganicMaterials[5]))
        end

        if jsonComponents:GetSize() > 0 then
            -- Hide flags are only saved alongside components.
            json:SetKeyBool("hide_left_arm", found_tags.has("hide_arm_left"))
            json:SetKeyBool("hide_right_arm", found_tags.has("hide_arm_right"))
            json:SetKeyBool("hide_left_nails", found_tags.has("hide_nails_left") or
                                 found_tags.has("hide_nails_keep_link_left"))
            json:SetKeyBool("hide_right_nails", found_tags.has("hide_nails_right"))
            json:SetKeyBool("hide_personal_link", found_tags.has("hide_nails_left"))
            json:SetKeyBool("hide_weapon_grip", hide_weapon_grip)

            json:SetKeyUint64("hide_body_mask", hide_body_mask)
            json:SetKeyUint64("hide_legs_mask", hide_legs_mask)
        end

        if jsonComponents:GetSize() > 0 or hasInorganicMaterials then
            local status = file:WriteJson(json, "  ")
            KiasuBurger_Replacer_ReplacerSystem.SetJson(json)
            log("저장 중: " .. file_name .. ": " .. tostring(status))
        else
            log("저장할 내용이 없어 저장하지 않습니다")
        end
    end

    local listener = NewProxy({
        OnResourceReady = {
            args= {"handle:ResourceToken"},
            callback = function(token)
                local hash = tostring(token:GetHash())
                log("구성 요소 확인됨: " .. ResRef.ToString(token:GetPath()))

                local loadedComponent
                for i, tuple in ipairs(componentsToProcess) do
                    if hash == tuple["hash"] then
                        loadedComponent = tuple["component"]
                        table.remove(componentsToProcess, i)
                        break
                    end
                end
                if not loadedComponent then
                    log("구성 요소 없는 리소스 토큰을 받았습니다")
                    return
                end

                processedComponents[token] = loadedComponent

                local remaining = 0
                for _, _ in ipairs(componentsToProcess) do
                    remaining = remaining + 1
                end

                if remaining > 0 then
                    return
                end
                log("모든 구성 요소 확인 완료")

                for token, component in pairs(processedComponents) do
                    local name = NameToString(component:GetName())
                    local meshAppearance = NameToString(component.meshAppearance)
                    local renderingPlaneAnimationParam = ""
                    if component.renderingPlaneAnimationParam ~= nil then
                        renderingPlaneAnimationParam = NameToString(component.renderingPlaneAnimationParam)
                    end
                    local resource = token:GetResource()
                    if resource == nil then
                        log("예상치 못한 nil 리소스 발견: " .. ResRef.ToString(component.mesh))
                        log("저장하지 않습니다.")
                        return
                    end
                    local mesh = ResRef.ToString(resource.path)
                    if mesh ~= "" then
                        local jsonComponent = JsonObject.new()
                        jsonComponent:SetKeyString("name", name)
                        jsonComponent:SetKeyString("mesh", mesh)
                        jsonComponent:SetKeyString("meshAppearance", meshAppearance)
                        jsonComponent:SetKeyUint64("chunkMask", component.chunkMask)
                        jsonComponent:SetKeyString("renderingPlaneAnimationParam", renderingPlaneAnimationParam)
                        jsonComponents:AddItem(jsonComponent)
                    end
                end

                finish_save()
            end
        }
    })

    local num_components = 0
    for _, component in ipairs(components) do
        local name = NameToString(component:GetName())
        local chunkMask = component.chunkMask

        -- Due to lack of `continue` we have to do this in a verbose way.
        local process_component =
            string.match(name, "^a0_kiasu_burger") or
            string.match(name, "^l0_kiasu_burger") or
            string.match(name, "^t0_kiasu_burger") or
            name == "hide_weapon_grip"
        if process_component then
            if name == "hide_weapon_grip" then
                hide_weapon_grip = true
                process_component = false
            elseif name == "a0_kiasu_burger_replacer" then
                process_component = false
            elseif string.match(name, "^t0_kiasu_burger_valentino") then
                hide_body_mask = bit32.bor(hide_body_mask, 0x30)
                hide_legs_mask = bit32.bor(hide_legs_mask, 0x01)
            elseif string.match(name, "^l0_kiasu_burger_kitsch") then
                hide_body_mask = bit32.bor(hide_body_mask, 0xE0)
                hide_legs_mask = bit32.bor(hide_legs_mask, 0x07)
            elseif string.match(name, "^l0_kiasu_burger_legs") then
                -- This indicates inorganic materials are being used for the
                -- MascV legs, so we always want to hide the main body's legs.
                hide_body_mask = bit32.bor(hide_body_mask, 0xE0)
            elseif string.match(name, wrong_gender_condition) then
                process_component = false
            elseif chunkMask == 0 then
                process_component = false
            end
        end

        if process_component then
            local mesh = ResRef.ToString(component.mesh)
            if mesh ~= "" then
                local token = resourceDepot:LoadResource(component.mesh)
                local hash = tostring(token:GetHash())
                table.insert(componentsToProcess, {hash = hash, component = component})
                token:RegisterCallback(listener:Target(), listener:Function("OnResourceReady"))
                num_components = num_components + 1
            end
        end
    end

    if num_components == 0 then
        finish_save()
    end
end

function ft:delete_saved_loadout()
    local storage = KiasuBurger_Replacer_ReplacerService.GetStorage()
    if not IsDefined(storage) then
        log("저장소 접근이 거부되었습니다")
        return
    end

    local playthrough_id = KiasuBurger_Replacer_ReplacerSystem.GetId()
    if playthrough_id == "" then
        log("불러온 세이브가 없어 JSON을 삭제할 수 없습니다")
        return
    end

    local file_name = generate_file_name(playthrough_id)
    local status = storage:DeleteFile(file_name)
    KiasuBurger_Replacer_ReplacerSystem.SetJson(nil)
    log("삭제 중: " .. file_name .. ": " .. tostring(status))
end

function ft:new()
    registerForEvent("onInit", function()
        ft.uiVisible = false
    end)

    registerForEvent("onDraw", function()
        if ft.uiVisible then
            if (ImGui.Begin("키아수 버거 리플레이서", ImGuiWindowFlags.AlwaysAutoResize)) then
                if ImGui.Button("현재 로드아웃 저장", ImGui.GetContentRegionAvail(), 0) then
                    self:save_current_loadout()
                end
                if ImGui.Button("저장된 로드아웃 삭제", ImGui.GetContentRegionAvail(), 0) then
                    self:delete_saved_loadout()
                end
                if ImGui.Button("저장된 로드아웃을 콘솔에 출력", ImGui.GetContentRegionAvail(), 0) then
                    self:dump_current_json()
                end
              end
            ImGui.End()
        end
    end)

    registerForEvent("onOverlayOpen", function()
        ft.uiVisible = true
    end)

    registerForEvent("onOverlayClose", function()
        ft.uiVisible = false
    end)

    return ft
end

return ft:new()
