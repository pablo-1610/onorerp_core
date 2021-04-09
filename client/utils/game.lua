--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

OnoreGameUtils = {}

OnoreGameUtils.advancedNotification = function(sender, subject, msg, textureDict, iconType)
    AddTextEntry('AutoEventAdvNotif', msg)
    BeginTextCommandThefeedPost('AutoEventAdvNotif')
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
end

OnoreGameUtils.playAnim = function(dict, anim, flag, blendin, blendout, playbackRate, duration)
	if blendin == nil then blendin = 1.0 end
	if blendout == nil then blendout = 1.0 end
	if playbackRate == nil then playbackRate = 1.0 end
	if duration == nil then duration = -1 end
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(1) print("Waiting for "..dict) end
	TaskPlayAnim(GetPlayerPed(-1), dict, anim, blendin, blendout, duration, flag, playbackRate, 0, 0, 0)
	RemoveAnimDict(dict)
end	

OnoreGameUtils.warnVariator = "~r~"
OnoreGameUtils.dangerVariator = "~y~"

Onore.newRepeatingTask(function()
	if OnoreGameUtils.warnVariator == "~r~" then OnoreGameUtils.warnVariator = "~s~" else OnoreGameUtils.warnVariator = "~r~" end
	if OnoreGameUtils.dangerVariator == "~y~" then OnoreGameUtils.dangerVariator = "~o~" else OnoreGameUtils.dangerVariator = "~y~" end
end, nil, 0,650)

Onore.netRegisterAndHandle("advancedNotif", OnoreGameUtils.advancedNotification)