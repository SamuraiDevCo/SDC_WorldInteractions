local vendModels = {}

Citizen.CreateThread(function()
    if SDC.Vending.Enabled then
        local fullModelList = {}
        for i=1, #SDC.Vending.Machines do
            for j=1, #SDC.Vending.Machines[i].Models do
                table.insert(fullModelList, SDC.Vending.Machines[i].Models[j])
                vendModels[tostring(GetHashKey(SDC.Vending.Machines[i].Models[j]))] = i
            end
        end

        AddVendingModel(fullModelList, "SDWI:Client:Vending:UseMachine")
    end
end)


RegisterNetEvent("SDWI:Client:Vending:UseMachine")
AddEventHandler("SDWI:Client:Vending:UseMachine", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if not SDC.Vending.Enabled then
        return
    end

    if not vendModels[tostring(GetEntityModel(entity))] then
        return
    end

    TriggerServerEvent("SDWI:Server:Vending:CheckMachine", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z), vendModels[tostring(GetEntityModel(entity))])
end)

RegisterNetEvent("SDWI:Client:Vending:OpenMachine")
AddEventHandler("SDWI:Client:Vending:OpenMachine", function(id, vendi, dat)
    local opts = {}

    for k,v in pairs(dat) do
        if v.Stock > 0 then
            table.insert(opts, {
                title = v.Label,
                description = SDC.Lang.Price..": $"..v.Price.." | "..SDC.Lang.Stock..": "..v.Stock,
                icon = SDC.Vending.Machines[vendi].Icon,
                onSelect = function()
                    TriggerServerEvent("SDWI:Server:Vending:TryToBuyItem", id, vendi, k)
                end
            })
        else
            table.insert(opts, {
                title = v.Label,
                description = SDC.Lang.Price..": $"..v.Price.." | "..SDC.Lang.Stock..": "..v.Stock,
                icon = SDC.Vending.Machines[vendi].Icon,
                disabled = true
            })
        end
    end

    lib.registerContext({
        id = 'sdwi_vending_01',
        title = SDC.Vending.Machines[vendi].Label,
        options = opts
    })
    lib.showContext('sdwi_vending_01')
end)