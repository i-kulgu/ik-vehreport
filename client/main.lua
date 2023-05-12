local QBCore = exports['qb-core']:GetCoreObject()
local VehName = nil
local LastVeh = nil

local function GetVehicleName(vehicle)
    if LastVeh ~= vehicle and not VehName then
        LastVeh = vehicle
        VehName = nil
        for k, v in pairs(QBCore.Shared.Vehicles) do
			if tonumber(v.hash) == GetEntityModel(vehicle) then
			    VehName = QBCore.Shared.Vehicles[k].name
			end
		end
        if not VehName then VehName = string.upper(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) end
        return VehName
    else return VehName end
end

local function CheckMod(vehicle, mod, toggle)
    if not toggle then
        if GetNumVehicleMods(vehicle,mod) ~= 0 then
            if GetVehicleMod(vehicle, mod) == -1 then return "STOCK"
            else return "LVL: "..(GetVehicleMod(vehicle, mod)+1) end
        else return "N/A" end
    else
        if IsToggleModOn(vehicle, mod) then return "YES"
        elseif not IsToggleModOn(vehicle, mod) and GetNumVehicleMods(vehicle, 11) ~= 0 then return "NO"
        else return "N/A" end
    end
end

local function IsPlayerOwnedVehicle(plate)
    local p = promise.new()
	QBCore.Functions.TriggerCallback('ik-vehreports:server:IsVehicleOwnedByPlayer', function(cb) p:resolve(cb) end, plate)
    return Citizen.Await(p)
end


RegisterNetEvent("ik-vehreports:client:inspectVehicle", function(vehicle)
    if not DoesEntityExist(vehicle) then return end
    local vehicleName = GetVehicleName(vehicle)
    local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1')
    if not IsPlayerOwnedVehicle(plate) then QBCore.Functions.Notify('This vehicle is not owned by anyone!', 'error', 4500) return end
    local engine = CheckMod(vehicle, 11, false)
    local brakes = CheckMod(vehicle, 12, false)
    local transmission = CheckMod(vehicle, 13, false)
    local suspension = CheckMod(vehicle, 15, false)
    local armor = CheckMod(vehicle, 15, false)
    local turbo = CheckMod(vehicle, 18, true)
    local Mods = {vehname = vehicleName, plate = plate, engine = engine, brakes = brakes, transmission = transmission, suspension = suspension, armor = armor, turbo= turbo}

    SendNuiMessage({
        action = "show",
        mods = Mods
    })
    SetNuiFocus(true, true)
end)

exports['qb-target']:AddGlobalVehicle({
    options = {
      {
        type = "client",
        icon = 'fas fa-magnifying-glass-chart',
        label = 'Inspect Vehicle',
        action = function(entity)
            if not IsEntityAVehicle(entity) then return false end
            TriggerEvent("ik-vehreports:client:inspectVehicle", entity)
        end,
        jobType = {'leo', 'mechanic'},
      }
    },
    distance = 2.5,
})

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)