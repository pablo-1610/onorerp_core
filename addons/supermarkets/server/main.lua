--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreSCache.addCacheRule("shopspromo", "onore_shopspromo", Onore.second(10))
OnoreSCache.addCacheRule("shopsitems", "onore_shopsitems", Onore.second(10))

local function calcBasket(basket, itemsCache)
    local result = 0
    itemsCache = itemsCache or OnoreSCache.getCache("shopsitems")
    for k,v in pairs(basket) do
        result = result + (itemsCache[k].price*v)
    end
    return result
end

local function giveItems(basket, xPlayer, itemsCache)
    itemsCache = itemsCache or OnoreSCache.getCache("shopsitems")
    for k,v in pairs(basket) do
        xPlayer.addInventoryItem(itemsCache[k].item, v)
    end
end

local function applyPercentage(promoCache,promoCode,price)
    local percentage = tonumber(promoCache[promoCode].percentage)
    return (price * (1-(percentage/100)))
end

local function generateWebhook(itemsCache, basket, reduction, promoCode, promoCache, source)
    local sb = ("Le joueur %s a payé à la superette.\n"):format(GetPlayerName(source))
    local color = ""
    for k,v in pairs(basket) do
        sb = sb..("\nx%s • %s"):format(v,itemsCache[k].label)
    end
    if reduction ~= nil then
        color = "orange"
        sb = sb..(("\n\nPour un total de: __%s__$"):format(applyPercentage(promoCache,promoCode,calcBasket(basket,itemsCache))))
        sb = sb..("\nEn utilisant le code promo %s (-%s%%)"):format(promoCache[promoCode].code, promoCache[promoCode].percentage)
    else
        color = "green"
        sb = sb..("\n\nPour un total de: __%s__$"):format(calcBasket(basket, itemsCache))
    end
    OnoreServerUtils.webhook(sb, color, "https://discord.com/api/webhooks/830105466570407996/ed00kSlP1gkkl4In3P2bP68yYR2umG5mUkwj8M4SVZbfFaWgDxD5g-tgggsDcoDwEPZt")
end

Onore.netRegisterAndHandle("shopPay", function(basket, promoCode, payMethod)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = 0
    local pay = nil
    if payMethod == 1 then
        money = xPlayer.getMoney()
        pay = function(price)
            xPlayer.removeMoney(price)
        end
    else
        money = xPlayer.getAccount("bank").money
        pay = function(price)
            xPlayer.removeAccountMoney("bank", price)
        end
    end
    local reduction = nil
    local promoCache = OnoreSCache.getCache("shopspromo")
    if promoCode ~= nil then
        if not promoCache[promoCode] then
            OnoreServerUtils.toClient("supermarketCallback", source, false)
            TriggerClientEvent("esx:showNotifciation", source, "~y~Détails~s~: ~r~le code promotionnel n'est plus actif")
            return
        end
        reduction = promoCache[promoCode].percentage
    end
    local price = calcBasket(basket)
    if reduction ~= nil then
        price = applyPercentage(promoCache,promoCode,price)
    end
    if money < price then
        OnoreServerUtils.toClient("supermarketCallback", source, false)
        TriggerClientEvent("esx:showNotifciation", source, "~y~Détails~s~: ~r~Vous n'avez pas assez d'argent pour payer")
        return
    end
    pay(price)
    giveItems(basket, xPlayer)
    generateWebhook(OnoreSCache.getCache("shopsitems"), basket, reduction, promoCode, promoCache, source)
    OnoreServerUtils.toClient("supermarketCallback", source, true)
end)