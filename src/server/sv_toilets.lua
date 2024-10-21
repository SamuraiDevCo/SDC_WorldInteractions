local usedToilets = {}

RegisterServerEvent("SDWI:Server:Toilet:CheckToilet")
AddEventHandler("SDWI:Server:Toilet:CheckToilet", function(id, value, model)
    local src = source

    if not usedToilets[id] then
        usedToilets[id] = {User = src, Model = model}
        TriggerClientEvent("SDWI:Client:Toilet:StartUsingToilet", src, value, model)
    else
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.ToiletInUse, "error")
        TriggerClientEvent("SDWI:Client:Toilet:CancelWait", src)
    end
end)

RegisterServerEvent("SDWI:Server:Toilet:StopUsingToilet")
AddEventHandler("SDWI:Server:Toilet:StopUsingToilet", function(id)
    local src = source

    if usedToilets[id] then
        usedToilets[id] = nil
    end
end)


AddEventHandler('playerDropped', function(reason) 
    src = source

    for k,v in pairs(usedToilets) do
        if v.User == src then
            usedToilets[k] = nil
        end
    end
end)