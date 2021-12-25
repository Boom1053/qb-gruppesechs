local QBCore = exports['qb-core']:GetCoreObject()
local playerJob = nil
local gruppesechsVehicle = nil
local hasBag = false
local currentStop = 0
local deliveryBlip = nil
local isWorking = false
local amountOfBags = 0
local gruppesechsObject = nil
local endBlip = nil
local gruppesechsBlip = nil
local canTakeBag = true
local currentStopNum = 0
local payCoords = vector3(Config.Locations["paycheck"].coords.x, Config.Locations["paycheck"].coords.y, Config.Locations["paycheck"].coords.z)
local vehCoords = vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)

-- Handlers

local function setupClient()
    gruppesechsVehicle = nil
    hasBag = false
    currentStop = 0
    deliveryBlip = nil
    isWorking = false
    amountOfBags = 0
    gruppesechsObject = nil
    endBlip = nil
    currentStopNum = 0
    if playerJob.name == "gruppesechs" then
        gruppesechsBlip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
        SetBlipSprite(gruppesechsBlip, 67)
        SetBlipDisplay(gruppesechsBlip, 4)
        SetBlipScale(gruppesechsBlip, 0.8)
        SetBlipAsShortRange(gruppesechsBlip, true)
        SetBlipColour(gruppesechsBlip, 69)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
        EndTextCommandSetBlipName(gruppesechsBlip)
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerJob = QBCore.Functions.GetPlayerData().job
    setupClient()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    playerJob = JobInfo
    if playerJob.name == "gruppesechs" then
        if gruppesechsBlip ~= nil then
            RemoveBlip(gruppesechsBlip)
        end
    end
    setupClient()
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        if gruppesechsObject ~= nil then
            DeleteEntity(gruppesechsObject)
            gruppesechsObject = nil
        end
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        playerJob = QBCore.Functions.GetPlayerData().job
        setupClient()
    end
end)

-- Functions

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function DrawText3D2(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x,coords.y,coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function LoadAnimation(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Wait(10) end
end

local function BringBackCar()
    local veh = GetVehiclePedIsIn(PlayerPedId())
    DeleteVehicle(veh)
    if endBlip ~= nil then
        RemoveBlip(endBlip)
    end
    if deliveryBlip ~= nil then
        RemoveBlip(deliveryBlip)
    end
    gruppesechsVehicle = nil
    hasBag = false
    currentStop = 0
    deliveryBlip = nil
    isWorking = false
    amountOfBags = 0
    gruppesechsObject = nil
    endBlip = nil
    currentStopNum = 0
end

local function SetRouteBack()
    local inleverpunt = Config.Locations["vehicle"]
    endBlip = AddBlipForCoord(inleverpunt.coords.x, inleverpunt.coords.y, inleverpunt.coords.z)
    exports['qb-target']:RemoveZone('banks')
    SetBlipSprite(endBlip, 1)
    SetBlipDisplay(endBlip, 2)
    SetBlipScale(endBlip, 1.0)
    SetBlipAsShortRange(endBlip, false)
    SetBlipColour(endBlip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations["vehicle"].name)
    EndTextCommandSetBlipName(endBlip)
    SetBlipRoute(endBlip, true)
end

local function AnimCheck()
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            if hasBag then
                if not IsEntityPlayingAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
                    ClearPedTasksImmediately(ped)
                    LoadAnimation('missfbi4prepp1')
                    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                end
            else
                break
            end
            Wait(200)
        end
    end)
end

local function TakeAnim()
    local ped = PlayerPedId()
    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    gruppesechsObject = CreateObject(`prop_money_bag_01`, 0, 0, 0, true, true, true)
    AttachEntityToEntity(gruppesechsObject, ped, GetPedBoneIndex(ped, 57005), 0.38, -0.3, -0.2, 220.0, 120.0, 0.0, true, true, false, true, 1, true)
    AnimCheck()
end

local function DeliverAnim()
    local ped = PlayerPedId()
    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, GetEntityHeading(gruppesechsVehicle))
    canTakeBag = false
    SetTimeout(1250, function()
        DetachEntity(gruppesechsObject, 1, false)
        DeleteObject(gruppesechsObject)
        TaskPlayAnim(ped, 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
        FreezeEntityPosition(ped, false)
        gruppesechsObject = nil
        canTakeBag = true
    end)
end

local function SetGruppeSechsRoute()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local CurrentLocation = Config.Locations["banks"][currentStop]
    if deliveryBlip ~= nil then
        RemoveBlip(deliveryBlip)
    end
    exports['qb-target']:AddBoxZone("banks", vector3(CurrentLocation.pz), CurrentLocation.length, CurrentLocation.width, {
        name = "banks",
        heading = CurrentLocation.heading,
        debugPoly = false,
        minZ = CurrentLocation.minZ,
        maxZ = CurrentLocation.maxZ,
        }, {
            options = {
                {
                    type = "client",
                    event = "gruppesechs:takeBag",
                    icon = "fas fa-sign-in-alt",
                    label = "Get bag",
                    job = "gruppesechs",
                },
            },
            distance = 2.5
    })
    deliveryBlip = AddBlipForCoord(CurrentLocation.coords.x, CurrentLocation.coords.y, CurrentLocation.coords.z)
    SetBlipSprite(deliveryBlip, 1)
    SetBlipDisplay(deliveryBlip, 2)
    SetBlipScale(deliveryBlip, 1.0)
    SetBlipAsShortRange(deliveryBlip, false)
    SetBlipColour(deliveryBlip, 27)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations["banks"][currentStop].name)
    EndTextCommandSetBlipName(deliveryBlip)
    SetBlipRoute(deliveryBlip, true)
end

RegisterNetEvent('gruppesechs:takeBag', function()
    if currentStop ~= 0 and deliveryBlip ~= nil then
        if not hasBag and canTakeBag then
            hasBag = true
            TakeAnim()
        end
    else
        QBCore.Functions.Notify("Go clock in to collect money.", 'error')
    end
end)

RegisterNetEvent('gruppesechs:putBagTruck', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if hasBag then
        LoadAnimation('missfbi4prepp1')
        if DoesEntityExist(gruppesechsVehicle) then
            QBCore.Functions.Progressbar("deliverbag", "Putting bag in truck ..", 2000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                hasBag = false
                -- Looks if you have delivered all bags
                if (amountOfBags - 1) == 0 then
                    QBCore.Functions.TriggerCallback('gruppesechs:server:NextStop', function(hasMoreStops, nextStop, newBagAmount)
                        if hasMoreStops and nextStop ~= 0 then
                            -- Here he puts your next location and you are not finished working yet.
                            currentStop = nextStop
                            currentStopNum = currentStopNum + 1
                            amountOfBags = newBagAmount
                            SetGruppeSechsRoute()
                            QBCore.Functions.Notify("All bags are done, proceed to the next location!")
                        else
                            if hasMoreStops and nextStop == currentStop then
                                QBCore.Functions.Notify("There was an issue at the depot, please return immediately!")
                                amountOfBags = 0
                            else
                                -- You are done with work here.
                                QBCore.Functions.Notify("You are done working! Go back to the depot.")
                                isWorking = false
                                RemoveBlip(deliveryBlip)
                                SetRouteBack()
                                amountOfBags = 0
                            end
                        end
                    end, currentStop, currentStopNum, pos)
                    hasBag = false
                else
                    -- You haven't delivered all bags here
                    amountOfBags = amountOfBags - 1
                    if amountOfBags > 1 then
                        QBCore.Functions.Notify("There are still "..amountOfBags.." bags left!")
                    else
                        QBCore.Functions.Notify("There is still "..amountOfBags.." bags over there!")
                    end
                    hasBag = false
                end

                DeliverAnim()
            end, function() -- Cancel
                QBCore.Functions.Notify("Canceled", "error")
            end)
        else
            QBCore.Functions.Notify("You have no truck", "error")
            print("You no longer have a truck, contact an admin!")
            DeliverAnim()
            hasBag = false
        end
    else
        QBCore.Functions.Notify("You don\'t have bag..", "error")
    end
end)

-- Events

RegisterNetEvent('gruppesechs:client:SetWaypointHome', function()
    SetNewWaypoint(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y)
end)

RegisterNetEvent('gruppesechs:paySlip', function()
    TriggerServerEvent('gruppesechs:server:PayShift')
end)

RegisterNetEvent('gruppesechs:putTruck', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    if vehicle then
        local plate = GetVehicleNumberPlateText(vehicle)
        if plate and string.match(plate, "SECHS") then
            TriggerServerEvent("gruppesechs:server:PayShift")
            QBCore.Functions.DeleteVehicle(vehicle)
        else
            QBCore.Functions.Notify("This is not a fleet vehicle", "error")
        end
    end
end)

RegisterNetEvent('gruppesechs:getTruck', function()
    QBCore.Functions.TriggerCallback('gruppesechs:server:NewShift', function(shouldContinue, firstStop, totalBags)
        if shouldContinue then

            local coords = Config.Locations["vehicle"].coords
            QBCore.Functions.SpawnVehicle("stockade", function(veh)
                TaskWarpPedIntoVehicle(ped, veh, -1) -- hopefully this fixes an issue if something is delayed they'll get crushed
                SetVehicleEngineOn(veh, true, true)
                gruppesechsVehicle = veh
                NetworkRegisterEntityAsNetworked(gruppesechsVehicle)
                SetVehicleNumberPlateText(veh, "SECHS"..tostring(math.random(1000, 9999)))
                SetEntityHeading(veh, coords.w)
                exports['lj-fuel']:SetFuel(veh, 100.0)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
                exports['qb-target']:AddTargetEntity(gruppesechsVehicle, {
                    options = {
                        {
                            type = "client",
                            event = "gruppesechs:putBagTruck",
                            icon = "fas fa-sign-in-alt",
                            label = "Put bag in truck",
                            job = "gruppesechs",
                        },
                    },
                    distance = 3.0
                })
                currentStop = firstStop
                currentStopNum = 1
                amountOfBags = totalBags
                isWorking = true
                exports['qb-target']:RemoveZone('banks')
                SetGruppeSechsRoute()
                QBCore.Functions.Notify("You have $"..Config.TruckPrice..", deposit paid!")
                QBCore.Functions.Notify("You have started working, location marked on GPS!")
                Wait(10)
            end, coords, true)
        else
            QBCore.Functions.Notify("You have not enough money for the deposit.. Deposit costs are $"..Config.TruckPrice)
        end
    end)
end)

RegisterNetEvent('gruppesechs:returnTruck')
AddEventHandler('gruppesechs:returnTruck', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local distance = #(pos - vehCoords)
    local InVehicle = IsPedInAnyVehicle(ped, false)
    if distance < 7.5 then
        if InVehicle then
            QBCore.Functions.TriggerCallback('gruppesechs:server:EndShift', function(endShift)
                if endShift then
                    BringBackCar()
                    QBCore.Functions.Notify("Truck returned, collect your payslip to recieve your pay and deposit back!")
                else
                    QBCore.Functions.Notify("You have no deposit paid on this vehicle..")
                    currentStopNum = 0
                    currentStop = 0
                end
            end, pos)
        end
    end
end)