--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Onore.netRegisterAndHandle('shareDisplay', function(fuckRuby, idsToSend, text, pPedSID)
    for k,v in pairs(idsToSend) do
        OnoreServerUtils.toClient("shareDisplay", v, text, pPedSID)
    end
end)