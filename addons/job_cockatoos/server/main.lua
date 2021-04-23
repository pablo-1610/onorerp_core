---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Onore RolePlay.
  
  File [main] created at [18/04/2021 16:41]

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreSCache.addCacheRule("cockatoosfood", "onore_cockatoosfood", Onore.second(10))

Onore.netRegisterAndHandle("cockatoosRequestItem", function(item)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name ~= "cockatoos" then
        return
    end
    local itemsCache = OnoreSCache.getCache("cockatoosfood")
    if not itemsCache[item] then return end
    xPlayer.addInventoryItem(itemsCache[item].item, 1)
    OnoreServerUtils.toClient("cockatoosCbItem", source)
end)