--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

tpAnim = false
local cat, desc = "realestateagentlaundry", "~g~Interaction avec le dressing"
local sub = function(str)
    return cat .. "_" .. str
end

RegisterNetEvent("onore_realestateagent:openLaundryPropertyMenu")
AddEventHandler("onore_realestateagent:openLaundryPropertyMenu", function(dress)
    if menuIsOpened or tpAnim then
        return
    end
    FreezeEntityPosition(PlayerPedId(), true)
    menuIsOpened = true
    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_dynasty8"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end
    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    Citizen.CreateThread(function()
        while menuIsOpened do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end
            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                RageUI.Separator("↓ ~g~Tenues disponibles ~s~↓")
                for _,value in pairs(dress) do
                    RageUI.ButtonWithStyle(("~y~→ ~s~Tenue \"~y~%s~s~\""):format(value.label), nil, {RightLabel = "~g~Changer ~s~→→"}, true, function(_,_,s)
                        if s then
                            TriggerEvent('skinchanger:loadSkin', value.skin)
                        end
                    end)
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
    end)
end)