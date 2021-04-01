--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local blips = {}

RegisterNetEvent("onore_realestateagent:cbAvailableHouses")
AddEventHandler("onore_realestateagent:cbAvailableHouses", function(availableHouses)
    for _, blip in pairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    for houseID, coordinates in pairs(availableHouses) do
        local blip = AddBlipForCoord(coordinates.x, coordinates.y, coordinates.z)
        SetBlipSprite(blip, 374)
        SetBlipColour(blip, 69)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Maison à vendre")
        EndTextCommandSetBlipName(blip)
        blips[houseID] = blip
    end
end)

RegisterNetEvent("onore_realestateagent:addAvailableHouse")
AddEventHandler("onore_realestateagent:addAvailableHouse", function(availableHouse)
    if blips[availableHouse.id] then
        return
    end
    local blip = AddBlipForCoord(availableHouse.coords.x, availableHouse.coords.y, availableHouse.coords.z)
    SetBlipSprite(blip, 374)
    SetBlipColour(blip, 69)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Maison à vendre")
    EndTextCommandSetBlipName(blip)
    blips[availableHouse.id] = blip
end)

RegisterNetEvent("onore_realestateagent:houseNoLongerAvailable")
AddEventHandler("onore_realestateagent:houseNoLongerAvailable", function(houseID)
    if not blips[houseID] or not DoesBlipExist(blips[houseID]) then
        return
    end
    RemoveBlip(blips[houseID])
    blips[houseID] = nil
end)

AddEventHandler("onore_esxloaded", function()
    TriggerServerEvent("onore_realestateagent:requestAvailableHouses")
end)