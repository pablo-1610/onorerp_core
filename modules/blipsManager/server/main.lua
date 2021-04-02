--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreSBlipsManager = {}
OnoreSBlipsManager.list = {}

OnoreSBlipsManager.createPublic = function(position, sprite, color, scale, text, shortRange)
    local blip = Blip(position, sprite, color, scale, text, shortRange, false)
    TriggerClientEvent("onore_blips:newBlip", -1, blip)
    return zone.zoneID
end

OnoreSBlipsManager.updateOne = function(source)
    local blips = {}
    ---@param blip Blip
    for blipID, blip in pairs(OnoreSBlipsManager.list) do
        if blip:isRestricted() then
            if blip:isAllowed(source) then
                blips[blipID] = blip
            end
        else
            blips[blipID] = blip
        end
    end
    TriggerClientEvent("onore_blips:cbBlips", source, blips)
end

RegisterNetEvent("onore_blips:requestPredefinedBlips")
AddEventHandler("onore_blips:requestPredefinedBlips", function()
    local source = source
    OnoreSBlipsManager.updateOne(source)
end)