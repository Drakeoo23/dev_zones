local QBCore = exports['qb-core']:GetCoreObject()

local stress = 0
local inZone = false
local Stressed = false

Citizen.CreateThread(function()
    while not QBCore.Functions.GetPlayerData().job do
        Wait(500)
    end

    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local msec = 2000
        PlayerData = QBCore.Functions.GetPlayerData()
        stress = tonumber(PlayerData.metadata['stress'])


        if inZone == false then
            for k,v in pairs(Config.Zones) do
                if #(v.coords - coords) < v.radius then
                    inZone = true
                    EnterInZone(v)
                end
            end
        end

        if stress >= 80 then
            Stressed = true
            IsStressed()
        else
            Stressed = false
        end
        Citizen.Wait(msec)
    end
end)

function EnterInZone(data)
    Citizen.CreateThread(function()
        print("zonas")
        QBCore.Functions.Notify('Has entrado en una zona chill, poco a poco te sentirás más relajado.', 'success', 6000)
        while true do
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            if #(data.coords - coords) > data.radius then
                inZone = false
                break
            end

            if data.zone == 'chill' then
                TriggerServerEvent('hud:server:RelieveStress', math.random(1, 2))
            end
            Wait(20 * 1000)
        end
    end)
end

function IsStressed()
    Citizen.CreateThread(function()
        while true do
            local wait = 1000
            local playerPed = PlayerPedId()

            if Stressed then
                wait = 0
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 244, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 45, true)
                DisableControlAction(0, 24, true)
                if IsPedMale(playerPed) then
                    RequestAnimSet("move_m@depressed@a")

                    while not HasAnimSetLoaded("move_m@depressed@a") do
                        Citizen.Wait(1)
                    end
                    SetPedMovementClipset(playerPed, "move_m@depressed@a", true)
                else
                    RequestAnimSet("move_f@depressed@a")

                    while not HasAnimSetLoaded("move_f@depressed@a") do
                        Citizen.Wait(1)
                    end
                    SetPedMovementClipset(playerPed, "move_f@depressed@a", true)
                end
            else
                ResetPedMovementClipset(playerPed, 0)
                break
            end
            Citizen.Wait(wait)
        end
    end)
end
