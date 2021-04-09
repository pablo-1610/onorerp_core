--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreSHousesManager = {}

OnoreSHousesManager.instanceRange = 1000
OnoreSHousesManager.list = {}

local function addHouse(info, needDecode)
    ---@type House
    local house
    if needDecode then
        house = House(info.id, info.owner, json.decode(info.infos), info.ownerInfo, json.decode(info.inventory), info.street)
    else
        house = House(info.id, info.owner, info.infos, info.ownerInfo, info.inventory, info.street)
    end
    house:initMarker()
    house:initBlips()
    OnoreSHousesManager.list[house.houseId] = house
end

local function loadHouses()
    MySQL.Async.fetchAll("SELECT * FROM onore_houses", {}, function(houses)
        local tot = 0
        for id, info in pairs(houses) do
            tot = tot + 1
            addHouse(info, true)
        end
        print(Onore.prefix(OnorePrefixes.house, ("%i maisons importées depuis la db"):format(tot)))
    end)
end

local function createHouse(data, author, street, announce)
    MySQL.Async.insert("INSERT INTO onore_houses (owner, ownerInfo, infos, inventory, createdAt, createdBy, street) VALUES(@a, @b, @c, @d, @e, @f, @g)", {
        ['a'] = "none",
        ['b'] = "none",
        ['c'] = json.encode(data),
        ['d'] = json.encode({}),
        ['e'] = os.time(),
        ['f'] = OnoreServerUtils.getLicense(author),
        ['g'] = street
    }, function(insertId)
        addHouse({ id = insertId, owner = "none", infos = data, ownerInfo = "none", inventory = {}, street }, false)
        OnoreServerUtils.toClient("addAvailableHouse", -1, { id = insertId, coords = data.entry })
        TriggerClientEvent("esx:showNotification", author, "~g~Création de la propriétée effectuée !")
        if announce then OnoreServerUtils.toAll("advancedNotif", "~y~Agence immobilière", "~b~Nouvelle propriétée", ("Une nouvelle propriétée ~s~(~o~%s~s~) est disponible à ~p~%s ~s~pour la somme de ~g~%s$"):format(OnoreInteriors[data.selectedInterior].label, street, ESX.Math.GroupDigits(tonumber(data.price))), "CHAR_MINOTAUR", 1) end
    end)
end

Onore.netHandle("esxloaded", function()
    loadHouses()
end)

Onore.netHandle("openPropertyMenu", function(source, propertyID)
    -- TODO -> (AntiCheat) Check la distance
    ---@type House
    local license = OnoreServerUtils.getLicense(source)
    local isAllowed = false
    local house = OnoreSHousesManager.list[propertyID]
    for _,v in pairs(house.allowedPlayers) do 
        if v == license then
            isAllowed = true
        end
    end
    OnoreServerUtils.toClient("openClientPropertyMenu", source, house.ownerLicense, { house.info.selectedInterior, house.info.price, propertyID, house.ownerInfo }, OnoreServerUtils.getLicense(source), isAllowed, house.public)
end)

Onore.netRegisterAndHandle("saveProperty", function(info, street, announce)
    -- TODO -> (AntiCheat) Check le job de la source
    local source = source
    createHouse(info, source, street, announce)
end)

Onore.netRegisterAndHandle("enterHouse", function(houseId, isGuest, from)
    if not OnoreSHousesManager.list[houseId] then
        return
    end
    local source = source
    local license = OnoreServerUtils.getLicense(source)
    ---@type House
    local house = OnoreSHousesManager.list[houseId]
    -- TODO -> Faire le système de clés (autoriser d'autres joueurs)
    if not house.public then
        if not isGuest then
            if license ~= house.ownerLicense then
                return
            end
        else
            local isAllowed = false
            for _,v in pairs(house.allowedPlayers) do
                if v == license then
                    isAllowed = true
                end
            end 
            if not isAllowed then
                return
            end
        end
    end
    house:enter(source, license ~= house.ownerLicense, from)
end)

Onore.netRegisterAndHandle("buyProperty", function(houseId)
    if not OnoreSHousesManager.list[houseId] then
        return
    end
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local bank = xPlayer.getAccount("bank").money
    ---@type House
    local house = OnoreSHousesManager.list[houseId]
    if house.ownerLicense ~= "none" then
        TriggerClientEvent("esx:showNotification", source, "~r~Cette maison a déjà été achetée !")
        return
    end
    local price = tonumber(house.info.price)
    if bank >= price then
        xPlayer.removeAccountMoney("bank", price)
        local license = OnoreServerUtils.getLicense(source)
        MySQL.Async.fetchAll("SELECT * FROM users WHERE license = @a", {
            ['a'] = license
        }, function(res)
            if res[1] then
                MySQL.Async.execute("UPDATE onore_houses SET owner = @a, ownerInfo = @b WHERE id = @c", {
                    ['a'] = license,
                    ['b'] = res[1].firstname.." "..res[1].lastname,
                    ['c'] = houseId
                }, function(done)
                    OnoreSHousesManager.list[houseId].ownerLicense = license
                    OnoreSHousesManager.list[houseId].ownerInfo = res[1].firstname.." "..res[1].lastname
                    OnoreServerUtils.toClient("addOwnedHouse", source, {id = houseId, coords = house.info.entry})
                    OnoreServerUtils.toClient("advancedNotif", source, "~y~Agence immobilière", "~b~Achat de propriétée", "~g~Félicitations ~s~! Cette propriétée est désormais la votre ! Profitez-en bien.", "CHAR_MINOTAUR", 1)
                    OnoreServerUtils.toAll("houseNoLongerAvailable", houseId)
                end)
            end
        end)

    else
        OnoreServerUtils.toClient("advancedNotif", source, "~y~Agence immobilière", "~b~Achat de propriétée", "Vous n'avez pas assez d'argent en banque pour acheter cette propriétée !", "CHAR_MINOTAUR", 1)
    end
end)

Onore.netRegisterAndHandle("requestAvailableHouses", function()
    local source = source
    local license = OnoreServerUtils.getLicense(source)
    local allowed = {}
    local available = {}
    local owned = {}
    ---@param house House
    for houseID, house in pairs(OnoreSHousesManager.list) do
        if house.ownerLicense == "none" then
            available[houseID] = house.info.entry
        else
            if house.ownerLicense == license then
                owned[houseID] = house.info.entry
            else
                for _,allowedLicense in pairs(house.allowedPlayers) do
                    if license == allowedLicense then
                        allowed[houseID] = {coords = house.info.entry, name = house.ownerInfo}
                    end
                end
            end
        end
    end
    OnoreServerUtils.toClient("cbAvailableHouses", source, available, owned, allowed)
end)

Onore.netRegisterAndHandle("setHouseAlloweds", function(houseId, allowedTable, isPublic)
    if not OnoreSHousesManager.list[houseId] then
        return
    end
    local newHouseAllowedTable = {}
    local source = source
    local license = OnoreServerUtils.getLicense(source)
    ---@type House
    local house = OnoreSHousesManager.list[houseId]
    if not house:isOwner(source) then 
        return
    end
    house.allowedPlayers = {}
    for k,v in pairs(allowedTable) do
        if v.can == true then
            table.insert(newHouseAllowedTable, k)
        end
    end
    house.public = isPublic
    house.allowedPlayers = newHouseAllowedTable
    OnoreSHousesManager.list[houseId] = house
    TriggerClientEvent("esx:showNotification", source, "~g~Modification appliquées")
end)