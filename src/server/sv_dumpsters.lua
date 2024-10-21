local DumpTable = {}
local DumpSearches = {}
local TrashSearches = {}

local recentSearchs = {}

RegisterServerEvent("SDWI:Server:LoadedIn")
AddEventHandler("SDWI:Server:LoadedIn", function()
    local src = source
    TriggerClientEvent("SDWI:Client:Dump:UpdateDumpsterHides", src, DumpTable)
    TriggerClientEvent("SDWI:Client:Dump:UpdateDumpsterSearch", src, DumpSearches)
    TriggerClientEvent("SDWI:Client:Dump:UpdateTrash", src, TrashSearches)
end)

RegisterServerEvent("SDWI:Server:Dump:SearchDumpNow")
AddEventHandler("SDWI:Server:Dump:SearchDumpNow", function(loc)
    local src = source

    if not DumpSearches[loc] then
        DumpSearches[loc] = os.time()
        TriggerClientEvent("SDWI:Client:Dump:UpdateDumpsterSearch", -1, DumpSearches)
        TriggerClientEvent("SDWI:Client:Dump:StartSearching", src)
    else
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.DumpRecentlySearched, "error")
        TriggerClientEvent("SDWI:Client:Dump:CancelWait", src)
    end
end)
RegisterServerEvent("SDWI:Server:Dump:SearchTrashNow")
AddEventHandler("SDWI:Server:Dump:SearchTrashNow", function(loc)
    local src = source

    if not TrashSearches[loc] then
        TrashSearches[loc] = os.time()
        TriggerClientEvent("SDWI:Client:Dump:UpdateTrash", -1, TrashSearches)
        TriggerClientEvent("SDWI:Client:Dump:StartSearching2", src)
    else
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.TrashRecentlySearched, "error")
        TriggerClientEvent("SDWI:Client:Dump:CancelWait", src)
    end
end)

RegisterServerEvent("SDWI:Server:Dump:Searched")
AddEventHandler("SDWI:Server:Dump:Searched", function(tt)
    local src = source

    if tt == "Dumpster" then
        itemamt = math.random(SDC.Dump.RandomItems.DumpsterRandomAmount[1], SDC.Dump.RandomItems.DumpsterRandomAmount[2])
        if itemamt > 0 then
            local itemtab = {}
            for i=1, itemamt do
                item = math.random(1, #SDC.Dump.RandomItems.DumpsterItems)
                if itemtab[tostring(item)] then
                    itemtab[tostring(item)] = itemtab[tostring(item)] + 1
                else
                    itemtab[tostring(item)] = 1
                end
            end
            local itemString = nil
            for k,v in pairs(itemtab) do
                if itemString then
                    itemString = itemString..", "..v.."x "..SDC.Dump.RandomItems.DumpsterItems[tonumber(k)].Label
                else
                    itemString = v.."x "..SDC.Dump.RandomItems.DumpsterItems[tonumber(k)].Label
                end
                GiveItem(src, SDC.Dump.RandomItems.DumpsterItems[tonumber(k)].Name, v)
            end
            TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.YouFound..": "..itemString, "success")
        else
            TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.FoundNothing, "error")
        end
    elseif tt == "Trash" then
        itemamt = math.random(SDC.Dump.RandomItems.TrashRandomAmount[1], SDC.Dump.RandomItems.TrashRandomAmount[2])
        if itemamt > 0 then
            local itemtab = {}
            for i=1, itemamt do
                item = math.random(1, #SDC.Dump.RandomItems.TrashItems)
                if itemtab[tostring(item)] then
                    itemtab[tostring(item)] = itemtab[tostring(item)] + 1
                else
                    itemtab[tostring(item)] = 1
                end
            end
            local itemString = nil
            for k,v in pairs(itemtab) do
                if itemString then
                    itemString = itemString..", "..v.."x "..SDC.Dump.RandomItems.TrashItems[tonumber(k)].Label
                else
                    itemString = v.."x "..SDC.Dump.RandomItems.TrashItems[tonumber(k)].Label
                end
                GiveItem(src, SDC.Dump.RandomItems.TrashItems[tonumber(k)].Name, v)
            end
            TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.YouFound..": "..itemString, "success")
        else
            TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.FoundNothing, "error")
        end
    end

    if recentSearchs[tostring(src)] and math.abs(os.difftime(recentSearchs[tostring(src)], os.time())) <= 5 then
        print("^1[WARNING] ^0[^2"..src.."^0] "..GetPlayerName(src).." ^2MAY BE CHEATING. SEARCHED MULTIPLE TRASH CANS / DUMPSTERS IN UNDER 5 SECONDS!^0")
        recentSearchs[tostring(src)] = os.time()
    else
        recentSearchs[tostring(src)] = os.time()
    end
end)

RegisterServerEvent("SDWI:Server:Dump:UseDumpNow")
AddEventHandler("SDWI:Server:Dump:UseDumpNow", function(loc)
    local src = source

    if not DumpTable[loc] then
        DumpTable[loc] = src
        TriggerClientEvent("SDWI:Client:Dump:UpdateDumpsterHides", -1, DumpTable)
        TriggerClientEvent("SDWI:Client:Dump:StartUsingDump", src)
    else
        TriggerClientEvent("SDWI:Client:Notification", src, SDC.Lang.DumpInUse, "error")
        TriggerClientEvent("SDWI:Client:Dump:CancelWait", src)
    end
end)

RegisterServerEvent("SDWI:Server:Dump:ExitDump")
AddEventHandler("SDWI:Server:Dump:ExitDump", function(loc)
    local src = source

    if DumpTable[loc] then
        DumpTable[loc] = nil
        TriggerClientEvent("SDWI:Client:Dump:UpdateDumpsterHides", -1, DumpTable)
    end
end)

AddEventHandler('playerDropped', function(reason) 
    src = source

    local changed = false
    for k,v in pairs(DumpTable) do
        if v == src then
            DumpTable[k] = nil
            changed = true
        end
    end
    if changed then
        TriggerClientEvent("SDWI:Client:Dump:UpdateDumpsterHides", -1, DumpTable)
    end
end)

RegisterServerEvent("SDWI:Server:UpdateInterval")
AddEventHandler("SDWI:Server:UpdateInterval", function()
    for k,v in pairs(DumpSearches) do
        if math.abs(os.difftime(v, os.time())) > (SDC.Dump.SearchCooldown.Dumpster *60) then
            DumpSearches[k] = nil
        end
    end

    for k,v in pairs(TrashSearches) do
        if math.abs(os.difftime(v, os.time())) > (SDC.Dump.SearchCooldown.Trash *60) then
            TrashSearches[k] = nil
        end
    end
end)