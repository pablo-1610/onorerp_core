---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Onore RolePlay.
  
  File [frigoMenu] created at [18/04/2021 19:17]

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local awaitingServerUpdate = false
local cat, desc = "cockatoosFridge", "~y~Réfrigérateur du Cockatoos"
local sub = function(str)
    return cat .. "_" .. str
end

Onore.netRegisterAndHandle("cockatoosCbItem", function()
    awaitingServerUpdate = false
end)

Onore.netRegisterAndHandle("cockatoosOpenFrigo", function(items)
    if menuIsOpened then
        return
    end

    FreezeEntityPosition(PlayerPedId(), true)
    menuIsOpened = true

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_vanillaunicorn"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    Onore.newThread(function()
        while menuIsOpened do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end

            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                if awaitingServerUpdate then
                    RageUI.Separator(("%sEn attente du serveur"):format(OnoreGameUtils.warnVariator))
                end
                RageUI.Separator("↓ ~y~Produits en stock ~s~↓")
                for k,v in pairs(items) do
                    RageUI.ButtonWithStyle(("Prendre \"~y~%s~s~\""):format(v.label), "Appuyez pour prendre du stock", {RightBadge = RageUI.BadgeStyle.Franklin}, not awaitingServerUpdate, function(_,_,s)
                        if s then
                            awaitingServerUpdate = true
                            OnoreClientUtils.toServer("cockatoosRequestItem", k)
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