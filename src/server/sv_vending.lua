local allVends = {}

RegisterServerEvent("SDWI:Server:Vending:CheckMachine")
AddEventHandler("SDWI:Server:Vending:CheckMachine", function(id, vendi)
    local src = source

    if allVends[id] then
        TriggerClientEvent("SDWI:Client:Vending:OpenMachine", src, id, vendi, allVends[id])
    else
        local newtab = {}
        for i=1, #SDC.Vending.Machines[vendi].ItemsForSale do
            newtab[SDC.Vending.Machines[vendi].ItemsForSale[i].Name] = SDC.Vending.Machines[vendi].ItemsForSale[i]
        end
        allVends[id] = newtab

        TriggerClientEvent("SDWI:Client:Vending:OpenMachine", src, id, vendi, allVends[id])
    end
end)

RegisterServerEvent("SDWI:Server:Vending:TryToBuyItem")
AddEventHandler("SDWI:Server:Vending:TryToBuyItem", function(id, vendi, item)
    local src = source

    if allVends[id] then
        if allVends[id][item] and allVends[id][item].Stock > 0 then
            if GetCurrentCashAmount(src) >= allVends[id][item].Price then
                RemoveCashMoney(src, allVends[id][item].Price)
                allVends[id][item].Stock = allVends[id][item].Stock - 1
                GiveItem(src, item, 1)
                TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.YouPurchased.." 1x "..allVends[id][item].Label, "success")
            else
                TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.NotEnoughMoney, "error")
            end
        else
            TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.VendOutOfStock, "error")
        end
    else
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.VendOutOfStock, "error")
    end
end)
