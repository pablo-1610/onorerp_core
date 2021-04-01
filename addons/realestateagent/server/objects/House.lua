--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class House
---@field public houseId number
---@field public ownerLicense string
---@field public info table
---@field public exitMarker number
---@field public managerMarker number
---@field public laundryMarker number
---@field public ownerInfo string
---@field public inventory table
---@field public allowedPlayers table
House = {}
House.__index = House

setmetatable(House, {
    __call = function(_, houseId, ownerLicense, info, ownerInfo, inventory)
        local self = setmetatable({}, House)
        self.houseId = houseId
        self.ownerLicense = ownerLicense
        self.instance = HousesManager.instanceRange + houseId
        self.players = {}
        self.info = info
        self.ownerInfo = ownerInfo
        self.inventory = inventory
        self.allowedPlayers = {}
        -- Zones
        SetRoutingBucketPopulationEnabled(self.instance, false)
        return self
    end
})

---getInstance
---@public
---@return number
function House:getInstance()
    return self.instance or -1
end

---getPlayers
---@public
---@return table
function House:getPlayers()
    return self.players
end

---isOwner
---@public
---@return boolean
function House:isOwner(source)
    local license = OnoreServerUtils.getLicense(source)
    return license == self.ownerLicense
end

---getPlayersCount
---@public
---@return number
function House:getPlayersCount()
    return #self.players
end

---enter
---@public
---@return void
function House:enter(source)
    print(Onore.prefix(OnorePrefixes.house, ("Le joueur ^2%s ^7est entrée dans la maison ^3%s ^7(^3%s^7)"):format(GetPlayerName(source),self.houseId,self.info.name)))
    SZonesManager.addAllowed(self.exitMarker, source)
    SZonesManager.addAllowed(self.laundryMarker, source)
    if self:isOwner(source) then
        SZonesManager.addAllowed(self.managerMarker, source)
    end
    SetPlayerRoutingBucket(source, self.instance)
    local interiorInfos = OnoreInteriors[self.info.selectedInterior]
    TriggerClientEvent("onore_realestateagent:enterHouse", source, interiorInfos.interiorEntry)
end

---exit
---@public
---@return void
function House:exit(source)
    print(Onore.prefix(OnorePrefixes.house, ("Le joueur ^2%s ^7est sorti(e) de la maison ^3%s ^7(^3%s^7)"):format(GetPlayerName(source),self.houseId,self.info.name)))
    SZonesManager.removeAllowed(self.exitMarker, source)
    SZonesManager.removeAllowed(self.laundryMarker, source)
    if self:isOwner(source) then
        SZonesManager.removeAllowed(self.managerMarker, source)
    end
    SetPlayerRoutingBucket(source, 0)
    TriggerClientEvent("onore_realestateagent:exitHouse", source, self.info.entry)
end

---openManger
---@public
---@return void
function House:openManger(source)
    -- TODO -> Ouvrir le manager
    local license = OnoreServerUtils.getLicense(source)
    if self:isOwner(source) then
        local allPlayers = {}
        local players = ESX.GetPlayers()
        for _,id in pairs(players) do
            allPlayers[id] = {license = OnoreServerUtils.getLicense(id), name = GetPlayerName(id)}
        end
        TriggerClientEvent("onore_realestateagent:openManagerPropertyMenu", source, allPlayers, self.allowedPlayers, license)
    end
end

---openLaundry
---@public
---@return void
function House:openLaundry(source)
    -- TODO -> Ouvrir le laundry
    local license = OnoreServerUtils.getLicense(source)
    MySQL.Async.fetchAll("SELECT identifier FROM users WHERE license = @a", {['a'] = license}, function(result)
        if result[1] then
            local steam = result[1].identifier
            MySQL.Async.fetchAll("SELECT * FROM datastore_data WHERE owner = @a AND name = @b", {
                ['a'] = steam,
                ['b'] = "property"
            }, function(result2)
                if result2[1] then
                    TriggerClientEvent("onore_realestateagent:openLaundryPropertyMenu", source, json.decode(result2[1].data))
                else
                    TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez aucune tenue sauvegardée")
                end
            end)
        else
            TriggerClientEvent("esx:showNotification", source, "~r~Une erreur est survenue...")
        end
    end)
end

---initMarker
---@public
---@return void
function House:initMarker()
    SZonesManager.createPublic(vector3(self.info.entry.x, self.info.entry.y, self.info.entry.z), 22, {r = 52, g = 235, b = 201, a = 255}, function(source)
        TriggerEvent("onore_realestateagent:openPropertyMenu", source, self.houseId)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec la propriétée", 10.0, 1.0)

    local interiorInfos = OnoreInteriors[self.info.selectedInterior]
    self.exitMarker = SZonesManager.createPrivate(vector3(interiorInfos.interiorExit.x, interiorInfos.interiorExit.y, interiorInfos.interiorExit.z), 22, {r = 255, g = 0, b = 0, a = 255}, function(source)
        self:exit(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour sortir de la propriétée", 50.0, 1.0)

    self.managerMarker = SZonesManager.createPrivate(vector3(interiorInfos.managerLocation.x, interiorInfos.managerLocation.y, interiorInfos.managerLocation.z), 22, {r = 62, g = 154, b = 194, a = 255}, function(source)
        self:openManger(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le gestionnaire de propriétée", 20.0, 1.0)

    self.laundryMarker = SZonesManager.createPrivate(vector3(interiorInfos.laundryLocation.x, interiorInfos.laundryLocation.y, interiorInfos.laundryLocation.z), 22, {r = 174, g = 62, b = 194, a = 255}, function(source)
        self:openLaundry(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le dressing", 20.0, 1.0)
end
