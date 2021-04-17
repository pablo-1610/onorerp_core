--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Onore = {}
Onore.newThread = Citizen.CreateThread
Onore.newWaitingThread = Citizen.SetTimeout
Citizen.CreateThread, CreateThread, Citizen.SetTimeout, SetTimeout, InvokeNative = nil, nil, nil, nil, nil

Job = nil
Jobs = {}
Jobs.list = {}

OnorePrefixes = {
    house = "^3HOUSES",
    zones = "^1ZONE",
    blips = "^1BLIPS",
    npcs = "^1NPCS",
    dev = "^4INFOS",
    sync = "^6SYNC"
}

Onore.prefix = function(title, message)
    return ("[^1Onore^7] (%s^7) %s" .. "^7"):format(title, message)
end