local waitingMeter = nil

Citizen.CreateThread(function()
    if SDC.Meter.Enabled then
        if SDC.Meter.RobbingMeter.Enabled then
            AddMeterModel(SDC.MeterModels, "SDWI:Client:Meters:UseMeter", "SDWI:Client:Meters:CheckMeter", "SDWI:Client:Meters:RobMeter")
        else
            AddMeterModel(SDC.MeterModels, "SDWI:Client:Meters:UseMeter", "SDWI:Client:Meters:CheckMeter", nil)
        end
    end
end)

RegisterNetEvent("SDWI:Client:Meters:UseMeter")
AddEventHandler("SDWI:Client:Meters:UseMeter", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if not SDC.Meter.Enabled then
        return
    end

    local input = lib.inputDialog(SDC.Lang.MeterMenu, {
        {type = 'number', label = SDC.Lang.MeterMenu2, description = SDC.Lang.MeterMenu3, icon = 'hourglass-start', required = true, default = 0, min = 0},
        {type = 'number', label = SDC.Lang.MeterMenu4, description = SDC.Lang.MeterMenu5, icon = 'hourglass-end', required = true, default = 0, min = 0},
    })
    if input and input[1] and tonumber(input[1]) and input[2] and tonumber(input[2]) then
        if tonumber(input[1]) > 0 or tonumber(input[2]) > 0 then
            TriggerServerEvent("SDWI:Server:Meters:TryAddTimeToMeter", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z), tonumber(input[1]), tonumber(input[2]))
        else
            TriggerEvent("SDWI:Client:Notification", SDC.Lang.NoTimeAmountGiven, "error")
        end
    else
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.InvalidTimeEntered, "error")
    end
end)

RegisterNetEvent("SDWI:Client:Meters:CheckMeter")
AddEventHandler("SDWI:Client:Meters:CheckMeter", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if not SDC.Meter.Enabled then
        return
    end

    if waitingMeter then
        return
    end

    if SDC.Meter.JobsToCheckMeter[GetCurrentJob()] then
        TriggerServerEvent("SDWI:Server:Meters:CheckMeterValue", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z))
        waitingMeter = entity
    else
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.YouDontHavePermission, "error")
    end
end)
RegisterNetEvent("SDWI:Client:Meters:CancelWait")
AddEventHandler("SDWI:Client:Meters:CancelWait", function()
    waitingMeter = nil
end)

RegisterNetEvent("SDWI:Client:Meters:DoMeterCheckAnim")
AddEventHandler("SDWI:Client:Meters:DoMeterCheckAnim", function(val)
    if waitingMeter then
        local ped = PlayerPedId()

        MakeEntityFaceEntity(ped, waitingMeter)
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, true)
        FreezeEntityPosition(ped, true)
        DoProgressbar(SDC.Meter.CheckMeterTime*1000, SDC.Lang.CheckingMeter)
        FreezeEntityPosition(ped, false)
        ClearPedTasksImmediately(ped)

        if val then
            TriggerEvent("SDWI:Client:Notification", SDC.Lang.MeterIsPaid, "success")
        else
            TriggerEvent("SDWI:Client:Notification", SDC.Lang.MeterNotPaid, "error")
        end

        waitingMeter = nil
    end
end)

RegisterNetEvent("SDWI:Client:Meters:RobMeter")
AddEventHandler("SDWI:Client:Meters:RobMeter", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if not SDC.Meter.Enabled or not SDC.Meter.RobbingMeter.Enabled then
        return
    end
    if waitingMeter then
        return
    end

    if SDC.Meter.RobbingMeter.Minigame.Enabled then
        local checktotal = {}
        local keys = {}
        for i=1, SDC.Meter.RobbingMeter.Minigame.Checks do
            table.insert(checktotal, SDC.Meter.RobbingMeter.Minigame.Difficulty)
            table.insert(keys, SDC.Meter.RobbingMeter.Minigame.Keys[math.random(1, #SDC.Meter.RobbingMeter.Minigame.Keys)])
        end
        local finished = lib.skillCheck(checktotal, keys)
    
        if finished then
            TriggerServerEvent("SDWI:Server:Meters:TryToRob", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z), ecoords)
            waitingMeter = entity
        else
            TriggerEvent("SDWI:Client:Notification", SDC.Lang.FailedRobbing, "error")
        end
    else
        TriggerServerEvent("SDWI:Server:Meters:TryToRob", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z), ecoords)
        waitingMeter = entity
    end
end)
RegisterNetEvent("SDWI:Client:Meters:DoRobAnim")
AddEventHandler("SDWI:Client:Meters:DoRobAnim", function()
    if waitingMeter then
        local ped = PlayerPedId()

        MakeEntityFaceEntity(ped, waitingMeter)
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, true)
        FreezeEntityPosition(ped, true)
        DoProgressbar(SDC.Meter.CheckMeterTime*1000, SDC.Lang.RobbingMeter)
        FreezeEntityPosition(ped, false)
        ClearPedTasksImmediately(ped)
        waitingMeter = nil

        TriggerServerEvent("SDWI:Client:Meters:FinishedRobbingMeter")
    end
end)