--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

RegisterCommand("radio", function(source, args)
    local radio = args[1]
    if args[1] == nil then 
        ESX.ShowNotification("[~r~Onore~s~] Vous devez préciser ~r~STOP ~s~ou entrer une fréquence")
        return
    end
    if args[1]:lower() == "stop" then
        ESX.ShowNotification("[~r~Onore~s~] Déconnecté de la radio !")
        exports.saltychat:SetRadioChannel("", true)
        inRadio = false
        return
    end
    exports.saltychat:SetRadioChannel(tostring(args[1]), true)
    inRadio = true
    ESX.ShowNotification(("[~r~Onore~s~] Connecté à la fréquence: ~g~%s"):format(args[1]))
end, false) 