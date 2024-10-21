local PottyTable = {}

RegisterServerEvent("SDWI:Server:LoadedIn")
AddEventHandler("SDWI:Server:LoadedIn", function()
    local src = source
    TriggerClientEvent("SDWI:Client:PAP:UpdatePotties", src, PottyTable)
end)

RegisterServerEvent("SDWI:Server:PAP:UsePortaNow")
AddEventHandler("SDWI:Server:PAP:UsePortaNow", function(loc)
    local src = source

    if not PottyTable[loc] then
        PottyTable[loc] = src
        TriggerClientEvent("SDWI:Client:PAP:UpdatePotties", -1, PottyTable)
        TriggerClientEvent("SDWI:Client:PAP:StartUsingPorta", src)
    else
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.PortaInUse, "error")
        TriggerClientEvent("SDWI:Client:PAP:CancelWait", src)
    end
end)

RegisterServerEvent("SDWI:Server:PAP:ExitPorta")
AddEventHandler("SDWI:Server:PAP:ExitPorta", function(loc)
    local src = source

    if PottyTable[loc] then
        PottyTable[loc] = nil
        TriggerClientEvent("SDWI:Client:PAP:UpdatePotties", -1, PottyTable)
    end
end)

AddEventHandler('playerDropped', function(reason) 
    src = source

    local changed = false
    for k,v in pairs(PottyTable) do
        if v == src then
            PottyTable[k] = nil
            changed = true
        end
    end
    if changed then
        TriggerClientEvent("SDWI:Client:PAP:UpdatePotties", -1, PottyTable)
    end
end)