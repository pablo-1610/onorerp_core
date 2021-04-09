--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Onore = {}
Job = nil
Jobs = {}
Jobs.list = {}

OnorePrefixes = {
    house = "^3HOUSES",
    zones = "^1ZONE",
    blips = "^1BLIPS",
    dev = "^4INFOS",
    sync = "^6ONESYNC"
}

Onore.prefix = function(title, message)
    return ("[^1Onore^7] (%s^7) %s" .. "^7"):format(title, message)
end