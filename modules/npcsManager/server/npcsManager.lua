--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreSNpcsManager = {}
OnoreSNpcsManager.list = {}

OnoreSNpcsManager.createPublic = function(model, ai, frozen, position, animation, onCreate)
    local npc = Npc(model, ai, frozen, position, animation, false)
    npc:setOnCreate(onCreate or function() end)
    OnoreServerUtils.toAll("newNpc", npc)
    return npc
end

OnoreSNpcsManager.createPrivate = function(model, ai, frozen, position, animation, baseAllowed, onCreate)
    local npc = Npc(model, ai, frozen, position, animation, true, baseAllowed)
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        if npc:isAllowed(v) then
            OnoreServerUtils.toClient("newNpc", v, npc)
        end
    end
    return npc
end

OnoreSNpcsManager.addAllowed = function(npcId, playerId)
    if not OnoreSNpcsManager.list[npcId] then
        return
    end
    ---@type Npc
    local npc = OnoreSNpcsManager.list[npcId]
    if npc:isAllowed(playerId) then
        print(Onore.prefix(OnorePrefixes.npcs,("Tentative d'ajouter l'ID %s au npc %s alors qu'il est déjà autorisé"):format(playerId, npcId)))
        return
    end
    npc:addAllowed(playerId)
    OnoreServerUtils.toClient("newNpc", playerId, npc)
    OnoreSNpcsManager.list[npcId] = npc
end

OnoreSNpcsManager.removeAllowed = function(npcId, playerId)
    if not OnoreSNpcsManager.list[npcId] then
        return
    end
    ---@type Npc
    local npc = OnoreSNpcsManager.list[npcId]
    if not npc:isAllowed(playerId) then
        print(Onore.prefix(OnorePrefixes.npcs,("Tentative de supprimer l'ID %s au blip %s alors qu'il n'est déjà pas autorisé"):format(playerId, npcId)))
        return
    end
    npc:removeAllowed(playerId)
    OnoreServerUtils.toClient("delNpc", playerId, npcId)
    OnoreSNpcsManager.list[npcId] = npc
end

OnoreSNpcsManager.updateOne = function(source)
    local npcs = {}
    ---@param npc Npc
    for npcId, npc in pairs(OnoreSNpcsManager.list) do
        if npc:isRestricted() then
            if npc:isAllowed(source) then
                npcs[npcId] = npc
            end
        else
            npcs[npcId] = npc
        end
    end
    OnoreServerUtils.toClient("cbNpcs", source, npcs)
end

Onore.netRegisterAndHandle("requestPredefinedNpcs", function()
    local source = source
    OnoreSNpcsManager.updateOne(source)
end)

