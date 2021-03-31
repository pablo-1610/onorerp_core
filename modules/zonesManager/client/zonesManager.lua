--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

CZonesManager = {}
CZonesManager.cooldown = false
CZonesManager.list = {}

AddEventHandler("onore_esxloaded", function()
    TriggerServerEvent("onore_zones:requestPredefinedZones")
    while true do
        local interval = 500
        local pos = GetEntityCoords(PlayerPedId())
        local closeToMarker = false
        for zoneId, zone in pairs(CZonesManager.list) do
            local zoneCoords = zone.position
            local dist = GetDistanceBetweenCoords(pos, zoneCoords, true)
            if dist <= zone.distances[1] then
                closeToMarker = true
                DrawMarker(zone.type, zoneCoords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, zone.color.r, zone.color.g, zone.color.b, zone.color.a, 55555, false, true, 2, false, false, false, false)
                if dist <= zone.distances[2] then
                    AddTextEntry("ZONES", zone.help or "Appuyez sur ~INPUT_CONTEXT~ pour intéragir")
                    DisplayHelpTextThisFrame("ZONES", false)
                    if IsControlJustPressed(0, 51) then
                        if not CZonesManager.cooldown then
                            CZonesManager.cooldown = true
                            TriggerServerEvent("onore_zones:interact", zone.id)
                            Citizen.SetTimeout(450, function()
                                CZonesManager.cooldown = false
                            end)
                        end
                    end
                end
            end
        end
        if closeToMarker then
            interval = 0
        end
        Wait(interval)
    end
end)

RegisterNetEvent("onore_zones:newMarker")
AddEventHandler("onore_zones:newMarker", function(zone)
    CZonesManager.list[zone.id] = zone
end)

RegisterNetEvent("onore_zones:delMarker")
AddEventHandler("onore_zones:delMarker", function(zoneID)
    CZonesManager.list[zone.id] = nil
end)

RegisterNetEvent("onore_zones:cbZones")
AddEventHandler("onore_zones:cbZones", function(zoneInfos)
    CZonesManager.list = zoneInfos
end)