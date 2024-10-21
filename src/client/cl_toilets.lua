local modelTable = {}
local waitingToilet = nil

local toilet = {
    Using = false,
    Entity = nil,
    SitStand = nil,
    SaveCoords = nil,    
}
Citizen.CreateThread(function()
    if SDC.Toilets.Enabled then
        local newtab = {}
        for i=1, #SDC.ToiletModels do
            table.insert(newtab, SDC.ToiletModels[i].Model)
            modelTable[tostring(GetHashKey(SDC.ToiletModels[i].Model))] = SDC.ToiletModels[i].Offset
        end
        AddTextEntry("SDWI_Toilet", "~s~~y~"..SDC.Lang.Toilet.."~n~~"..SDC.ToiletKeybinds.Exit.Input.."~ ~r~"..SDC.Lang.Exit)
        AddToiletModel(newtab, "SDWI:Client:Toilet:UseStanding", "SDWI:Client:Toilet:UseSitting")
    end
end)

RegisterNetEvent("SDWI:Client:Toilet:UseStanding")
AddEventHandler("SDWI:Client:Toilet:UseStanding", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if toilet.Using then
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.AlreadyUsingToilet, "error")
        return
    end

    if not SDC.Toilets.Enabled then
        return
    end

    waitingToilet = entity
    TriggerServerEvent("SDWI:Server:Toilet:CheckToilet", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z), true, tostring(GetEntityModel(entity)))
end)

RegisterNetEvent("SDWI:Client:Toilet:UseSitting")
AddEventHandler("SDWI:Client:Toilet:UseSitting", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if toilet.Using then
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.AlreadyUsingToilet, "error")
        return
    end

    if not SDC.Toilets.Enabled then
        return
    end

    waitingToilet = entity
    TriggerServerEvent("SDWI:Server:Toilet:CheckToilet", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z), false, tostring(GetEntityModel(entity)))
end)

RegisterNetEvent("SDWI:Client:Toilet:CancelWait")
AddEventHandler("SDWI:Client:Toilet:CancelWait", function()
    if waitingToilet then
        waitingToilet = nil
    end
end)

RegisterNetEvent("SDWI:Client:Toilet:StartUsingToilet")
AddEventHandler("SDWI:Client:Toilet:StartUsingToilet", function(value, model)
    if waitingToilet and not toilet.Using then
        if value then
            DoScreenFadeOut(500)
            Wait(500)
            local ped = PlayerPedId()
            toilet.SaveCoords = GetEntityCoords(ped)
            toilet.Entity = waitingToilet
            toilet.SitStand = {Dict = "misscarsteal2peeing", Anim = "peeing_loop"}
            waitingToilet = nil
            offf = modelTable[model][1]
            local gcoords = GetOffsetFromEntityInWorldCoords(toilet.Entity, offf.x, offf.y, offf.z)
            SetEntityCoords(ped, gcoords.x, gcoords.y, gcoords.z, false, false, false, false)
            PlaceObjectOnGroundProperly(ped)
            MakeEntityFaceEntity(ped, toilet.Entity)
            LoadAnim("misscarsteal2peeing")
            TaskPlayAnim(ped, 'misscarsteal2peeing', 'peeing_loop', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
            RemoveAnimDict("misscarsteal2peeing")
            FreezeEntityPosition(ped, true)
            DoScreenFadeIn(500)
        else
            DoScreenFadeOut(500)
            Wait(500)
            local ped = PlayerPedId()
            toilet.SaveCoords = GetEntityCoords(ped)
            toilet.Entity = waitingToilet
            toilet.SitStand = {Dict = "timetable@ron@ig_3_couch", Anim = "base"}
            waitingToilet = nil
            offf = modelTable[model][1]
            local gcoords = GetOffsetFromEntityInWorldCoords(toilet.Entity, offf.x, offf.y, offf.z)
            local gcoords2 = GetOffsetFromEntityInWorldCoords(toilet.Entity, offf.x, (offf.y + offf.y), offf.z)
            SetEntityCoords(ped, gcoords.x, gcoords.y, gcoords.z, false, false, false, false)
            PlaceObjectOnGroundProperly(ped)
            MakeEntityFaceCoords(ped, gcoords2)
            LoadAnim("timetable@ron@ig_3_couch")
            TaskPlayAnim(ped, 'timetable@ron@ig_3_couch', 'base', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
            RemoveAnimDict("timetable@ron@ig_3_couch")
            FreezeEntityPosition(ped, true)
            DoScreenFadeIn(500)
        end
        toilet.Using = true

        while toilet.Using do
            Wait(1)
            local ped = PlayerPedId()

            if not IsEntityPlayingAnim(ped, toilet.SitStand.Dict, toilet.SitStand.Anim, 1) then
                LoadAnim(toilet.SitStand.Dict)
                TaskPlayAnim(ped, toilet.SitStand.Dict, toilet.SitStand.Anim, 8.0, 8.0, -1, 1, 1, 0, 0, 0)
                RemoveAnimDict(toilet.SitStand.Dict)
            end

            BeginTextCommandDisplayHelp("SDWI_Toilet")
            EndTextCommandDisplayHelp(false, false, false, -1)

            if IsControlJustReleased(0, SDC.ToiletKeybinds.Exit.InputNum) then
                local ecoords = GetEntityCoords(toilet.Entity)
                scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}
                TriggerServerEvent("SDWI:Server:Toilet:StopUsingToilet", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z))
                DoScreenFadeOut(500)
                Wait(500)
                FreezeEntityPosition(ped, false)
                SetEntityCoords(ped, toilet.SaveCoords.x, toilet.SaveCoords.y, toilet.SaveCoords.z, false, false, false, false)
                PlaceObjectOnGroundProperly(ped)
                toilet = {
                    Using = false,
                    Entity = nil,
                    SitStand = nil,
                    SaveCoords = nil
                }
                Wait(400)
                DoScreenFadeIn(500)
            end
        end
        toilet = {
            Using = false,
            Entity = nil,
            SitStand = nil,
            SaveCoords = nil
        }
    end
end)