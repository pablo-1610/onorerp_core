---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Onore RolePlay.
  
  File [main] created at [11/05/2021 15:20]

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local avaiblablePeds = {
    "a_m_m_hillbilly_01"
}

local roleUpdated = nil
local cat, desc = "vipMenu", "~g~Menu VIP"
local sub = function(str)
    return cat .. "_" .. str
end

Onore.netRegisterAndHandle("cbIsVip", function(vipLevel)
    roleUpdated = vipLevel or 0
end)

local function openVipMenu()
    if menuIsOpened then
        return
    end
    roleUpdated = nil
    OnoreClientUtils.toServer("requestIsVip")
    menuIsOpened = true
    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_freetradeshipping"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("sub"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "root_cause", "shopui_title_freetradeshipping"))
    RMenu:Get(cat, sub("sub")).Closed = function()end

    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    Onore.newThread(function()
        while menuIsOpened do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end

            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                if not roleUpdated then
                    RageUI.Separator("") RageUI.Separator(("%sConnexion au serveur..."):format(OnoreGameUtils.dangerVariator)) RageUI.Separator("")
                else
                    if roleUpdated == 0 then
                        RageUI.Separator("") RageUI.Separator(("%sVous n'êtes pas VIP !"):format(OnoreGameUtils.warnVariator)) RageUI.Separator("")
                    elseif roleUpdated == 1 then
                        RageUI.Separator("↓ ~g~Vos avantages ~s~↓")
                        RageUI.ButtonWithStyle("Définir un numéro personalisé", nil, {}, true, function(_,_,s)
                            if s then
                                local num = OnoreGameUtils.input("Numéro", "", 10, true)
                                if num ~= nil and num ~= "" then
                                    OnoreClientUtils.toServer("vipRequestNumChange", num)
                                    ESX.ShowNotification("[~o~VIP~s~] ~o~Application de vos modifications en cours...")
                                    shouldStayOpened = false
                                else
                                    ESX.ShowNotification("[~o~VIP~s~] ~r~Numéro renseigné invalide")
                                end
                            end
                        end)
                        RageUI.ButtonWithStyle("Prendre une apparence PED", nil, {RightLabel = "→→"}, true, nil, RMenu:Get(cat, sub("sub")))
                    end
                end
            end, function()
            end)

            RageUI.IsVisible(RMenu:Get(cat, sub("sub")), true, true, true, function()
                tick()
                RageUI.ButtonWithStyle("Apparence par défaut", nil, {}, true, function(_,_,s)
                    if s then

                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                            local isMale = skin.sex == 0

                            TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadSkin', skin)
                                    TriggerEvent('esx:restoreLoadout')
                                end)
                            end)

                        end)
                    end
                end)
                RageUI.Separator("↓ ~g~Apparences disponibles ~s~↓")
                for k,v in pairs(avaiblablePeds) do
                    RageUI.ButtonWithStyle(("Ped \"~y~%s~s~\""):format(v), nil, {RightLabel = "~b~Changer ~s~→→"}, true, function(_,_,s)
                        if s then
                            local model = GetHashKey(v)
                            RequestModel(model)
                            while not HasModelLoaded(model) do Wait(1) end
                            SetPlayerModel(PlayerId(), model)
                            TriggerEvent('esx:restoreLoadout')
                            ESX.ShowNotification("[~o~VIP~s~] ~g~Apparence changée !")
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
        RMenu:Delete(cat, sub("sub"))
    end)
end

Onore.netHandle("esxloaded", function()
    Onore.newThread(function()
        while true do
            if IsControlJustPressed(0, 57) then
                openVipMenu()
            end
            Wait(1)
        end
    end)
end)