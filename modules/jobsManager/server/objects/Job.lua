---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Onore RolePlay.
  
  File [Job] created at [17/04/2021 21:16]

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Job
Job = {}
Job.__index = Job

setmetatable(Job, {
    __call = function(_)
        local self = setmetatable({}, Job);

     
        return self;
    end
})
