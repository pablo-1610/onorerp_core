--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

ESX = nil

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
    Wait(100)
    TriggerEvent("onore_esxloaded")
end)
