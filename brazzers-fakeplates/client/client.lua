local QBCore = exports[Config.Core]:GetCoreObject()
local hasFakePlate = false

-- Función para generar placas aleatorias (8 caracteres alfanuméricos)
local function GenerateFakePlate()
    local charset = {}
    for i = 48, 57 do table.insert(charset, string.char(i)) end  -- 0-9
    for i = 65, 90 do table.insert(charset, string.char(i)) end  -- A-Z

    local plate = ""
    for i = 1, 8 do
        plate = plate .. charset[math.random(1, #charset)]
    end
    return plate
end

-- Net Events

RegisterNetEvent('brazzers-fakeplates:client:usePlate', function(plate)
    if not plate then return end

    if hasFakePlate then
        lib.notify({
            title = Config.Notifications.AlreadyFake.title,
            description = Config.Notifications.AlreadyFake.description,
            type = Config.Notifications.AlreadyFake.type
        })
        return
    end

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    local vehicleCoords = GetEntityCoords(vehicle)
    local dist = #(vehicleCoords - pedCoords)
    local hasKeys = false

    if dist <= 5.0 then
        local currentPlate = QBCore.Functions.GetPlate(vehicle)
        if exports[Config.Keys]:HasKeys(currentPlate) then
            hasKeys = true
        end

        TaskTurnPedToFaceEntity(ped, vehicle, 3.0)

        QBCore.Functions.Progressbar(
            Config.ProgressBar.Install.name,
            Config.ProgressBar.Install.label,
            Config.ProgressBar.Install.duration,
            false,
            true,
            Config.ProgressBar.Install.controlDisables,
            Config.ProgressBar.Install.animation,
            {},
            {},
            function()
                TriggerServerEvent('brazzers-fakeplates:server:usePlate', VehToNet(vehicle), currentPlate, plate, hasKeys)
                ClearPedTasks(ped)
                lib.notify({
                    title = Config.Notifications.Install.title,
                    description = Config.Notifications.Install.description,
                    type = Config.Notifications.Install.type
                })
            end,
            function()
                ClearPedTasks(ped)
            end
        )
    end
end)

RegisterNetEvent('brazzers-fakeplates:client:removePlate', function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    local vehicleCoords = GetEntityCoords(vehicle)
    local dist = #(vehicleCoords - pedCoords)
    local hasKeys = false

    if dist <= 5.0 then
        local currentPlate = QBCore.Functions.GetPlate(vehicle)
        if exports[Config.Keys]:HasKeys(currentPlate) then
            hasKeys = true
        end

        TaskTurnPedToFaceEntity(ped, vehicle, 3.0)

        QBCore.Functions.Progressbar(
            Config.ProgressBar.Remove.name,
            Config.ProgressBar.Remove.label,
            Config.ProgressBar.Remove.duration,
            false,
            true,
            Config.ProgressBar.Remove.controlDisables,
            Config.ProgressBar.Remove.animation,
            {},
            {},
            function()
                TriggerServerEvent('brazzers-fakeplates:server:removePlate', VehToNet(vehicle), currentPlate, hasKeys)
                ClearPedTasks(ped)
                lib.notify({
                    title = Config.Notifications.Remove.title,
                    description = Config.Notifications.Remove.description,
                    type = Config.Notifications.Remove.type
                })
            end,
            function()
                ClearPedTasks(ped)
            end
        )
    end
end)

-- Threads

CreateThread(function()
    while true do
        Wait(1000)
        local inRange = false
        local pos = GetEntityCoords(PlayerPedId())
        local vehicle = QBCore.Functions.GetClosestVehicle()
        local vehCoords = GetEntityCoords(vehicle)
        local closestPlate = QBCore.Functions.GetPlate(vehicle)

        if exports[Config.Keys]:HasKeys(closestPlate) then
            if not IsPedInAnyVehicle(PlayerPedId()) then
                if #(pos - vehCoords) < 7.0 then
                    inRange = true
                    QBCore.Functions.TriggerCallback('brazzers-fakeplates:server:checkPlateStatus', function(result)
                        hasFakePlate = result
                    end, closestPlate)
                end
            end
        end

        if not inRange then
            Wait(3000)
        end
    end
end)

-- Target Options

CreateThread(function()
    local bones = { 'boot' }

    if Config.Target == "ox_target" then
        exports.ox_target:addGlobalVehicle({
            {
                label = Config.TargetOptions.Install.label,
                icon = Config.TargetOptions.Install.icon,
                bones = bones,
                distance = 2.5,
                canInteract = function(entity, distance, coords, bone)
                    local plate = QBCore.Functions.GetPlate(entity)
                    return exports[Config.Keys]:HasKeys(plate) and not hasFakePlate
                end,
                onSelect = function(data)
                    local count = exports.ox_inventory:Search('count', Config.FakePlateItem)
                    if count and count > 0 then
                        TriggerEvent('brazzers-fakeplates:client:usePlate', GenerateFakePlate())
                    else
                        lib.notify({
                            title = Config.Notifications.NoItem.title,
                            description = Config.Notifications.NoItem.description,
                            type = Config.Notifications.NoItem.type
                        })
                    end
                end
            },
            {
                label = Config.TargetOptions.Remove.label,
                icon = Config.TargetOptions.Remove.icon,
                bones = bones,
                distance = 2.5,
                canInteract = function(entity, distance, coords, bone)
                    local plate = QBCore.Functions.GetPlate(entity)
                    return exports[Config.Keys]:HasKeys(plate) and hasFakePlate
                end,
                onSelect = function(data)
                    TriggerEvent('brazzers-fakeplates:client:removePlate')
                end
            }
        })
    else
        exports[Config.Target]:AddTargetBone(bones, {
            options = {
                {
                    type = 'client',
                    event = 'brazzers-fakeplates:client:usePlate',
                    icon = Config.TargetOptions.Install.icon,
                    label = Config.TargetOptions.Install.label,
                    item = Config.FakePlateItem,
                    canInteract = function()
                        return not hasFakePlate
                    end
                },
                {
                    type = 'client',
                    event = 'brazzers-fakeplates:client:removePlate',
                    icon = Config.TargetOptions.Remove.icon,
                    label = Config.TargetOptions.Remove.label,
                    canInteract = function()
                        return hasFakePlate
                    end
                }
            },
            distance = 2.5,
        })
    end
end)
