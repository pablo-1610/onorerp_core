local menuIsOpened, cat = false, "realestateagent"
local sub = function(str) return cat.."_"..str  end
Jobs.list["realestateagent"].openMenu = function()
    if menuIsOpened then return end
    menuIsOpened = true
    RMenu.Add(cat, sub("main"), RageUI.CreateMenu(nil, "~g~Menu des interactions", nil, nil, "root_cause", "shopui_title_dynasty8"))
    RageUI.Visible(RMenu:Get(cat, sub("main")), true)
    Citizen.CreateThread(function()
        while menuIsOpened and Job.name:lower() == cat do
            local shouldStayOpened = false
            local function tick() shouldStayOpened = true  end
            RageUI.IsVisible(RMenu:Get(cat, sub("main")), true, true, true, function()
                tick()
            end, function()
            end)
            if not shouldStayOpened and menuIsOpened then
                menuIsOpened = false
            end
            Wait(0)
        end
        RMenu:Delete(cat, sub("main"))
    end)
end