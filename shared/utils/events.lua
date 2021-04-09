--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---toInternal
---@public
---@return void
Onore.toInternal = function(eventName, ...)
    TriggerEvent("onore:" .. Onore.hash(eventName), ...)
end

local registredEvents = {}
local function isEventRegistred(eventName)
    for k,v in pairs(registredEvents) do
        if v == eventName then return true end
    end
    return false
end
---netRegisterAndHandle
---@public
---@return void
Onore.netRegisterAndHandle = function(eventName, handler)
    local event = "onore:" .. Onore.hash(eventName)
    if not isEventRegistred(event) then
        RegisterNetEvent(event)
        table.insert(registredEvents, event)
    end
    AddEventHandler(event, handler)
end

---netRegister
---@public
---@return void
Onore.netRegister = function(eventName)
    local event = "onore:" .. Onore.hash(eventName)
    RegisterNetEvent(event)
end

---netHandle
---@public
---@return void
Onore.netHandle = function(eventName, handler)
    local event = "onore:" .. Onore.hash(eventName)
    AddEventHandler(event, handler)
end

---netHandleBasic
---@public
---@return void
Onore.netHandleBasic = function(eventName, handler)
    AddEventHandler(eventName, handler)
end

---hash
---@public
---@return any
Onore.hash = function(notHashedModel)
    return GetHashKey(notHashedModel)
end

---second
---@public
---@return number
Onore.second = function(from)
    return from*1000
end