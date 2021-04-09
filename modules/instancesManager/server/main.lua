--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

Onore.netRegisterAndHandle("setBucket", function(bucketID)
    local source = source
    SetPlayerRoutingBucket(bucketID, 0)
end)

Onore.netRegisterAndHandle("setOnPublicBucket", function()
    local source = source
    SetPlayerRoutingBucket(source, 0)
end)