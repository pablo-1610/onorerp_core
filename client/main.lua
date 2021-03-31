--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(0)
    end
    Job = ESX.PlayerData.job
    if Jobs.list[Job.name] ~= nil and Jobs.list[Job.name].onChange ~= nil then
        Jobs.list[Job.name].onChange()
    end
    TriggerEvent("onore_esxloaded")
    RegisterCommand("gotoCoords", function(source, args)
        SetEntityCoords(PlayerPedId(), tonumber(args[1]), tonumber(args[2]), tonumber(args[3]), false, false, false, false)
    end, false)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData = ESX.GetPlayerData()
    if Job ~= job then
        Job = ESX.PlayerData.job
        if Jobs.list[Job.name] ~= nil and Jobs.list[Job.name].onChange ~= nil then
            Jobs.list[Job.name].onChange()
        end
    end
end)