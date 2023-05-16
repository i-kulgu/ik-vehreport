local QBCore = exports['qb-core']:GetCoreObject()
local VehName = nil
local LastVeh = nil
local PlayerJob = {}

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
            if GetVehicleMod(vehicle, mod) == -1 then return 'STOCK'
            else return 'LVL: '..(GetVehicleMod(vehicle, mod)+1) end
        else return 'N/A' end
    else
        if IsToggleModOn(vehicle, mod) then return 'YES'
        elseif not IsToggleModOn(vehicle, mod) and GetNumVehicleMods(vehicle, 11) ~= 0 then return 'NO'
        else return 'N/A' end
    end
end

local function IsPlayerOwnedVehicle(plate)
    local p = promise.new()
        QBCore.Functions.TriggerCallback('ik-vehreports:server:IsVehicleOwnedByPlayer', function(cb) p:resolve(cb) end, plate)
    return Citizen.Await(p)
end

local function ClearProps(playerPed)
    ClearPedTasks(playerPed)
    for _, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(playerPed, v) then
            DeleteObject(v)
            DetachEntity(v, 0, 0)
            SetEntityAsMissionEntity(v, true, true)
            Wait(100)
            DeleteEntity(v)
        end
    end
end

local function TurnFaceToEntity(vehicle)
    if DoesEntityExist(vehicle) then
        if not IsPedHeadingTowardsPosition(PlayerPedId(), GetEntityCoords(vehicle), 30.0) then
            TaskTurnPedToFaceCoord(PlayerPedId(), GetEntityCoords(vehicle), 1500)
            Wait(1500)
        end
    end
end

local function HasNitro(plate)
    local p = promise.new() QBCore.Functions.TriggerCallback('jim-mechanic:GetNosLoaded', function(cb) p:resolve(cb) end) local VehicleNitrous = Citizen.Await(p)
    if VehicleNitrous[plate] then
        if VehicleNitrous[plate].hasnitro == '1' then return 'YES' else return 'NO' end
    end
end

local function HasAllowedJob()
    local isAllowed = false
    for i=1, #Config.AllowedJobs do
        if Config.AllowedJobs[i] == PlayerJob then
            isAllowed = true
        end
    end
    return isAllowed
end

RegisterNetEvent('ik-vehreports:client:inspectVehicle', function(vehicle)
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
    local Mods = {}
    local job = 'false'
    if Config.ShowNos then
        local nos = HasNitro(plate)
        Mods = {vehname = vehicleName, plate = plate, engine = engine, brakes = brakes, transmission = transmission, suspension = suspension, armor = armor, turbo= turbo, nos = nos}
    else
        Mods = {vehname = vehicleName, plate = plate, engine = engine, brakes = brakes, transmission = transmission, suspension = suspension, armor = armor, turbo= turbo}
    end
    if Config.JobsOnly and HasAllowedJob() then job = 'true' end

    TurnFaceToEntity(vehicle)
    QBCore.Functions.Progressbar('drink_something', 'Inspecting vehicle...', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = false, },
    { animDict = 'anim@amb@board_room@whiteboard@', anim = 'think_01_amy_skater_01', flags = 8, },
    {}, {}, function()
        ClearProps(PlayerPedId())
        TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_CLIPBOARD', 0, true)
        SendNUIMessage({
            action = 'show',
            mods = Mods,
            job = job
        })
        SetNuiFocus(true, true)
    end, function() -- Cancel
        ClearProps(PlayerPedId())
    end)
end)

exports['qb-target']:AddGlobalVehicle({
    options = {
      {
        type = 'client',
        icon = 'fas fa-magnifying-glass-chart',
        label = 'Inspect Vehicle',
        action = function(entity)
            if not IsEntityAVehicle(entity) then return false end
            if Config.JobsOnly and not HasAllowedJob() then return false end
            TriggerEvent('ik-vehreports:client:inspectVehicle', entity)
        end,
      }
    },
    distance = 2.5,
})

RegisterNUICallback('GetNearPlayers',function()
    local NearbyPlayers = {}
    QBCore.Functions.TriggerCallback('ik-vehreports:server:GetNearbyPlayers', function(players)
        if players then
            for _,v in ipairs(players) do
                NearbyPlayers[#NearbyPlayers+1] = {name = v.name..' '..v.dist ,ped = v.id, text = v.dist}
            end
            SendNUIMessage({
                    action = 'NearPlayers',
                    players = NearbyPlayers,
                })
        else
            QBCore.Functions.Notify('There is no nearby player', 'error')
        end
    end)
end)

RegisterNUICallback('sendreceipt', function(data)
    local pid = data.player
    TriggerServerEvent('ik-vehreports:server:GiveReceipt', pid)
end)

RegisterNUICallback('close', function()
    ClearProps(PlayerPedId())
    SetNuiFocus(false, false)
end)



AddEventHandler('QBCore:Client:OnPlayerLoaded', function() local player = QBCore.Functions.GetPlayerData() PlayerJob = player.job end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo end)