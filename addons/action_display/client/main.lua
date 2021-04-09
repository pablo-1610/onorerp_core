--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local defaultScale = 0.5 -- Text scale
local color = {221, 135, 250, 200 } -- Text color
local font = 0 -- Text font
local displayTime = 5000 -- Duration to display the text (in ms)
local distToDraw = 250 -- Min. distance to draw 
local pedDisplaying = {}

local function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    local scale = 200 / (GetGameplayCamFov() * dist)
    SetTextColour(color[1], color[2], color[3], color[4])
    SetTextScale(0.0, defaultScale * scale)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local function Display(ped, text)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
    if dist <= distToDraw then
        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1
        local display = true
        Onore.newWaitingThread(displayTime, function()
            display = false
        end)
        local offset = 0.8 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), text)
            end
            Wait(0)
        end
        pedDisplaying[ped] = pedDisplaying[ped] - 1
    end
end

local function TableToString(tab)
	local str = ""
	for i = 1, #tab do
		str = str .. " " .. tab[i]
	end
	return str
end

local allowed = true
RegisterCommand('me', function(source, args)
    if allowed then
        local pPedSID = GetPlayerServerId(GetPlayerIndex())
        local players = GetActivePlayers()
        local idsToSend = {}
        for k,v in pairs(players) do
            table.insert(idsToSend, GetPlayerServerId(v))
        end
        local text = "* la personne" .. TableToString(args) .. " *"
        OnoreClientUtils.toServer("shareDisplay", idsToSend, text, pPedSID)
        ActionMeCoolDown()
    end
end)

function SendActionTxt(text)
    if allowed then
        local pPedSID = GetPlayerServerId(GetPlayerIndex())
        local players = GetActivePlayers()
        local idsToSend = {}
        local pCoords = GetEntityCoords(pPed)
        for k,v in pairs(players) do
            local dst = GetDistanceBetweenCoords(pCoords, GetEntityCoords(GetPlayerPed(v)), true)
            if dst < 100 then
                table.insert(idsToSend, GetPlayerServerId(v))
            end
        end
        local text = "* la personne" .. text .. " *"
        OnoreClientUtils.toServer("shareDisplay", idsToSend, text, pPedSID)
        ActionMeCoolDown()
    end
end

Onore.netRegisterAndHandle('shareDisplay', function(text, serverId)
    local ped = GetPlayerPed(GetPlayerFromServerId(serverId))
    if ped ~= nil then Display(ped, text) end
end)


function ActionMeCoolDown()
    allowed = false
    Onore.newWaitingThread(6*1000, function()
        allowed = true
    end)
end