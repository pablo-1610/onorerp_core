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
House = {}
House.__index = House

setmetatable(House, {
    __call = function(_, houseId, ownerLicense, info)
        local self = setmetatable({}, House)
        self.houseId = houseId
        self.ownerLicense = ownerLicense
        self.instance = HousesManager.instanceRange + houseId
        self.players = {}
        self.info = info
        -- Zones
        SetRoutingBucketPopulationEnabled(instance, false)
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
    SetPlayerRoutingBucket(source, self.instance)
end

---exit
---@public
---@return void
function House:exit(source)
    SetPlayerRoutingBucket(source, 0)
end

---initMarker
---@public
---@return void
function House:initMarker()
    SZonesManager.createPublic(vector3(self.info.entry.x, self.info.entry.y, self.info.entry.z), 22, {r = 52, g = 235, b = 201, a = 255}, function(source)
        TriggerEvent("onore_realestateagent:openPropertyMenu", source, self.houseId)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec la propriétée", 10.0, 1.0)
end
