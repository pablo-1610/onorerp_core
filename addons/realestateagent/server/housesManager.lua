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
        print(Onore.prefix(prefix, ("%i maisons importées depuis la db"):format(tot)))
    end)
end

local function createHouse(data, author, street)
    MySQL.Async.insert("INSERT INTO onore_houses (owner, infos, createdAt) VALUES(@a, @b, @c)", {
        ['a'] = "none",
        ['b'] = json.encode(data),
        ['c'] = os.time()
    }, function(insertId)
        addHouse({ id = insertId, owner = "none", infos = data }, false)
        TriggerClientEvent("onore_realestateagent:addAvailableHouse", -1, { id = insertId, coords = data.entry })
        TriggerClientEvent("esx:showNotification", author, "~g~Création de la propriétée effectuée !")
        TriggerClientEvent("onore_utils:advancedNotif", -1, "~y~Agence immobilière", "~b~Nouvelle propriétée", ("Une nouvelle propriétée est disponible à ~p~%s ~s~pour la somme de ~g~%s$"):format(street, ESX.Math.GroupDigits(tonumber(data.price))), "CHAR_MINOTAUR", 1)
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
    TriggerClientEvent("onore_realestateagent:openClientPropertyMenu", source, house.ownerLicense, { house.info.selectedInterior, house.info.price, propertyID })
end)

RegisterNetEvent("onore_realestateagent:saveProperty")
AddEventHandler("onore_realestateagent:saveProperty", function(info, street)
    -- TODO -> (AntiCheat) Check le job de la source
    local source = source
    createHouse(info, source, street)
end)

RegisterNetEvent("onore_realestateagent:buyProperty")
AddEventHandler("onore_realestateagent:buyProperty", function(houseId)
    if not HousesManager.list[houseId] then
        return
    end
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local bank = xPlayer.getAccount("bank").money
    ---@type House
    local house = HousesManager.list[houseId]
    local price = tonumber(house.info.price)
    if bank >= price then
        -- TODO -> change owner
        local license = OnoreServerUtils.getLicense(source)
        MySQL.Async.execute("UPDATE onore_houses SET owner = @a WHERE id = @b", {
            ['a'] = license,
            ['b'] = houseId
        }, function(done)
            HousesManager.list[houseId].ownerLicense = license
            TriggerClientEvent("onore_realestateagent:houseNoLongerAvailable", houseId)
            TriggerClientEvent("onore_utils:advancedNotif", -1, "~y~Agence immobilière", "~b~Achat de propriétée", "~g~Félicitations ~s~! Cette propriétée est désormais la votre ! Profitez-en bien.", "CHAR_MINOTAUR", 1)
        end)
    else
        TriggerClientEvent("onore_utils:advancedNotif", -1, "~y~Agence immobilière", "~b~Achat de propriétée", "Vous n'avez pas assez d'argent en banque pour acheter cette propriétée !", "CHAR_MINOTAUR", 1)
    end
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