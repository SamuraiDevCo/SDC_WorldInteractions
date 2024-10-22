local allChairs = {}

RegisterServerEvent("SDWI:Server:Chairs:TryToUseChair")
AddEventHandler("SDWI:Server:Chairs:TryToUseChair", function(id, model)
    local src = source

    if not allChairs[id] then
        allChairs[id] = {User = src, Model = model}
        TriggerClientEvent("SDWI:Client:Chairs:StartUsingChair", src, model)
    else
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.ChairInUse, "error")
        TriggerClientEvent("SDWI:Client:Chairs:CancelWait", src)
    end
end)

RegisterServerEvent("SDWI:Server:Chairs:StopUsingChair")
AddEventHandler("SDWI:Server:Chairs:StopUsingChair", function(id)
    local src = source

    if allChairs[id] then
        allChairs[id] = nil
    end
end)

AddEventHandler('playerDropped', function(reason) 
    src = source

    for k,v in pairs(allChairs) do
        if v.User == src then
            allChairs[k] = nil
        end
    end
end)