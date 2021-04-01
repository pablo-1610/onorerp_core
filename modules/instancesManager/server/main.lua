--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterNetEvent("onore_instance:setBucket")
AddEventHandler("onore_instance:setBucket", function(bucketID)
    local source = source
    SetPlayerRoutingBucket(bucketID, 0)
end)

RegisterNetEvent("onore_instance:setOnPublicBucket")
AddEventHandler("onore_instance:setOnPublicBucket", function()
    local source = source
    SetPlayerRoutingBucket(source, 0)
end)