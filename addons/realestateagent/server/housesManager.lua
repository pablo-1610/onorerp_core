--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local prefix = "^3HOUSES"
HousesManager = {}

HousesManager.instanceRange = 1000
HousesManager.list = {}

local function addHouse(info, needDecode)
    local house
    if needDecode then
        house = House(info.id, info.owner, json.decode(info.infos))
    else
        house = House(info.id, info.owner, info.infos)
    end
    house:initMarker()
    HousesManager.list[house.houseId] = house
end

local function loadHouses()
    MySQL.Async.fetchAll("SELECT * FROM onore_houses", {}, function(houses)
        local tot = 0
        for id, info in pairs(houses) do
            tot = tot + 1
            addHouse(info, true)
        end
        print(Onore.prefix(prefix,("%i maisons importées depuis la db"):format(tot)))
    end)
end

local function createHouse(data, author)
    MySQL.Async.insert("INSERT INTO onore_houses (owner, infos, createdAt) VALUES(@a, @b, @c)", {
        ['a'] = "none",
        ['b'] = json.encode(data),
        ['c'] = os.time()
    }, function(insertId)
        addHouse({id = insertId, owner = "none", infos = data}, false)
        TriggerClientEvent("onore_realestateagent:addAvailableHouse", -1, {id = insertId, coords = data.entry})
        TriggerClientEvent("esx:showNotification", author, "~g~Création de la propriétée effectuée !")
    end)
end

AddEventHandler("onore_esxloaded", function()
    loadHouses()
end)

AddEventHandler("onore_realestateagent:openPropertyMenu", function(source, propertyID)
    -- TODO -> (AntiCheat) Check la distance
    ---@type House
    local house = HousesManager.list[propertyID]
    print(house.ownerLicense)
    TriggerClientEvent("onore_realestateagent:openClientPropertyMenu", source, house.ownerLicense, {house.info.selectedInterior, house.info.price})
end)

RegisterNetEvent("onore_realestateagent:saveProperty")
AddEventHandler("onore_realestateagent:saveProperty", function(info)
    -- TODO -> (AntiCheat) Check le job de la source
    local source = source
    createHouse(info, source)
end)

RegisterNetEvent("onore_realestateagent:requestAvailableHouses")
AddEventHandler("onore_realestateagent:requestAvailableHouses", function()
    local source = source
    local available = {}
    ---@param house House
    for houseID, house in pairs(HousesManager.list) do
        if house.ownerLicense == "none" then
            available[houseID] = house.info.entry
        end
    end
    TriggerClientEvent("onore_realestateagent:cbAvailableHouses", source, available)
end)