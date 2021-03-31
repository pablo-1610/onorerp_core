Job = nil
Jobs = {}
Jobs.list = {}

local avaibleJobs = {
    "realestateagent"
}

for k,v in pairs(avaibleJobs) do
    Jobs.list[v] = {}
end

AddEventHandler("onore_esxloaded", function()
    Citizen.CreateThread(function()
        while true do
            if Jobs.list[Job.name] ~= nil and Jobs.list[Job.name].openMenu ~= nil then
                if IsControlJustPressed(0, 167) then
                    Jobs.list[Job.name].openMenu()
                end
            end
            Wait(1)
        end
    end)
end)