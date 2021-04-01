--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

tpAnim = false
local cat, desc = "realestateagentmanager", "~g~Interaction avec la propriétée"
local sub = function(str)
    return cat .. "_" .. str
end

RegisterNetEvent("onore_realestateagent:openManagerPropertyMenu")
AddEventHandler("onore_realestateagent:openManagerPropertyMenu", function(onlinePlayers, allowedPlayers, license, houseId)
    if menuIsOpened or tpAnim then
        return
    end
    for k, v in pairs(onlinePlayers) do
        if v.license == license then
            onlinePlayers[k] = nil
        end
    end
    local autorisationTable = {}
    for k,v in pairs(onlinePlayers) do 
        autorisationTable[v.license] = {can = false, id = v}
    end
    for k,v in pairs(allowedPlayers) do
        if autorisationTable[v] ~= nil then
            autorisationTable[v].can = true
        end
    end
    local cVar = "~s~"
    FreezeEntityPosition(PlayerPedId(), true)
    menuIsOpened = true
    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_dynasty8"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end
    RMenu.Add(cat, sub("invite"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "root_cause", "shopui_title_dynasty8"))
    RMenu:Get(cat, sub("invite")).Closed = function()
    end
    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    Citizen.CreateThread(function()
        while menuIsOpened do
            Wait(800)
            if cVar == "~s~" then cVar = "~r~" else cVar = "~s~" end
        end
    end)
    Citizen.CreateThread(function()
        while menuIsOpened do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end
            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Gestion de la propriétée ~s~↓")
                RageUI.ButtonWithStyle("Liste des autorisations", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("invite")))
                RageUI.ButtonWithStyle("Coffre fort", "~y~Cette fonctionalité sera disponible dès le 03/24/2020", { RightLabel = "→→" }, false, function(_, _, s)
                end, RMenu:Get(cat, sub("invite")))
            end, function()
            end)
            RageUI.IsVisible(RMenu:Get(cat, sub("invite")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Gestion des autorisations ~s~↓")
                RageUI.ButtonWithStyle("Appliquer les autorisations", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    if s then
                        ESX.ShowNotification("~o~Application des modifications en cours...")
                        TriggerServerEvent("onore_realestateagent:setAllowed", houseId, autorisationTable)
                        shouldStayOpened = false
                    end
                end)
                RageUI.Separator("↓ ~y~Autorisations ~s~↓")
                if #onlinePlayers <= 0 then
                    RageUI.Separator("")
                    RageUI.Separator(("%sAucun joueur disponible"):format(cVar))
                    RageUI.Separator("")
                else
                    for k, v in pairs(onlinePlayers) do
                        RageUI.Checkbox(("~o~%s ~s~→ ~y~%s"):format(k, v.name), nil, autorisationTable[v.license].can, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                            autorisationTable[v.license].can = Checked
                        end, function()
                        end, function()
                        end)
                    end
                end
            end, function()
            end)
            if not shouldStayOpened and menuIsOpened then
                menuIsOpened = false
            end
            Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("invite"))
    end)
end)