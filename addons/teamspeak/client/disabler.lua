--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]


Citizen.CreateThread(function()
	local channel = math.random(1,99999999)
	NetworkSetVoiceActive(true)
	NetworkClearVoiceChannel()
	NetworkSetVoiceChannel(1)
	while true do
		Wait(250)
		NetworkSetVoiceActive(false)
		NetworkSetVoiceChannel(channel)
	end
end)

local IsAlive = false
inRadio = false


AddEventHandler("onore_ts:connected", function()
    IsAlive = true
end)

AddEventHandler("onore_ts:disconnected", function()
    IsAlive = false
end)

local TalkingToRadio = false
Citizen.CreateThread(function()
    while true do
        if not IsAlive then
            Wait(1)
            RageUI.Text({
                message = "Tu n'es pas connecté au Teamspeak de Onore !"
            })
            DisableAllControlActions(0)
        else
            if IsControlPressed(1, 249) and not InAction then
                if inRadio then
                    if not TalkingToRadio then
                        OnoreGameUtils.playAnim("random@arrests", "generic_radio_chatter", 49, 5.0, 5.0)
                        TalkingToRadio = true
                    end
                end
            else
                if TalkingToRadio and not InAction then
                    ClearPedTasks(PlayerPedId())
                    TalkingToRadio = false
                end
            end
            Wait(300)
        end
    end
end)