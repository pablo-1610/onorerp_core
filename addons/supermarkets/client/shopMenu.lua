--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local cat, desc = "supermarket", "~g~Superette Onore"
local sub = function(str)
    return cat .. "_" .. str
end
local transaction = false

Onore.netRegisterAndHandle("supermarketCallback", function(state)
    transaction = false
    if state then
        ESX.ShowNotification("~g~Transaction effectuée")
    else
        ESX.ShowNotification("~r~Une erreur est survenue")
    end
end)

Onore.netRegisterAndHandle("openSupermarketMenu", function(moneys, promos, items)
    if menuIsOpened then
        return
    end
    FreezeEntityPosition(PlayerPedId(), true)
    menuIsOpened = true

    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, desc, nil, nil, "root_cause", "shopui_title_24-7"))
    RMenu:Get(cat, sub("main")).Closed = function()
    end

    RMenu.Add(cat, sub("pay"), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "root_cause", "shopui_title_24-7"))
    RMenu:Get(cat, sub("pay")).Closed = function()end

    local activePromoCode = nil
    local basket = {}
    local function calcBasket()
        local result = 0
        for itemId, itemCount in pairs(basket) do
            result = result + (items[itemId].price*itemCount)
        end
        return result
    end
    local function countItem(itemId)
        if not basket[itemId] then return "" end
        return ("~s~[~r~x%i~s~]~s~ "):format(basket[itemId])
    end
    local function activatePromoCode(input)
        for k,v in pairs(promos) do
            if input:upper() == v.code:upper() then
                activePromoCode = k
                ESX.ShowNotification("~g~Code promotionnel activé !")
                return
            end
        end
        ESX.ShowNotification("~r~Ce code promotionnel est invalide !")
        return
    end
    local function calcReduction(price)
        if not activePromoCode then return price end
        return (price * tonumber(promos[activePromoCode].percentage))/100
    end
    local function canAfford(accountMoney)
        if accountMoney >= calcReduction(calcBasket()) then
            return {display = "~g~Payer ~s~→→", bool = true}
        else
            return {display = "~r~Fonds insuffisants", bool = false}
        end
    end
    local categories = {}


    local catNum = 0
    for k,v in pairs(items) do
        local categ = v.category
        if not categories[categ] then
            catNum = catNum + 1
            categories[categ] = {}
            RMenu.Add(cat, sub(("c%s"):format(categ)), RageUI.CreateSubMenu(RMenu:Get(cat, sub("main")), nil, desc, nil, nil, "root_cause", "shopui_title_24-7"))
            RMenu:Get(cat, sub(("c%s"):format(categ))).Closed = function()end
        end
        categories[categ][k] = v
    end

    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    Onore.newThread(function()
        while menuIsOpened do
            local shouldStayOpened = false
            local function tick()
                shouldStayOpened = true
            end
            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
                if activePromoCode ~= nil then
                    RageUI.Separator(("Coût de votre panier: ~r~%s$ ~s~→ ~g~%s$"):format(ESX.Math.GroupDigits(calcBasket()), ESX.Math.GroupDigits(calcReduction(calcBasket()))))
                    RageUI.Separator(("Code promotionnel actif: ~o~%s ~s~(~y~-%s%%~s~)"):format(promos[activePromoCode].code:upper(), promos[activePromoCode].percentage))
                else
                    RageUI.Separator(("Coût de votre panier: ~g~%s$"):format(ESX.Math.GroupDigits(calcBasket())))
                end
                RageUI.Separator("↓ ~g~Catégories disponibles ~s~↓")
                for categ, _ in pairs(categories) do
                    RageUI.ButtonWithStyle(("~o~→ ~s~Catégorie ~b~%s"):format(categ:lower()), nil, { RightLabel = "~b~Parcourir ~s~→→" }, true, function(_, _, s)
                    end, RMenu:Get(cat, sub(("c%s"):format(categ))))
                end
                RageUI.Separator("↓ ~y~Mon panier ~s~↓")
                RageUI.ButtonWithStyle("Appliquer un code promotionnel", nil, { RightLabel = "→→" }, true, function(_, _, s)
                    if s then
                        local result = OnoreMenuUtils.inputBox("Agence immo", "", 20, false)
                        if result ~= nil then
                            Onore.newThread(function()
                                activatePromoCode(result)
                            end)
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~r~Vider ~s~mon panier", nil, {RightLabel = "→→"}, true, function(_,_,s)
                    if s then
                        basket = {}
                    end
                end)
                RageUI.ButtonWithStyle("Procéder au ~g~paiement", nil, { RightLabel = "→→" }, true, function(_, _, s)
                end, RMenu:Get(cat, sub("pay")))
            end, function()
            end)
            for categ,categItems in pairs(categories) do
                RageUI.IsVisible(RMenu:Get(cat, sub(("c%s"):format(categ))), true, true, true, function()
                    tick()
                    if activePromoCode ~= nil then
                        RageUI.Separator(("Coût de votre panier: ~r~%s$ ~s~→ ~g~%s$"):format(ESX.Math.GroupDigits(calcBasket()), ESX.Math.GroupDigits(calcReduction(calcBasket()))))
                    else
                        RageUI.Separator(("Coût de votre panier: ~g~%s$"):format(ESX.Math.GroupDigits(calcBasket())))
                    end
                    RageUI.Separator(("Catégorie: ~y~%s"):format(categ))
                    RageUI.Separator("↓ ~g~Produits disponibles ~s~↓")
                    for itemPlace, itemInfos in pairs(categItems) do
                        RageUI.ButtonWithStyle(("~o~→ %s~b~%s"):format(countItem(itemPlace),itemInfos.label), nil, { RightLabel = ("~g~Ajouter ~s~(~g~%s$~s~/~g~unité~s~) ~s~→→"):format(ESX.Math.GroupDigits(itemInfos.price)) }, true, function(_, _, s)
                            if s then
                                if not basket[itemPlace] then
                                    basket[itemPlace] = 1
                                else
                                    basket[itemPlace] = basket[itemPlace] + 1
                                end
                            end
                        end)
                    end
                end, function()
                end)
            end

            RageUI.IsVisible(RMenu:Get(cat, sub("pay")), true, true, true, function()
                tick()
                if transaction then
                    RageUI.Separator(("%sTransaction avec le serveur en cours..."):format(OnoreGameUtils.dangerVariator))
                end
                if activePromoCode ~= nil then
                    RageUI.Separator(("Coût de votre panier: ~r~%s$ ~s~→ ~g~%s$"):format(ESX.Math.GroupDigits(calcBasket()), ESX.Math.GroupDigits(calcReduction(calcBasket()))))
                else
                    RageUI.Separator(("Coût de votre panier: ~g~%s$"):format(ESX.Math.GroupDigits(calcBasket())))
                end
                RageUI.Separator("↓ ~g~Moyens de paiement ~s~↓")
                local cashMethod = canAfford(moneys.cash)
                local bankMethod = canAfford(moneys.bank)
                RageUI.ButtonWithStyle("→ Payer en ~b~liquide", nil, {RightLabel = cashMethod.display}, not transaction, function(_,_,s)
                    if s then
                        if cashMethod.bool then
                            ESX.ShowNotification("~y~Transaction en cours...")
                            OnoreClientUtils.toServer("shopPay", basket, activePromoCode, 1)
                            transaction = true
                        else
                            ESX.ShowNotification("~r~Vous n'avez pas assez d'argent sur vous pour payer la somme demandée !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("→ Payer en ~y~banque", nil, {RightLabel = bankMethod.display}, not transaction, function(_,_,s)
                    if s then
                        if bankMethod.bool then
                            ESX.ShowNotification("~y~Transaction en cours...")
                            OnoreClientUtils.toServer("shopPay", basket, activePromoCode, 2)
                            transaction = true
                        else
                            ESX.ShowNotification("~r~Vous n'avez pas assez d'argent en banque pour payer la somme demandée !")
                        end
                    end
                end)
            end, function()
            end)

            if not shouldStayOpened and menuIsOpened then
                menuIsOpened = false
            end
            Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        RMenu:Delete(cat, sub("main"))
        RMenu:Delete(cat, sub("pay"))
        for categ, _ in pairs(categories) do
            RMenu:Delete(cat, sub(("c%s"):format(categ)))
        end
    end)
end)