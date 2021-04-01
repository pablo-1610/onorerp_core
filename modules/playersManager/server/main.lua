--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnorePlayersManager = {}

OnorePlayersManager.kick = function(source, reason)
    DropPlayer(source, reason)
end