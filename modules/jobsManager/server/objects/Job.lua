---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Onore RolePlay.
  
  File [Job] created at [17/04/2021 21:16]

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Job
---@field public id number
---@field public name string
---@field public label string
Job = {}
Job.__index = Job

setmetatable(Job, {
    __call = function(_, name, label)
        local self = setmetatable({}, Job);
        self.id = #OnoreSJobsManager.list + 1
        self.name = name
        self.label = label
        OnoreSJobsManager[self.name] = self
        return self;
    end
})

---notifyEmployees
---@public
---@return void
function Job:notifyEmployees(message)
    local players = ESX.GetPlayers()
    for k,v in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.getJob() == self.name then
            TriggerClientEvent("esx:showNotifciation", v, message)
        end
    end
end

---getActiveEmployees
---@public
---@return table
function Job:getActiveEmployees()
    local players, employees = ESX.GetPlayers(), {}
    for k,v in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.getJob() == self.name then
            employees[v] = xPlayer
        end
    end
    return employees
end
