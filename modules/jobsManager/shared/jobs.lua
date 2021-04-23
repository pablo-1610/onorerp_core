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
        ---@param job Job
        onThisJobInit = function(job)
            local foodZone = OnoreSZonesManager.createPrivate(vector3(-172.42, 295.07, 93.76), 22, {r = 118, g = 59, b = 245, a = 255}, function(source)
                OnoreServerUtils.toClient("ojapOpenFrigo", source, OnoreSCache.getCache("ojapfood"))
            end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le frigo", 20.0, 1.0, {})
            job:registerAdditionalZone(foodZone)
        end,

        inventory = vector3(-172.29, 293.83, 93.76),
        laundry = vector3(-172.22, 287.09, 93.76),
        boss = vector3(-170.63, 305.65, 93.76),
        -- Add garage

        clothes = {
            ["boss"] = {
                ["M"] = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 13,   ['torso_2'] = 0,
                    ['arms'] = 11,
                    ['pants_1'] = 24,   ['pants_2'] = 0,
                    ['shoes_1'] = 10,   ['shoes_2'] = 0,
                    ['helmet_1'] = 7,  ['helmet_2'] = 2,
                    ['chain_1'] = 10,    ['chain_2'] = 2,
                },

                ["F"] = {

                }
            },
            ["member"] = {
                ["M"] = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 13,   ['torso_2'] = 0,
                    ['arms'] = 11,
                    ['pants_1'] = 24,   ['pants_2'] = 0,
                    ['shoes_1'] = 10,   ['shoes_2'] = 0,
                    ['helmet_1'] = 7,  ['helmet_2'] = 2,
                    ['chain_1'] = 10,    ['chain_2'] = 2,
                },

                ["F"] = {

                }
            },
            ["recruit"] = {
                ["M"] = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 13,   ['torso_2'] = 0,
                    ['arms'] = 11,
                    ['pants_1'] = 24,   ['pants_2'] = 0,
                    ['shoes_1'] = 10,   ['shoes_2'] = 0,
                    ['helmet_1'] = 7,  ['helmet_2'] = 2,
                    ['chain_1'] = 10,    ['chain_2'] = 2,
                },

                ["F"] = {

                }
            }
        },
    },

    ["cockatoos"] = {
        ---@param job Job
        onThisJobInit = function(job)
            local foodZone = OnoreSZonesManager.createPrivate(vector3(0,0,0), 22, {r = 118, g = 59, b = 245, a = 255}, function(source)
                OnoreServerUtils.toClient("cockatoosOpenFrigo", source, OnoreSCache.getCache("cockatoosfood"))
            end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le frigo", 20.0, 1.0, {})
            job:registerAdditionalZone(foodZone)
        end,

        inventory = vector3(0,0,0),
        laundry = vector3(0,0,0),
        boss = vector3(0,0,0),
        -- Add garage

        clothes = {
            ["boss"] = {
                ["M"] = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 107,   ['torso_2'] = 0,
                    ['arms'] = 6,
                    ['pants_1'] = 24,   ['pants_2'] = 5,
                    ['shoes_1'] = 16,   ['shoes_2'] = 10,
                    ['helmet_1'] = 6,  ['helmet_2'] = 7,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                },

                ["F"] = {
					['tshirt_1'] = 2,  ['tshirt_2'] = 0,
                    ['torso_1'] = 98,   ['torso_2'] = 0,
                    ['arms'] = 6,
                    ['pants_1'] = 6,   ['pants_2'] = 0,
                    ['shoes_1'] = 5,   ['shoes_2'] = 0,
                    ['helmet_1'] = 4,  ['helmet_2'] = 7,
                    ['chain_1'] = 0,    ['chain_2'] = 0,

                }
            },
            ["member"] = {
                ["M"] = {
                    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 107,   ['torso_2'] = 0,
                    ['arms'] = 6,
                    ['pants_1'] = 24,   ['pants_2'] = 5,
                    ['shoes_1'] = 16,   ['shoes_2'] = 10,
                    ['helmet_1'] = 6,  ['helmet_2'] = 7,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                },

                ["F"] = {
					['tshirt_1'] = 2,  ['tshirt_2'] = 0,
                    ['torso_1'] = 98,   ['torso_2'] = 0,
                    ['arms'] = 6,
                    ['pants_1'] = 6,   ['pants_2'] = 0,
                    ['shoes_1'] = 5,   ['shoes_2'] = 0,
                    ['helmet_1'] = 4,  ['helmet_2'] = 7,
                    ['chain_1'] = 0,    ['chain_2'] = 0,

                }
            },
            ["recruit"] = {
                ["M"] = {
                   ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                    ['torso_1'] = 107,   ['torso_2'] = 0,
                    ['arms'] = 6,
                    ['pants_1'] = 24,   ['pants_2'] = 5,
                    ['shoes_1'] = 16,   ['shoes_2'] = 10,
                    ['helmet_1'] = 6,  ['helmet_2'] = 7,
                    ['chain_1'] = 0,    ['chain_2'] = 0,
                },

                ["F"] = {
					['tshirt_1'] = 2,  ['tshirt_2'] = 0,
                    ['torso_1'] = 98,   ['torso_2'] = 0,
                    ['arms'] = 6,
                    ['pants_1'] = 6,   ['pants_2'] = 0,
                    ['shoes_1'] = 5,   ['shoes_2'] = 0,
                    ['helmet_1'] = 4,  ['helmet_2'] = 7,
                    ['chain_1'] = 0,    ['chain_2'] = 0,

                }
            }
        },
    }
}