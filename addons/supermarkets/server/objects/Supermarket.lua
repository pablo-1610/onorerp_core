--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Supermarket
---@field public id number
---@field public blipId number
---@field public zoneId number
Supermarket = {}
Supermarket.__index = Supermarket

setmetatable(Supermarket, {
    __call = function(_, location, id)
        local self = setmetatable({}, Supermarket)
        self.id = id
        self:init(location)
        return self
    end
})

---initBlip
---@public
---@return void
function Supermarket:init(vector)
    self.blipId = OnoreSBlipsManager.createPublic(vector, 59, 24, 1.0, "LTD 24h/7", true)
    self.zoneId = OnoreSZonesManager.createPublic(vector, 22, {r = 158, g = 245, b = 66, a = 255}, function(source)
        self:openMenu(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu de la superette", 20.0, 1.0)
end

---openMenu
---@public
---@return void
function Supermarket:openMenu(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local moneys = {cash = xPlayer.getMoney(), bank = xPlayer.getAccount("bank").money}
    OnoreServerUtils.toClient("openSupermarketMenu", source, moneys, OnoreSCache.getCache("shopspromo"), OnoreSCache.getCache("shopsitems"))
end

