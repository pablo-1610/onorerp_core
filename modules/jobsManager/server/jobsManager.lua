---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Onore RolePlay.
  
  File [jobsManager] created at [17/04/2021 21:15]

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local playersJobsCache = {}

OnoreSJobsManager = {}
OnoreSJobsManager.list = {}

---getJob
---@public
---@return Job
OnoreSJobsManager.getJob = function(job)
    return OnoreSJobsManager.list[job]
end

Onore.netHandleBasic("playerDropped", function(reason)
    playersJobsCache[source] = nil
end)

Onore.netHandle("esxloaded", function()
    MySQL.Async.fetchAll("SELECT * FROM jobs WHERE usePabloSystem = 1", {}, function(result)
        for _,job in pairs(result) do
            if not OnoreSharedCustomJobs[job.name] then
                print(Onore.prefix(OnorePrefixes.jobs,("Impossible de charger le job %s"):format(job.label)))
            else
                local society = ("society_%s"):format(job.name)
                TriggerEvent('esx_society:registerSociety', job.name, job.label, society, society, society, {type = 'private'})
                print(Onore.prefix(OnorePrefixes.jobs,("Chargement du job ^1%s ^7!"):format(job.name)))
                Job(job.name, job.label)
                OnoreSharedCustomJobs[job.name].onThisJobInit(OnoreSJobsManager.list[job.name])
            end
        end
    end)
end)

Onore.netRegisterAndHandle("jobInitiated", function(job)
    local source = source
    playersJobsCache[source] = {name = job.name, grade = job.grade_name, isCustom = OnoreSJobsManager.getJob(job.name) ~= nil}
    if not OnoreSJobsManager.getJob(job.name) then
        return
    end
    ---@type Job
    local onoreJob = OnoreSJobsManager.getJob(job.name)
    onoreJob:subscribe(source, job.grade_name)
end)

Onore.netRegisterAndHandle("jobUpdated", function(newJob)
    local source = source
    local previousCache = playersJobsCache[source]
    local newCache = {name = newJob.name, grade = newJob.grade_name, isCustom = OnoreSJobsManager.getJob(newJob.name) ~= nil}

    if previousCache.name ~= newJob.name then
        -- Changement de job
        ---@type Job
        if previousCache.isCustom then
            local previousJob = OnoreSJobsManager.getJob(previousCache.name)
            previousJob:unsubscribe(source, previousCache.grade)
        end
        if newCache.isCustom then
            local newOnoreJob = OnoreSJobsManager.getJob(newCache.name)
            newOnoreJob:subscribe(source, newCache.grade)
        end
    else
        if newCache.isCustom then
            if previousCache.grade ~= newCache.grade then
                local onoreJob = OnoreSJobsManager.getJob(newCache.name)
                if previousCache.grade == "boss" then
                    onoreJob:alterBossAccess(source, false)
                elseif newCache.grade == "boss" then
                    onoreJob:alterBossAccess(source, true)
                end
            end
        end
    end

    playersJobsCache[source] = newCache
end)