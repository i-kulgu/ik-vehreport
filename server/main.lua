local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("ik-vehreports:server:IsVehicleOwnedByPlayer", function(_, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', { plate }, function(result)
        if result[1] then cb(true) else cb(false) end
	end)
end)