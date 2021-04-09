--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local function promoShopsActivate()
    MySQL.Async.execute("INSERT INTO onore_shopspromo (code,percentage) VALUES(@a,@b)",{
        ['a'] = "NUIT",
        ['b'] = 20
    }, function()
        OnoreServerUtils.webhook("Activation du code promo NUIT", "green", "https://discord.com/api/webhooks/830109848376573952/3Zhqf1uMTSaLuq276NuEufODgd6K9-UyLL5Qnpg3jRGtJ7zppSoXmYqs1_vIEjnBcykA")
    end)
end

local function promoShopsDesactivate()
    MySQL.Async.execute("DELETE FROM onore_shopspromo WHERE code = @a",{
        ['a'] = "NUIT"
    }, function()
        OnoreServerUtils.webhook("Désactivation du code promo NUIT", "red", "https://discord.com/api/webhooks/830109848376573952/3Zhqf1uMTSaLuq276NuEufODgd6K9-UyLL5Qnpg3jRGtJ7zppSoXmYqs1_vIEjnBcykA")
    end)
end

Onore.toInternal('registerTask', 2, 00, promoShopsActivate)
Onore.toInternal('registerTask', 6, 00, promoShopsDesactivate)