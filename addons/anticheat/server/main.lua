--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

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