local QBCore = exports['qb-core']:GetCoreObject()

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