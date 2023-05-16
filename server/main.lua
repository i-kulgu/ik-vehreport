local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ik-vehreports:server:SendReceiptForConfirm', function(pid, price)
    local Player = QBCore.Functions.GetPlayer(source)
    local OtherPlayer = QBCore.Functions.GetPlayer(pid)
    local cashmoney = OtherPlayer.Functions.GetMoney('cash')
    local bankmoney = OtherPlayer.Functions.GetMoney('bank')
    local sendername = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    if Config.SendMoneyToFunds then
        Funds = exports['qb-management']:GetAccount(Player.PlayerData.job.name)
        if Funds ~= 0 then Funds = Player.PlayerData.job.name else Funds = 'N/A' end
    end
    if bankmoney >= price then
        Account = 'bank'
    elseif cashmoney >= price then
        Account = 'cash'
    end
    TriggerClientEvent('ik-vehcontrol:client:ReceiveReceiptConfirm', pid, price, Account, sendername, Funds)
end)

RegisterNetEvent('ik-vehreports:server:PayForReceipt', function(account, price, funds)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveMoney(account, price)
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