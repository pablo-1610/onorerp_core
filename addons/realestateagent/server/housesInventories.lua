--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterNetEvent("onore_realestateagent:deposit")
AddEventHandler("onore_realestateagent:deposit", function(houseId, itemName, depositCount)
    if not OnoreSHousesManager.list[houseId] then
        return
    end
    local source = source
    local license = OnoreServerUtils.getLicense(source)
    ---@type House
    local house = OnoreSHousesManager.list[houseId]
    if not house:isOwner(source) then
        return
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(itemName).count
    if itemCount < depositCount then
        TriggerClientEvent("onore_realestateagent:depositFailed", source, "Erreur: Une erreur est survenue")
        return
    end
    local itemsAddedInHouse = house:addItem(itemName, depositCount, source)
    if not itemsAddedInHouse then
        TriggerClientEvent("onore_realestateagent:depositFailed", source, "Erreur: Capacité maximale dépassée")
        return
    end
    xPlayer.removeInventoryItem(itemName, depositCount)
    itemCount = xPlayer.getInventoryItem(itemName)
    TriggerClientEvent("onore_realestateagent:depositSucceed", source, itemName, itemCount, depositCount)
end)

RegisterNetEvent("onore_realestateagent:remove")
AddEventHandler("onore_realestateagent:remove", function(houseId, itemName, removalCount)
    if not OnoreSHousesManager.list[houseId] then
        return
    end
    local source = source
    local license = OnoreServerUtils.getLicense(source)
    ---@type House
    local house = OnoreSHousesManager.list[houseId]
    if not house:isOwner(source) then
        TriggerClientEvent("onore_realestateagent:depositFailed", source, "Erreur: Une erreur est survenue")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    if house.inventory[itemName] == nil then
        return
    end
    local avaibleCount = house.inventory[itemName]
    if removalCount > avaibleCount then
        TriggerClientEvent("onore_realestateagent:depositFailed", source, "Erreur: Une erreur est survenue")
        return
    end
    house:removeItem(itemName, removalCount, source)
    xPlayer.addInventoryItem(itemName, removalCount)
    itemCount = xPlayer.getInventoryItem(itemName)
    TriggerClientEvent("onore_realestateagent:removalSucceed", source, itemName, itemCount, removalCount)
end)