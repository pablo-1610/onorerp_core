--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreSCache = {}

OnoreSCache.caches = {}
OnoreSCache.relativesDb = {}

OnoreSCache.getCache = function(index)
    return OnoreSCache.caches[index] or {}
end

OnoreSCache.addCacheRule = function(index, sqlTable, updateFrequency)
    OnoreSCache.caches[index] = {}
    OnoreSCache.relativesDb[sqlTable] = { index = index, interval = updateFrequency }
    OnoreServerUtils.trace(("Ajout d'une règle de cache: ^2%s ^7sur ^3%s"):format(index,sqlTable), OnorePrefixes.sync)
end

OnoreSCache.removeCacheRule = function(sql)
    OnoreSCache.caches[OnoreSCache.relativesDb[sql]] = nil
    Onore.cancelTaskNow(OnoreSCache.relativesDb[sql].processId)
    OnoreServerUtils.trace(("Retrait d'une règle de cache: ^2%s"):format(OnoreSCache.relativesDb[sql].index), OnorePrefixes.sync)
    OnoreSCache.relativesDb[sql] = nil
end

Onore.netHandle("esxloaded", function()
    while true do
        for sqlTable, infos in pairs(OnoreSCache.relativesDb) do
            if not infos.processId then
                infos.processId = Onore.newRepeatingTask(function()
                    MySQL.Async.fetchAll(("SELECT * FROM %s"):format(sqlTable), {}, function(result)
                        if OnoreSCache.caches[infos.index] ~= nil then
                            OnoreSCache.caches[infos.index] = result
                        end
                    end)
                end, nil, 0, infos.interval)
            end
        end
        Wait(Onore.second(1))
    end
end)

