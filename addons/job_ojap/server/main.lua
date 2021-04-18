---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Onore RolePlay.
  
  File [main] created at [18/04/2021 16:41]

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Onore.netHandle("esxloaded", function()
    local npc = OnoreSNpcsManager.createPublic("ig_milton", false, true, {coords = vector3(-172.369, 291.94, 93.76), heading = 280.0}, "WORLD_HUMAN_AA_SMOKE")
    npc:setInvincible(true)
    npc:setFloatingText("Bienvenue au O'Jap !", 3.5)

    npc = OnoreSNpcsManager.createPublic("ig_milton", false, true, {coords = vector3(-170.19, 289.68, 93.76), heading = 2.66}, "WORLD_HUMAN_CLIPBOARD_FACILITY")
    npc:setInvincible(true)

    npc = OnoreSNpcsManager.createPublic("s_m_y_devinsec_01", false, true, {coords = vector3(-164.18, 299.62, 93.76), heading = 190.66}, "WORLD_HUMAN_GUARD_STAND_FACILITY")
    npc:setInvincible(true)
    npc:setFloatingText("~r~La zone à gauche est reservée au personnel.", 2.8)
end)