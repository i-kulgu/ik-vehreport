local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ik-vehreports:server:SendReceiptForConfirm', function(pid, price, mods)
    local target = tonumber(pid)
    local targetprice = tonumber(price)
    local Player = QBCore.Functions.GetPlayer(source)
    local OtherPlayer = QBCore.Functions.GetPlayer(target)
    local cashmoney = OtherPlayer.Functions.GetMoney('cash')
    local bankmoney = OtherPlayer.Functions.GetMoney('bank')
    local sendername = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    if Config.SendMoneyToFunds then
        Funds = exports['qb-management']:GetAccount(Player.PlayerData.job.name)
        if Funds ~= 0 then Funds = Player.PlayerData.job.name else Funds = 'N/A' end
    end
    if bankmoney >= targetprice then
        Account = 'bank'
    elseif cashmoney >= targetprice then
        Account = 'cash'
    end
    TriggerClientEvent('ik-vehcontrol:client:ReceiveReceiptConfirm', pid, targetprice, Account, sendername, Funds, mods)
end)

RegisterNetEvent('ik-vehreports:server:PayForReceipt', function(account, price, funds, mods)
    local info = {
        vehname = mods.vehname,
        plate = mods.plate,
        engine = mods.engine,
        brakes = mods.brakes,
        suspension = mods.suspension,
        turbo = mods.turbo,
        transmission = mods.transmission,
        armor = mods.armor,
        nos = mods.nos
    }
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney(account, price) then
        Player.Functions.AddItem(Config.InspectionItemName, 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.InspectionItemName], "add")
    end
    if funds ~= "N/A" then
        exports['qb-management']:AddMoney(funds, price)
    end
    
end)

QBCore.Functions.CreateCallback('ik-vehreports:server:IsVehicleOwnedByPlayer', function(_, cb, plate)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', { plate }, function(result)
        if result[1] then cb(true) else cb(false) end
    end)
end)

QBCore.Functions.CreateCallback('ik-vehreports:server:GetNearbyPlayers', function(source, cb)
    local src = source
    local players = {}
    local PlayerPed = GetPlayerPed(src)
    local pCoords = GetEntityCoords(PlayerPed)
    for _, v in ipairs(QBCore.Functions.GetPlayers()) do
        local targetped = GetPlayerPed(v)
        local tCoords = GetEntityCoords(targetped)
        local dist = #(pCoords - tCoords)
        if v ~= src then
            if dist <= Config.NearByListRadius then
                local ped = QBCore.Functions.GetPlayer(v)
                players[#players+1] = {
                    id = v,
                    name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname,
                    dist = '('..math.floor(dist+0.05)..'m)'
                }
            end
        end
    end
    cb(players)
end)

QBCore.Functions.CreateUseableItem(Config.InspectionItemName , function(source, item)
    local src = source
    local vehname = item.info.vehname
    local plate = item.info.plate
    local engine = item.info.engine
    local brakes = item.info.brakes
    local suspension = item.info.suspension
    local turbo = item.info.turbo
    local transmission = item.info.transmission
    local armor = item.info.armor
    local nos = item.info.nos
    local Mods = {}
    if nos then
        Mods = {vehname = vehname, plate = plate, engine = engine, brakes = brakes, transmission = transmission, suspension = suspension, armor = armor, turbo= turbo, nos = nos}
    else
        Mods = {vehname = vehname, plate = plate, engine = engine, brakes = brakes, transmission = transmission, suspension = suspension, armor = armor, turbo= turbo}
    end
    TriggerClientEvent('ik-vehreports:client:showReport',src, Mods)
end)