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

---@field public safeMarker number
---@field public laundryMarker number
---@field public bossMarker number
Job = {}
Job.__index = Job

setmetatable(Job, {
    __call = function(_, name, label)
        local self = setmetatable({}, Job);
        self.id = #OnoreSJobsManager.list + 1
        self.name = name
        self.label = label
        self:init()
        OnoreSJobsManager.list[self.name] = self
        return self;
    end
})

---init
---@public
---@return void
function Job:init()
    local infos = OnoreSharedCustomJobs[self.name]
    self.safeMarker = OnoreSZonesManager.createPrivate(infos.inventory, 22, {r = 255, g = 0, b = 0, a = 255}, function(source)
        -- TODO -> InventoryManager.openInventory(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le coffre-fort", 20.0, 1.0, {})

    self.laundryMarker = OnoreSZonesManager.createPrivate(infos.laundry, 22, {r = 255, g = 0, b = 0, a = 255}, function(source)
        self:openCloackRoom(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir les vestiaires", 20.0, 1.0, {})

    self.bossMarker = OnoreSZonesManager.createPrivate(infos.boss, 22, {r = 255, g = 0, b = 0, a = 255}, function(source)
        self:openBoss(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour gérer l'entreprise", 20.0, 1.0, {})
end

---unsubscribe
---@public
---@return void
function Job:unsubscribe(source, gradeName)
    OnoreSZonesManager.removeAllowed(self.safeMarker, source)
    OnoreSZonesManager.removeAllowed(self.laundryMarker, source)
    if gradeName == "boss" then
        OnoreSZonesManager.removeAllowed(self.bossMarker, source)
    end
end

---subscribe
---@public
---@return void
function Job:subscribe(source, gradeName)
    OnoreSZonesManager.addAllowed(self.safeMarker, source)
    OnoreSZonesManager.addAllowed(self.laundryMarker, source)
    if gradeName == "boss" then
        OnoreSZonesManager.addAllowed(self.bossMarker, source)
    end
end

---alterBossAccess
---@public
---@return void
function Job:alterBossAccess(source, bool)
    if bool then
        OnoreSZonesManager.addAllowed(self.bossMarker, source)
    else
        OnoreSZonesManager.removeAllowed(self.bossMarker, source)
    end
end

---openCloackRoom
---@public
---@return void
function Job:openCloackRoom(source)
    OnoreServerUtils.toClient("openCloackroom", source, self.name)
end

---openBoss
---@public
---@return void
function Job:openBoss(source)
    OnoreServerUtils.toClient("openBossMenu", source, self.name)
end

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
