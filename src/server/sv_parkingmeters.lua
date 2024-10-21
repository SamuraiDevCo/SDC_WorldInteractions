local meters = {}
local stolenmeters = {}

local recentSteals = {}

RegisterServerEvent("SDWI:Server:Meters:TryAddTimeToMeter")
AddEventHandler("SDWI:Server:Meters:TryAddTimeToMeter", function(id, mins, hours)
    local src = source
    totaltime = mins + (hours*60)
    totalPrice = math.floor(totaltime*SDC.Meter.PricePerMinute)
    
    if GetCurrentCashAmount(src) >= totalPrice then
        RemoveCashMoney(src, totalPrice)
        if meters[id] then
            timesave = meters[id].TimeStart
            timeslot = meters[id].SlottedTime
            meters[id] = {TimeStart = timesave, SlottedTime = timeslot+totaltime, Buyer = src}
        else
            meters[id] = {TimeStart = os.time(), SlottedTime = totaltime, Buyer = src}       
        end

        local realhours = 0
        local realmins = 0
        if totaltime > 59 then
            realhours = math.ceil(totaltime/60)
            realmins = totaltime-(realhours*60)
        else
            realmins = totaltime
        end
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.AddedMeterTime1..": "..realhours.."("..SDC.Lang.AddedMeterTime2..") "..realmins.."("..SDC.Lang.AddedMeterTime3..")."..SDC.Lang.AddedMeterTime4..": $"..totalPrice, "success")
    else
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.NotEnoughMoney, "error")
    end
end)


RegisterServerEvent("SDWI:Server:Meters:CheckMeterValue")
AddEventHandler("SDWI:Server:Meters:CheckMeterValue", function(id)
    local src = source

    if meters[id] then
        TriggerClientEvent("SDWI:Client:Meters:DoMeterCheckAnim", src, true)
    else
        TriggerClientEvent("SDWI:Client:Meters:DoMeterCheckAnim", src, false)
    end
end)

RegisterServerEvent("SDWI:Server:UpdateInterval")
AddEventHandler("SDWI:Server:UpdateInterval", function()
    for k,v in pairs(meters) do
        if math.abs(os.difftime(v.TimeStart, os.time())) > (v.SlottedTime*60) then
            meters[k] = nil
        end
    end

    for k,v in pairs(stolenmeters) do
        if math.abs(os.difftime(v, os.time())) > (SDC.Meter.RobbingMeter.MeterRobCooldown*60) then
            stolenmeters[k] = nil
        end
    end
end)

RegisterServerEvent("SDWI:Server:Meters:TryToRob")
AddEventHandler("SDWI:Server:Meters:TryToRob", function(id, realcoords)
    local src = source

    if not stolenmeters[id] then
        local hasItems = nil
        for k,v in pairs(SDC.Meter.RobbingMeter.RequiredItems) do
            if not HasItemAmt(src, k, v.NeededAmount) then
                if hasItems then
                    hasItems = hasItems..", "..v.NeededAmount.."x "..v.Label
                else
                    hasItems = v.NeededAmount.."x "..v.Label
                end
            end
        end

        if not hasItems then
            TriggerEvent("SDWI:Server:Meters:AlertCops", realcoords)
            TriggerClientEvent("SDWI:Client:Meters:DoRobAnim", src)
            stolenmeters[id] = os.time()
        else
            TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.MissingItems..": "..hasItems, "error")
            TriggerClientEvent("SDWI:Client:Meters:CancelWait", src)
        end
    else
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.CantRobMeter, "error")
        TriggerClientEvent("SDWI:Client:Meters:CancelWait", src)
    end
end)

RegisterServerEvent("SDWI:Server:Meters:FinishedRobbingMeter")
AddEventHandler("SDWI:Server:Meters:FinishedRobbingMeter", function(id)
    local src = source

    if recentSteals[tostring(src)] and math.abs(os.difftime(recentSteals[tostring(src)], os.time())) <= 10 then
        print("^1[WARNING] ^0[^2"..src.."^0] "..GetPlayerName(src).." ^2MAY BE CHEATING. ROBBED MULTIPLE PARKING METERS IN UNDER 10 SECONDS!^0")
        recentSteals[tostring(src)] = os.time()
    else
        recentSteals[tostring(src)] = os.time()
    end
    moneyamt = math.random(SDC.Meter.RobbingMeter.PrizeMoneyAmts[1], SDC.Meter.RobbingMeter.PrizeMoneyAmts[2])
    GiveCashMoney(src, moneyamt)
    TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.YouStole.." $"..moneyamt, "success")
end)

RegisterServerEvent("SDWI:Server:Meters:AlertCops")
AddEventHandler("SDWI:Server:Meters:AlertCops", function(realcoords)
    SendDispatchAlert("SDWI:Client:Meters:CopAlert", realcoords, {
        Title = SDC.Lang.ParkingMeterRobbery,
        Message = SDC.Lang.ParkingMeterRobbery2,
        Blip = SDC.Meter.RobbingMeter.Blip
    })
end)