--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local player = PlayerId()
        DisableControlAction(0, 249, true)
        if NetworkIsPlayerTalking(player) then
            SetPlayerTalkingOverride(player, false)
        end
	end
end)