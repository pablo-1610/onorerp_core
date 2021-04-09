--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreMenuUtils = {}

OnoreMenuUtils.inputBox = function(TextEntry, ExampleText, MaxStringLenght, isValueInt)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        if isValueInt then
            local isNumber = tonumber(result)
            if isNumber then return result else return nil end
        end

        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

OnoreMenuUtils.okIfDef = function(value, isMale)
    local e = ""
    if not isMale then e = "e" end
    if not value or value == "" then return "" else return ("~s~: ~g~Défini%s"):format(e) end
end

OnoreMenuUtils.valueNotDefault = function(value, add)
    if not value or value == "" then return "" else return "~s~: ~g~"..tostring(value)..(add or "") end
end