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
    return blip.blipId
end

OnoreSBlipsManager.createPrivate = function(position, sprite, color, scale, text, shortRange, baseAllowed)
    local blip = Blip(position, sprite, color, scale, text, shortRange, true, baseAllowed)
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if blip:isAllowed(v) then
            TriggerClientEvent("onore_blips:newBlip", v, blip)
        end
    end
    return blip.blipId
end

OnoreSBlipsManager.addAllowed = function(blipID, playerId)
    if not OnoreSBlipsManager.list[blipID] then
        return
    end
    ---@type Blip
    local blip = OnoreSBlipsManager.list[blipID]
    if blip:isAllowed(playerId) then
        print(Onore.prefix(OnorePrefixes.blips,("Tentative d'ajouter l'ID %s au blip %s alors qu'il est déjà autorisé"):format(playerId,blipID)))
        return
    end
    blip:addAllowed(playerId)
    TriggerClientEvent("onore_blips:newBlip", playerId, blip)
    OnoreSBlipsManager.list[blipID] = blip
end

OnoreSBlipsManager.removeAllowed = function(blipID, playerId)
    if not OnoreSBlipsManager.list[blipID] then
        return
    end
    ---@type Blip
    local blip = OnoreSBlipsManager.list[blipID]
    if not blip:isAllowed(playerId) then
        print(Onore.prefix(OnorePrefixes.blips,("Tentative de supprimer l'ID %s au blip %s alors qu'il n'est déjà pas autorisé"):format(playerId,blipID)))
        return
    end
    blip:removeAllowed(playerId)
    TriggerClientEvent("onore_blips:delBlip", playerId, blipID)
    OnoreSBlipsManager.list[blipID] = blip
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