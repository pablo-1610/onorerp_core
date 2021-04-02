--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local NearZone = false

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        if not NearZone then
            Wait(2500)
        else
            Wait(50)
        end
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        SendNUIMessage({
            status = "position",
            x = pos.x,
            y = pos.y,
            z = pos.z
        })
    end
end)


MusicZone = {
    {
        name = "bar_ambience",
        link = "https://www.youtube.com/watch?v=ZcThrAU9yLk",
        dst = 15.0,
        starting = 35.0,
        pos = vector3(281.4, -973.0, 29.87),
        max = 0.05,
    },
    {
        name = "police_radio",
        link = "https://www.youtube.com/watch?v=eqnq5XF3CJ0",
        dst = 15.0,
        starting = 35.0,
        pos = vector3(440.81, -977.01, 30.68),
        max = 0.1,
    },
    {
        name = "shop_ambient",
        link = "https://www.youtube.com/watch?v=WoxnL5dakyA&t=6s",
        dst = 10.0,
        starting = 30.0,
        pos = vector3(25.74, -1345.8, 29.49),
        max = 0.09,
    },
    {
        name = "weed_ambient",
        link = "https://www.youtube.com/watch?v=5qdTU3i6-XI",
        dst = 15.0,
        starting = 50.0,
        pos = vector3(374.3, -826.14, 29.30),
        max = 0.04,
    },
}

Citizen.CreateThread(function()
    Wait(2000)
    while true do
        NearZone = false
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        for k,v in pairs(MusicZone) do
            local dst = GetDistanceBetweenCoords(pCoords, v.pos, true)
            if not NearZone then
                if dst < v.starting then
                    NearZone = true
                    if soundExists(v.name) then
                        Resume(v.name)
                    else
                        PlayUrlPos(v.name, v.link, v.max, v.pos, true)
                        setVolumeMax(v.name, v.max)
                        Distance(v.name, v.dst)
                    end
                else
                    if soundExists(v.name) then
                        if not isPaused(v.name) then
                            Pause(v.name)
                        end
                    end
                end
            end
        end

        if not NearZone then
            Wait(350)
        else
            Wait(50)
        end
    end
end)