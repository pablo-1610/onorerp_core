--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local prefix = "^1ZONE"
SZonesManager = {}
SZonesManager.list = {}

SZonesManager.createPublic = function(location, type, color, onInteract, helpText, drawDist, itrDist)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, false)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    TriggerClientEvent("onore_zones:newMarker", -1, marker)
    return zone.zoneID
end

SZonesManager.createPrivate = function(location, type, color, onInteract, helpText, drawDist, itrDist, baseAllowed)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, true, baseAllowed)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if zone:isAllowed(v) then
            TriggerClientEvent("onore_zones:newMarker", v, marker)
        end
    end
    return zone.zoneID
end

SZonesManager.addAllowed = function(zoneID, playerId)
    if not SZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = SZonesManager.list[zoneID]
    if zone:isAllowed(playerId) then
        print(Onore.prefix(prefix,("Tentative d'ajouter l'ID %i à la zone %i alors qu'il est déjà autorisé"):format(playerId,zoneID)))
        return
    end
    zone:addAllowed(playerId)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    TriggerClientEvent("onore_zones:newMarker", playerId, marker)
    SZonesManager.list[zoneID] = zone
end

SZonesManager.removeAllowed = function(zoneID, playerId)
    if not SZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = SZonesManager.list[zoneID]
    if not zone:isAllowed(playerId) then
        print(Onore.prefix(prefix,("Tentative de supprimer l'ID %i à la zone %i alors qu'il n'est déjà pas autorisé"):format(playerId,zoneID)))
        return
    end
    zone:removeAllowed(playerId)
    TriggerClientEvent("onore_zones:delMarker", playerId, zoneID)
    SZonesManager.list[zoneID] = zone
end

SZonesManager.updatePrivacy = function(zoneID, newPrivacy)
    if not SZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = SZonesManager.list[zoneID]
    local wereAllowed = {}
    local wasRestricted = zone:isRestricted()
    if zone:isRestricted() then
        wereAllowed = zone.allowed
    end
    zone.allowed = {}
    zone:setRestriction(newPrivacy)
    if zone:isRestricted() then
        local players = ESX.GetPlayers()
        if not wasRestricted then
            for _, playerId in pairs(players) do
                local isAllowedtoSee = false
                for _, allowed in pairs(wereAllowed) do
                    if allowed == playerId then
                        isAllowedtoSee = true
                    end
                end
                if not isAllowedtoSee then
                    TriggerClientEvent("onore_zones:delMarker", playerId, zone.zoneID)
                end
            end
        end
    else
        if wasRestricted then
            for _, playerId in pairs(players) do
                local isAllowedtoSee = false
                for _, allowed in pairs(wereAllowed) do
                    if allowed == playerId then
                        isAllowedtoSee = true
                    end
                end
                if isAllowedtoSee then
                    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
                    TriggerClientEvent("onore_zones:newMarker", playerId, marker)
                end
            end
        end
    end
    SZonesManager.list[zoneID] = zone
end

SZonesManager.delete = function(zoneID)
    if not SZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = SZonesManager.list[zoneID]
    if zone:isRestricted() then
        local players = ESX.GetPlayers()
        for k, playerId in pairs(players) do
            if zone:isAllowed(playerId) then
                TriggerClientEvent("onore_zones:delMarker", playerId, zoneID)
            end
        end
    else
        TriggerClientEvent("onore_zones:delMarker", -1, zoneID)
    end
end

SZonesManager.updateOne = function(source)
    local markers = {}
    ---@param zone Zone
    for zoneID, zone in pairs(SZonesManager.list) do
        if zone:isRestricted() then
            if zone:isAllowed(source) then
                markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
            end
        else
            markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
        end
    end
    TriggerClientEvent("onore_zones:cbZones", source, markers)
end

RegisterNetEvent("onore_zones:requestPredefinedZones")
AddEventHandler("onore_zones:requestPredefinedZones", function()
    local source = source
    SZonesManager.updateOne(source)
end)

RegisterNetEvent("onore_zones:interact")
AddEventHandler("onore_zones:interact", function(zoneID)
    local source = source
    if not SZonesManager.list[zoneID] then
        DropPlayer("[Onore] Tentative d'intéragir avec une zone inéxistante.")
        return
    end
    ---@type Zone
    local zone = SZonesManager.list[zoneID]
    zone:interact(source)
end)

Citizen.CreateThread(function()
    while true do
        Wait(8000)
        local restrictedZones = 0
        ---@param zone Zone
        for _,zone in pairs(SZonesManager.list) do
            if zone:isRestricted() then
                restrictedZones = restrictedZones + 1
            end
        end
        print(Onore.prefix(prefix, ("Il y a %i zones actives (dont %i restricted)"):format(#SZonesManager.list, restrictedZones)))
    end
end)