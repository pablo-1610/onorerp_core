--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class House
---@field public houseId number
---@field public ownerLicense string
---@field public zoneInfos table
House = {}
House.__index = House

setmetatable(House, {
    __call = function(_, houseId, ownerLicense, zoneInfos)
        local self = setmetatable({}, House)
        self.owner = ownerLicense
        self.instance = HousesManager.instanceRange + houseId
        self.players = {}
        -- Zones
        self.enterZone = zoneInfos[1]
        self.exitZone =  zoneInfos[2]
        self.safeZone =  zoneInfos[3]
        self.laundryZone =  zoneInfos[4]
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
