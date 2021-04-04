--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local popEnabled = false 
RegisterCommand("onoreLC", function(source)
    popEnabled = not popEnabled
    SetRoutingBucketPopulationEnabled(0, popEnabled)
    if popEnabled then
        print("LOCKDOWN ONORE DESACTIVE")
        OnoreServerUtils.webhook("Mode lockdown désactivé !", "green", "https://discord.com/api/webhooks/828395780821614612/PZWRslJFwX8-psxHhxTBafetjOD1Ozdzt3TfgYMp3xTUnxgMUA3PMQDJT2I9FELpai-M")
    else
        print("LOCKDOWN ONORE ACTIVE")
        OnoreServerUtils.webhook("Mode lockdown activé !", "red", "https://discord.com/api/webhooks/828395780821614612/PZWRslJFwX8-psxHhxTBafetjOD1Ozdzt3TfgYMp3xTUnxgMUA3PMQDJT2I9FELpai-M")
    end
end)

AddEventHandler('entityCreated', function(entity)
    local entity = entity
    if not DoesEntityExist(entity) then
        return
    end
    local type = GetEntityType(entity)
    local script = GetEntityScript(entity) or "(Aucun initiateur)"
    local owner = NetworkGetEntityOwner(entity) or "(Aucun owner)"
    if owner ~= "(Aucun owner)" then
        owner = owner.." ||"..json.encode(OnoreServerUtils.getLicense(NetworkGetEntityOwner(entity))).."||"
    end
    local model = GetEntityModel(entity) or "(Aucun model)"
    if model == 974883178 or -1964402432 then return end
    local color = ""
    if type == 3 then
        color = "red"
        OnoreServerUtils.webhook(("Entité crée par %s, infos:\n\nType: %s\nScript: %s\nModel: %s\nCo: %s"):format(owner,type,script,model,GetEntityCoords(entity) or "(Aucune coords)"), color, "https://discord.com/api/webhooks/828391092427685899/SfqMdBfrcmrvK26E4d4cA7r5XLTpXHSVKC8JwH0R04bffOShw2GYxRoQSrQAPl9SkYMl")
    else
        return
    end
    OnoreServerUtils.webhook(("Entité crée par %s, infos:\n\nType: %s\nScript: %s\nModel: %s\nCo: %s"):format(owner,type,script,model,GetEntityCoords(entity) or "(Aucune coords)"), color, "https://discord.com/api/webhooks/828388956357525595/6cRqfVEHR9g1tgaZ7h7nZ5IdpW2m_lgIvNg3pEqECQUs2GUffaIH4hqSe4xSYRto-yFK")
end)

AddEventHandler('explosionEvent', function(sender, ev)
    CancelEvent()
    local player = GetPlayerName(sender) or "Inconnu"
    if player ~= "Inconnu" then
        player = player.." ||"..OnoreServerUtils.getLicense(sender).."||"
    end
    OnoreServerUtils.webhook(("Explosion crée par %s"):format(player), "red", "https://discord.com/api/webhooks/828391373731659776/-QdH-YrvzEBRGp4hRqZnQA_xwq5a7jLad5nF_i3Vhqppxk4tbSjjaexnSS2dGxtsDefr")
    OnoreServerUtils.webhook(("Infos de l'explo: %s"):format(json.encode(ev)), "red", "https://discord.com/api/webhooks/828391373731659776/-QdH-YrvzEBRGp4hRqZnQA_xwq5a7jLad5nF_i3Vhqppxk4tbSjjaexnSS2dGxtsDefr")
    OnoreServerUtils.trace("Création d'une explosion", OnorePrefixes.sync)
end)

AddEventHandler("fireEvent", function(sender,ev)
    CancelEvent()
    local license = OnoreServerUtils.getLicense(tonumber(sender))
    OnoreServerUtils.webhook(("La license %s a démarré un incendie\n\nTable: %s"):format(license,json.encode(ev)), "red", "https://discord.com/api/webhooks/828392491837030411/37Mp0f2RwbcoAWDbUje979S13mwDxRy4MDHFnrGikeNfBHZppPW8tSc5TbOYwxBPGK2j")
    OnoreServerUtils.trace("Création de feu", OnorePrefixes.sync)
end)

AddEventHandler("removeWeaponEvent", function(sender, ev)
    local license = OnoreServerUtils.getLicense(tonumber(sender))
    OnoreServerUtils.webhook(("La license %s a removeweapon\n\nTable: %s"):format(license,json.encode(ev)), "red", "https://discord.com/api/webhooks/828393408359825408/ugyDzrnbj3UvwoMQtAAWgP3zX0u2k0OOXycYdyY_bwp02A5lhP4CQGeAh-G1lYSpbzcJ")
    OnoreServerUtils.trace("Event retirer arme", OnorePrefixes.sync)
end)

AddEventHandler("giveWeaponEvent", function(sender,ev)
    local license = OnoreServerUtils.getLicense(tonumber(sender))
    OnoreServerUtils.webhook(("La license %s a giveWeapon\n\nTable: %s"):format(license,json.encode(ev)), "red", "https://discord.com/api/webhooks/828393578082205787/BqN3Izdy6-3KQulUEmLOqA3kvT0EkHSIrKiYmntHCxaPVaMLdn-H6s2Drk0uEI_1ymrD")
    OnoreServerUtils.trace("Event give une arme", OnorePrefixes.sync)
end)

AddEventHandler("startProjectileEvent", function(sender,ev)
    local license = OnoreServerUtils.getLicense(tonumber(sender))
    OnoreServerUtils.webhook(("La license %s a startProjectile\n\nTable: %s"):format(license,json.encode(ev)), "red", "https://discord.com/api/webhooks/828393780285407232/2KznHnl4vzlqFqCrgOhEoEyBV8AItYzchuSDi6GxRuun1k-a6ut8DgB8vaB5MaY4yOZk")
    OnoreServerUtils.trace("Event start projectile", OnorePrefixes.sync)
end)

AddEventHandler('clearPedTasksEvent', function(sender, ev)
    local license = OnoreServerUtils.getLicense(tonumber(sender))
    OnoreServerUtils.webhook(("La license %s a clearTasks\n\nTable: %s"):format(license,json.encode(ev)), "red", "    https://discord.com/api/webhooks/828393690447478844/fykXu3yS19CvuySmn6olbwpNVNmZadsyKMtPE4FzfyYkKgCfUco0VX0IvxaH4fkHl3u_")
    OnoreServerUtils.trace("Event clear ped tasks", OnorePrefixes.sync)
end)