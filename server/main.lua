local QBCore = exports['qb-core']:GetCoreObject()
local Routes = {}

QBCore.Functions.CreateCallback("gruppesechs:server:NewShift", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    local shouldContinue = false
    local nextStop = 0
    local totalNumberOfStops = 0
    local bagNum = 0

    if Player.Functions.RemoveMoney("bank", Config.TruckPrice, "gruppesechs-truck-dep") then
        math.randomseed(os.time())
        local MaxStops = math.random(Config.MinStops, #Config.Locations["banks"])
        local allStops = {}

        for i=1, MaxStops do
            local stop = math.random(1,#Config.Locations["banks"])
            local newBagAmount = math.random(Config.MinBagsPerStop, Config.MaxBagsPerStop)
            allStops[#allStops+1] = {stop = stop, bags = newBagAmount}
        end

        Routes[CitizenId] = {
            stops = allStops,
            currentStop = 1,
            started = true,
            currentDistance = 0,
            depositPay = Config.TruckPrice,
            actualPay = 0,
            stopsCompleted = 0,
            totalNumberOfStops = #allStops
        }

        nextStop = allStops[1].stop
        shouldContinue = true
        totalNumberOfStops = #allStops
        bagNum = allStops[1].bags
    else
        TriggerClientEvent('QBCore:Notify', source, 'Not Enough Money ('..Config.TruckPrice..' required)', "error")
    end
    cb(shouldContinue, nextStop, bagNum, totalNumberOfStops)
end)

QBCore.Functions.CreateCallback("gruppesechs:server:NextStop", function(source, cb, currentStop, currentStopNum, currLocation)
    local Player = QBCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    local currStopCoords = Config.Locations["banks"][currentStop].coords
    currStopCoords = vector3(currStopCoords.x, currStopCoords.y, currStopCoords.z)

    local distance = #(currLocation - currStopCoords)
    local newStop = 0
    local shouldContinue = false
    local newBagAmount = 0

    if(math.random(100) >= Config.SecurityCardChance) and Config.GiveSecurityCardChance then
        local sc = 'security_card_0'..math.random(1,2)
        Player.Functions.AddItem(sc, 1, false)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[sc], 'add')
        TriggerClientEvent('QBCore:Notify', source, "You found a security card on the floor")
    end

    if distance <= 50 then
        if currentStopNum >= #Routes[CitizenId].stops then
            Routes[CitizenId].stopsCompleted = tonumber(Routes[CitizenId].stopsCompleted) + 1
            newStop = currentStop
        else
            newStop = Routes[CitizenId].stops[currentStopNum+1].stop
            newBagAmount = Routes[CitizenId].stops[currentStopNum+1].bags
            shouldContinue = true
            local bagAmount = Routes[CitizenId].stops[currentStopNum].bags
            local totalNewPay = 0

            for i = 1, bagAmount do
                totalNewPay = totalNewPay + math.random(Config.BagLowerWorth, Config.BagUpperWorth)
            end

            Routes[CitizenId].actualPay = math.ceil(Routes[CitizenId].actualPay + totalNewPay)
            Routes[CitizenId].stopsCompleted = tonumber(Routes[CitizenId].stopsCompleted) + 1
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'You are too far away from the drop-off point', "error")
    end

    cb(shouldContinue,newStop,newBagAmount)
end)

QBCore.Functions.CreateCallback('gruppesechs:server:EndShift', function(source, cb, location)
    local Player = QBCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid
    local distance = #(location - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z))

    if(distance < 50) then
        if Routes[CitizenId] ~= nil then
            cb(true)
        else
            cb(false)
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'You are too far away from the dropoff point', "error")
        cb(false)
    end
end)

RegisterNetEvent('gruppesechs:server:PayShift', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    if Routes[CitizenId] ~= nil then
        local depositPay = Routes[CitizenId].depositPay
        --[[if tonumber(Routes[CitizenId].stopsCompleted) < tonumber(Routes[CitizenId].totalNumberOfStops) then
            -- local totalComplete = math.floor((Routes[CitizenId].stopsCompleted/Routes[CitizenId].totalNumberOfStops) * 100)
            -- depositPay = math.ceil((totalComplete/Routes[CitizenId].depositPay) * 100)
            depositPay = 0
            TriggerClientEvent('QBCore:Notify', src, "Due to early finish (Completed: "..Routes[CitizenId].stopsCompleted .." Total: "..Routes[CitizenId].totalNumberOfStops.."), your deposit will not be returned.", "error")
        end]]

        local totalToPay = depositPay + Routes[CitizenId].actualPay
        local payoutDeposit = "(+ $"..depositPay.." deposit)"
        if depositPay == 0 then
            payoutDeposit = ""
        end

        Player.Functions.AddMoney("bank", totalToPay , 'gruppesechs-payslip')
        TriggerClientEvent('QBCore:Notify', src, "You got $"..totalToPay..", your payslip "..payoutDeposit.." got paid to your bank account!", "success")
        Routes[CitizenId] = nil
    else
        TriggerClientEvent('QBCore:Notify', source, 'You never clocked in!', "error")
    end
end)

QBCore.Commands.Add("clearsechroutes", "Removes gruppe sechs routes for user (admin only)", {{name="id", help="Player ID (may be empty)"}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local CitizenId = Player.PlayerData.citizenid
    local count = 0
    for k,v in pairs(Routes) do
        if k == CitizenId then
            count = count + 1
        end
    end

    TriggerClientEvent('QBCore:Notify', source, "Cleared users routes they had "..count.." routes stored", "success")
    Routes[CitizenId] = nil
end, "admin")
