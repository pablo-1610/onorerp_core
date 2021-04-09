--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Onore.netRegisterAndHandle('shareDisplay', function(idsToSend, text, pPedSID)
	local source = source
	OnoreServerUtils.webhook(("%s: /me %s"):format(GetPlayerName(source), text), "grey", "https://discord.com/api/webhooks/830047199051251722/O-Ru6RMHdxcnt_M5fENbaZ-bJDSm0jWXuYEggR5JLnj8vMS0sudrzVdi1LXNcKA8-_NO")
	for k,v in pairs(idsToSend) do
		OnoreServerUtils.toClient("shareDisplay", v, text, pPedSID)
	end
end)