--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Jobs.list["realestateagent"].onChange = function()
end

RegisterNetEvent("onore_realestateagent:enterHouse")
AddEventHandler("onore_realestateagent:enterHouse", function(coords)
    FreezeEntityPosition(PlayerPedId(), true)
    DoScreenFadeOut(750)
    Wait(1500)
    SetEntityCoords(PlayerPedId(), coords.position, false, false, false, false)
    SetEntityHeading(PlayerPedId(), coords.heading)
    DoScreenFadeIn(750)
    FreezeEntityPosition(PlayerPedId(), false)
    tpAnim = false
end)

RegisterNetEvent("onore_realestateagent:exitHouse")
AddEventHandler("onore_realestateagent:exitHouse", function(coords)
    tpAnim = true
    FreezeEntityPosition(PlayerPedId(), true)
    DoScreenFadeOut(750)
    Wait(1500)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
    DoScreenFadeIn(750)
    FreezeEntityPosition(PlayerPedId(), false)
    tpAnim = false
end)