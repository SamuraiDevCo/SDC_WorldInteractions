local modelTable = {}
local waitingChair = nil

local chair = {
    Using = false,
    Entity = nil,
    SaveCoords = nil,
}
Citizen.CreateThread(function()
    if SDC.Chairs.Enabled then
        local newtab = {}
        for i=1, #SDC.ChairModels do
            table.insert(newtab, SDC.ChairModels[i].Model)
            modelTable[tostring(GetHashKey(SDC.ChairModels[i].Model))] = SDC.ChairModels[i].Offset
        end
        AddTextEntry("SDWI_Chairs", "~s~~y~"..SDC.Lang.Chair.."~n~~"..SDC.ChairKeybinds.Exit.Input.."~ ~r~"..SDC.Lang.Exit)
        AddChairModel(newtab, "SDWI:Client:Chairs:UseChair")
    end
end)

RegisterNetEvent("SDWI:Client:Chairs:UseChair")
AddEventHandler("SDWI:Client:Chairs:UseChair", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if chair.Using then
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.AlreadyUsingChair, "error")
        return
    end
    if not SDC.Chairs.Enabled then
        return
    end

    waitingChair = entity
    TriggerServerEvent("SDWI:Server:Chairs:TryToUseChair", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z), tostring(GetEntityModel(entity)))
end)
RegisterNetEvent("SDWI:Client:Chairs:CancelWait")
AddEventHandler("SDWI:Client:Chairs:CancelWait", function()
    if waitingChair then
        waitingChair = nil
    end
end)

RegisterNetEvent("SDWI:Client:Chairs:StartUsingChair")
AddEventHandler("SDWI:Client:Chairs:StartUsingChair", function(model)
    if waitingChair then
        DoScreenFadeOut(500)
        Wait(500)
        local pped = PlayerPedId()
        chair.SaveCoords = GetEntityCoords(pped)
        chair.Entity = waitingChair
        waitingChair = nil
        offf = modelTable[model][1]
        local gcoords = GetOffsetFromEntityInWorldCoords(chair.Entity, offf.x, offf.y, offf.z)
        local gcoords2 = GetOffsetFromEntityInWorldCoords(chair.Entity, offf.x, (offf.y + offf.y), offf.z)
        SetEntityCoords(pped, gcoords.x, gcoords.y, gcoords.z, false, false, false, false)
        PlaceObjectOnGroundProperly(pped)
        MakeEntityFaceCoords(pped, gcoords2)
        LoadAnim("timetable@ron@ig_3_couch")
        TaskPlayAnim(pped, 'timetable@ron@ig_3_couch', 'base', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
        RemoveAnimDict("timetable@ron@ig_3_couch")
        FreezeEntityPosition(pped, true)
        DoScreenFadeIn(500)
        chair.Using = true

        while chair.Using do
            Wait(1)
            local ped = PlayerPedId()

            if not IsEntityPlayingAnim(ped, 'timetable@ron@ig_3_couch', 'base', 1) then
                LoadAnim("timetable@ron@ig_3_couch")
                TaskPlayAnim(ped, 'timetable@ron@ig_3_couch', 'base', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
                RemoveAnimDict("timetable@ron@ig_3_couch")
            end

            BeginTextCommandDisplayHelp("SDWI_Chairs")
            EndTextCommandDisplayHelp(false, false, false, -1)

            if IsControlJustReleased(0, SDC.ChairKeybinds.Exit.InputNum) then
                local ecoords = GetEntityCoords(chair.Entity)
                scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}
                TriggerServerEvent("SDWI:Server:Chairs:StopUsingChair", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z))
                DoScreenFadeOut(500)
                Wait(500)
                FreezeEntityPosition(ped, false)
                SetEntityCoords(ped, chair.SaveCoords.x, chair.SaveCoords.y, chair.SaveCoords.z, false, false, false, false)
                PlaceObjectOnGroundProperly(ped)
                chair = {
                    Using = false,
                    Entity = nil,
                    SaveCoords = nil,
                }
                Wait(400)
                DoScreenFadeIn(500)
            end
        end
        chair = {
            Using = false,
            Entity = nil,
            SaveCoords = nil,
        }
    end
end)