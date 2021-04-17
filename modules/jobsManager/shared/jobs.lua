---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Onore RolePlay.
  
  File [jobs] created at [17/04/2021 21:19]

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreSharedCustomJobs = {
    ["ojap"] = {
        inventory = vector3(-172.29, 293.83, 93.76),
        laundry = vector3(-172.22, 287.09, 93.76),
        boss = vector3(-170.63, 305.65, 93.76),

        permissions = {
            ["boss"] = {"clothe", "inventory", "boss"},
            ["member"] = {"clothe", "inventory"},
            ["recruit"] = {"clothe"}
        },

        clothes = {
            ["boss"] = {},
            ["member"] = {},
            ["recruit"] = {}
        }
    }
}