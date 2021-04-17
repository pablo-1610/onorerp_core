--[[
  This file is part of Onore RolePlay.

  Copyright (c) Onore RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@class Supermarket
---@field public id number
---@field public blipId number
---@field public zoneId number
---@field public vendor Npc
Supermarket = {}
Supermarket.__index = Supermarket

setmetatable(Supermarket, {
    __call = function(_, infos, id)
        local self = setmetatable({}, Supermarket)
        self.id = id
        self:init(infos)
        return self
    end
})

---initBlip
---@public
---@return void
function Supermarket:init(infos)
    self.blipId = OnoreSBlipsManager.createPublic(infos.loc, 59, 24, 1.0, "LTD 24h/7", true)
    self.vendor = OnoreSNpcsManager.createPublic("mp_m_shopkeep_01", false, true, {coords = infos.npc, heading = infos.npcHeading}, "WORLD_HUMAN_CLIPBOARD", nil)
    self.vendor:setInvincible(true)
    self.vendor:setDisplayInfos({name = "[Vendeur] Apu Mahal", range = 5.5, color = 55})
    self.zoneId = OnoreSZonesManager.createPublic(infos.loc, 22, {r = 158, g = 245, b = 66, a = 255}, function(source)
        self.vendor:playSpeech("GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
        self:openMenu(source)
    end, "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu de la superette", 20.0, 1.0)
end

---openMenu
---@public
---@return void
function Supermarket:openMenu(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local moneys = {cash = xPlayer.getMoney(), bank = xPlayer.getAccount("bank").money}
    OnoreServerUtils.toClient("openSupermarketMenu", source, moneys, OnoreSCache.getCache("shopspromo"), OnoreSCache.getCache("shopsitems"))
end

