--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

HousesManager = {}

HousesManager.instanceRange = 1000

HousesManager.list = {}

local function addHouse(infos)
    local house = House(infos.id, infos.owner, infos.zonesInfos)
    HousesManager.list[house.houseId] = house
end

local function loadHouses()
    MySQL.Async.fetchAll("SELECT * FROM onore_houses", {}, function(houses)
        local tot = 0
        for id, infos in pairs(houses) do
            tot = tot + 1
            addHouse(infos)
        end
        print(("[^1Onore^7] (^3HOUSES^7) Loaded ^2%i ^7houses !"):format(tot))
    end)
end

MySQL.ready(function()
    loadHouses()
end)

RegisterCommand("updateHouses", function()
    loadHouses()
end)