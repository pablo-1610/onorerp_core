--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreSZonesManager = {}
OnoreSZonesManager.list = {}

OnoreSZonesManager.createPublic = function(location, type, color, onInteract, helpText, drawDist, itrDist)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, false)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    OnoreServerUtils.toAll("newMarker", marker)
    return zone.zoneID
end

OnoreSZonesManager.createPrivate = function(location, type, color, onInteract, helpText, drawDist, itrDist, baseAllowed)
    local zone = Zone(location, type, color, onInteract, helpText, drawDist, itrDist, true, baseAllowed)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if zone:isAllowed(v) then
            OnoreServerUtils.toClient("newMarker", v, marker)
        end
    end
    return zone.zoneID
end

OnoreSZonesManager.addAllowed = function(zoneID, playerId)
    if not OnoreSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = OnoreSZonesManager.list[zoneID]
    if zone:isAllowed(playerId) then
        print(Onore.prefix(OnorePrefixes.zones,("Tentative d'ajouter l'ID %s à la zone %s alors qu'il est déjà autorisé"):format(playerId,zoneID)))
        return
    end
    zone:addAllowed(playerId)
    local marker = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
    OnoreServerUtils.toClient("newMarker", playerId, marker)
    OnoreSZonesManager.list[zoneID] = zone
end

OnoreSZonesManager.removeAllowed = function(zoneID, playerId)
    if not OnoreSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = OnoreSZonesManager.list[zoneID]
    if not zone:isAllowed(playerId) then
        print(Onore.prefix(OnorePrefixes.zones,("Tentative de supprimer l'ID %s à la zone %s alors qu'il n'est déjà pas autorisé"):format(playerId,zoneID)))
        return
    end
    zone:removeAllowed(playerId)
    OnoreServerUtils.toClient("delMarker", playerId, zoneID)
    OnoreSZonesManager.list[zoneID] = zone
end

OnoreSZonesManager.updatePrivacy = function(zoneID, newPrivacy)
    if not OnoreSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = OnoreSZonesManager.list[zoneID]
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
                    OnoreServerUtils.toClient("delMarker", playerId, zone.zoneID)
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
                    OnoreServerUtils.toClient("newMarker", playerId, marker)
                end
            end
        end
    end
    OnoreSZonesManager.list[zoneID] = zone
end

OnoreSZonesManager.delete = function(zoneID)
    if not OnoreSZonesManager.list[zoneID] then
        return
    end
    ---@type Zone
    local zone = OnoreSZonesManager.list[zoneID]
    if zone:isRestricted() then
        local players = ESX.GetPlayers()
        for k, playerId in pairs(players) do
            if zone:isAllowed(playerId) then
                OnoreServerUtils.toClient("delMarker", playerId, zoneID)
            end
        end
    else
        OnoreServerUtils.toAll("delMarker", zoneID)
    end
end

OnoreSZonesManager.updateOne = function(source)
    local markers = {}
    ---@param zone Zone
    for zoneID, zone in pairs(OnoreSZonesManager.list) do
        if zone:isRestricted() then
            if zone:isAllowed(source) then
                markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
            end
        else
            markers[zoneID] = { id = zone.zoneID, type = zone.type, color = zone.color, help = zone.helpText, position = zone.location, distances = { zone.drawDist, zone.itrDist } }
        end
    end
    OnoreServerUtils.toClient("cbZones", source, markers)
end

Onore.netRegisterAndHandle("requestPredefinedZones", function()
    local source = source
    OnoreSZonesManager.updateOne(source)
end)

Onore.netRegisterAndHandle("interactWithZone", function(zoneID)
    local source = source
    if not OnoreSZonesManager.list[zoneID] then
        DropPlayer("[Onore] Tentative d'intéragir avec une zone inéxistante.")
        return
    end
    ---@type Zone
    local zone = OnoreSZonesManager.list[zoneID]
    zone:interact(source)
end)