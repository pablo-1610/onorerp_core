---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Onore RolePlay.
  
  File [main] created at [11/05/2021 15:19]

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterCommand("vip", function(source, args)
    if source ~= 0 then return end
    local targetId = tonumber(args[1])
    if not targetId then
        OnoreServerUtils.trace("Erreur de syntaxe: /vip <id>", OnorePrefixes.dev)
        return
    end
    local xPlayer = ESX.GetPlayerFromId(targetId)
    MySQL.Async.execute("UPDATE users SET vip = 1 WHERE identifier = @a", {['a'] = xPlayer.identifier}, function(update)
        OnoreServerUtils.trace("La personne est désormais VIP !", OnorePrefixes.dev)
    end)
end)

Onore.netRegisterAndHandle("requestIsVip", function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    MySQL.Async.fetchAll("SELECT vip FROM users WHERE identifier = @a", {
        ['a'] = xPlayer.identifier
    }, function(result)
        OnoreServerUtils.toClient("cbIsVip", _src, result[1].vip)
    end)
end)

Onore.netRegisterAndHandle("vipRequestNumChange", function(num)
    -- @TODO -> Ajouter de la sécu
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    print("Yeey")
    MySQL.Async.execute("UPDATE users SET phone_number = @a WHERE identifier = @b", {
        ['a'] = num,
        ['b'] = xPlayer.identifier
    }, function(ok)
        OnoreServerUtils.toClient("notify", _src, "[~o~VIP~s~]", "~g~Modifications appliquées, veuillez vous reconnecter")
    end)
    print("end boucle")
end)