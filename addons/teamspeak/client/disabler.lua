--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]


Onore.newThread(function()
	local channel = math.random(1,99999999)
	NetworkSetVoiceActive(true)
	NetworkClearVoiceChannel()
	NetworkSetVoiceChannel(1)
	Onore.newRepeatingTask(function()
        NetworkSetVoiceActive(false)
        NetworkSetVoiceChannel(channel)
    end, nil, 0, 250)
end)

local IsAlive = false
inRadio = false


Onore.netHandleBasic("onore_ts:connected", function()
    IsAlive = true
    EnableAllControlActions(0)
end)

Onore.netHandleBasic("onore_ts:disconnected", function()
    IsAlive = false
end)

local TalkingToRadio = false
Onore.newThread(function()
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