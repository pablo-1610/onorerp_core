--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterNetEvent('onore_me:shareDisplay')
AddEventHandler('onore_me:shareDisplay', function(fuckRuby, idsToSend, text, pPedSID)
    for k,v in pairs(idsToSend) do
        TriggerClientEvent("onore_me:shareDisplay", v, text, pPedSID)
    end
end)