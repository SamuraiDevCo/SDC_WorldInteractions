local dumpsterTable = {}
local dumpsterSearched = {}
local trashSearched = {}

local waitingDump = nil
local dump = {
    In = false,
    Ent = nil,
    Cam = nil,
    offsetRot = {x = 0.0, y = 0.0, z = 0.0},
    SaveCoords = nil
}
local waitingTrash = nil
local trash = {
    In = false,
    Ent = nil,
}

RegisterNetEvent("SDWI:Client:Dump:UpdateDumpsterHides")
AddEventHandler("SDWI:Client:Dump:UpdateDumpsterHides", function(tab)
    dumpsterTable = tab
end)
RegisterNetEvent("SDWI:Client:Dump:UpdateDumpsterSearch")
AddEventHandler("SDWI:Client:Dump:UpdateDumpsterSearch", function(tab)
    dumpsterSearched = tab
end)
RegisterNetEvent("SDWI:Client:Dump:UpdateTrash")
AddEventHandler("SDWI:Client:Dump:UpdateTrash", function(tab)
    trashSearched = tab
end)

Citizen.CreateThread(function()
    if SDC.Dump.Enabled then
        AddTextEntry("SDWI_Dump", "~s~~y~"..SDC.Lang.Dumpster.."~n~~"..SDC.DumpKeybinds.Exit.Input.."~ ~r~"..SDC.Lang.Exit)
        AddDumpsterModel(SDC.DumpsterModels, "SDWI:Client:Dump:SearchDumpster", "SDWI:Client:Dump:UseDumpster")
        AddTrashModel(SDC.TrashCanModels, "SDWI:Client:Dump:SearchTrash")
    end
end)

RegisterNetEvent("SDWI:Client:Dump:SearchDumpster")
AddEventHandler("SDWI:Client:Dump:SearchDumpster", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if dump.In then
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.AlreadySearchingDump, "error")
        return
    end
    if not SDC.Dump.Enabled then
        return
    end

    if not dumpsterSearched[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] then
        waitingDump = entity
        TriggerServerEvent("SDWI:Server:Dump:SearchDumpNow", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z))
    else
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.DumpRecentlySearched, "error")
    end
end)
RegisterNetEvent("SDWI:Client:Dump:StartSearching")
AddEventHandler("SDWI:Client:Dump:StartSearching", function()
    if waitingDump then
        dump.Ent = waitingDump
        local ped = PlayerPedId()
        local ecoords = GetEntityCoords(dump.Ent)
        dump.In = true
        waitingDump = nil

        if SDC.Dump.Minigame.Dumpster.Enabled then
            local checktotal = {}
            local keys = {}
            for i=1, SDC.Dump.Minigame.Dumpster.Checks do
                table.insert(checktotal, SDC.Dump.Minigame.Dumpster.Difficulty)
                table.insert(keys, SDC.Dump.Minigame.Dumpster.Keys[math.random(1, #SDC.Dump.Minigame.Dumpster.Keys)])
            end
            local finished = lib.skillCheck(checktotal, keys)
            if finished then
                MakeEntityFaceEntity(ped, dump.Ent)
                LoadAnim("mini@repair")
                TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
                RemoveAnimDict("mini@repair")
                FreezeEntityPosition(ped, true)
                DoProgressbar(SDC.Dump.Minigame.Dumpster.SearchTime*1000, SDC.Lang.Searching)
                FreezeEntityPosition(ped, false)
                ClearPedTasksImmediately(ped)
                TriggerServerEvent("SDWI:Server:Dump:Searched", "Dumpster")
                dump = {
                    In = false,
                    Ent = nil,
                    Cam = nil,
                    offsetRot = {x = 0.0, y = 0.0, z = 0.0},
                    SaveCoords = nil
                }
            else
                TriggerEvent("SDWI:Client:Notification", SDC.Lang.FoundNothing, "error")
                dump = {
                    In = false,
                    Ent = nil,
                    Cam = nil,
                    offsetRot = {x = 0.0, y = 0.0, z = 0.0},
                    SaveCoords = nil
                }
            end
        else
            MakeEntityFaceEntity(ped, dump.Ent)
            LoadAnim("mini@repair")
            TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
            RemoveAnimDict("mini@repair")
            FreezeEntityPosition(ped, true)
            DoProgressbar(SDC.Dump.Minigame.Dumpster.SearchTime*1000, SDC.Lang.Searching)
            FreezeEntityPosition(ped, false)
            ClearPedTasksImmediately(ped)
            TriggerServerEvent("SDWI:Server:Dump:Searched", "Dumpster")
            dump = {
                In = false,
                Ent = nil,
                Cam = nil,
                offsetRot = {x = 0.0, y = 0.0, z = 0.0},
                SaveCoords = nil
            }
        end
    end
    waitingDump = nil
end)

RegisterNetEvent("SDWI:Client:Dump:UseDumpster")
AddEventHandler("SDWI:Client:Dump:UseDumpster", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if dump.In then
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.AlreadyUsingDump, "error")
        return
    end

    if not SDC.Dump.Enabled then
        return
    end

    if not dumpsterTable[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] then
        waitingDump = entity
        TriggerServerEvent("SDWI:Server:Dump:UseDumpNow", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z))
    else
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.DumpInUse, "error")
    end
end)
RegisterNetEvent("SDWI:Client:Dump:CancelWait")
AddEventHandler("SDWI:Client:Dump:CancelWait", function()
    waitingDump = nil
    waitingTrash = nil
end)

RegisterNetEvent("SDWI:Client:Dump:StartUsingDump")
AddEventHandler("SDWI:Client:Dump:StartUsingDump", function()
    if waitingDump then
        dump.Ent = waitingDump
        local ped = PlayerPedId()
        local ecoords = GetEntityCoords(dump.Ent)
        scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

        dump.SaveCoords = GetEntityCoords(ped)
        dump.In = true

        DoScreenFadeOut(500)
        Wait(500)
        SetEntityCoords(ped, ecoords.x, ecoords.y, ecoords.z-5.0, false, false, false, false)
        Wait(10)
        FreezeEntityPosition(ped, true)
        StartDumpCam()

        DoScreenFadeIn(500)
        waitingDump = nil
        while dump.Cam do
            Wait(1)

            BeginTextCommandDisplayHelp("SDWI_Dump")
            EndTextCommandDisplayHelp(false, false, false, -1)
            ProcessDumpControls()

            if IsControlJustReleased(0, SDC.DumpKeybinds.Exit.InputNum) then
                TriggerServerEvent("SDWI:Server:Dump:ExitDump", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z))
                DoScreenFadeOut(500)
                Wait(500)
                FreezeEntityPosition(ped, false)
                SetEntityCoords(ped, dump.SaveCoords.x, dump.SaveCoords.y, dump.SaveCoords.z, false, false, false, false)
                EndDumpCam()
                dump = {
                    In = false,
                    Ent = nil,
                    Cam = nil,
                    offsetRot = {x = 0.0, y = 0.0, z = 0.0},
                    SaveCoords = nil
                }
                DoScreenFadeIn(500)
            end
        end
    end
    waitingDump = nil
end)




RegisterNetEvent("SDWI:Client:Dump:SearchTrash")
AddEventHandler("SDWI:Client:Dump:SearchTrash", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if trash.In then
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.AlreadySearchingDump, "error")
        return
    end
    if not SDC.Dump.Enabled then
        return
    end

    if not trashSearched[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] then
        waitingTrash = entity
        TriggerServerEvent("SDWI:Server:Dump:SearchTrashNow", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z))
    else
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.TrashRecentlySearched, "error")
    end
end)
RegisterNetEvent("SDWI:Client:Dump:StartSearching2")
AddEventHandler("SDWI:Client:Dump:StartSearching2", function()
    if waitingTrash then
        trash.Ent = waitingTrash
        local ped = PlayerPedId()
        local ecoords = GetEntityCoords(trash.Ent)
        trash.In = true
        waitingTrash = nil

        if SDC.Dump.Minigame.Trash.Enabled then
            local checktotal = {}
            local keys = {}
            for i=1, SDC.Dump.Minigame.Trash.Checks do
                table.insert(checktotal, SDC.Dump.Minigame.Trash.Difficulty)
                table.insert(keys, SDC.Dump.Minigame.Trash.Keys[math.random(1, #SDC.Dump.Minigame.Trash.Keys)])
            end
            local finished = lib.skillCheck(checktotal, keys)
            if finished then
                MakeEntityFaceEntity(ped, trash.Ent)
                LoadAnim("mini@repair")
                TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
                RemoveAnimDict("mini@repair")
                FreezeEntityPosition(ped, true)
                DoProgressbar(SDC.Dump.Minigame.Trash.SearchTime*1000, SDC.Lang.Searching)
                FreezeEntityPosition(ped, false)
                ClearPedTasksImmediately(ped)
                TriggerServerEvent("SDWI:Server:Dump:Searched", "Trash")
                trash = {
                    In = false,
                    Ent = nil,
                }
            else
                TriggerEvent("SDWI:Client:Notification", SDC.Lang.FoundNothing, "error")
                trash = {
                    In = false,
                    Ent = nil,
                }
            end
        else
            MakeEntityFaceEntity(ped, trash.Ent)
            LoadAnim("mini@repair")
            TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
            RemoveAnimDict("mini@repair")
            FreezeEntityPosition(ped, true)
            DoProgressbar(SDC.Dump.Minigame.Trash.SearchTime*1000, SDC.Lang.Searching)
            FreezeEntityPosition(ped, false)
            ClearPedTasksImmediately(ped)
            TriggerServerEvent("SDWI:Server:Dump:Searched", "Trash")
            trash = {
                In = false,
                Ent = nil,
            }
        end
    end
    waitingTrash = nil
end)



















function StartDumpCam()
    ClearFocus()

    local ped = PlayerPedId()
    local ecoords = GetEntityCoords(dump.Ent)
    dump.Cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", vec3(ecoords.x, ecoords.y, ecoords.z + 2.0), 0, 0, 0, SDC.Dump.CamFOV*1.0)

    SetCamActive(dump.Cam, true)
    RenderScriptCams(true, false, 0, true, false)
end
function EndDumpCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(dump.Cam, false)
    
    dump.offsetRot.x = 0.0
    dump.offsetRot.y = 0.0
    dump.offsetRot.z = 0.0

    dump.Cam = nil
end
function ProcessDumpControls()
    DisableFirstPersonCamThisFrame()
    DisableControlAction(1, 2, true)
    DisableControlAction(1, 1, true)
    local ecoords = GetEntityCoords(dump.Ent)
    
    dump.offsetRot.x = dump.offsetRot.x - (GetDisabledControlNormal(1, 2) * 8.0)
    dump.offsetRot.z = dump.offsetRot.z - (GetDisabledControlNormal(1, 1) * 8.0)
    if (dump.offsetRot.x > 90.0) then dump.offsetRot.x = 90.0 elseif (dump.offsetRot.x < -90.0) then dump.offsetRot.x = -90.0 end
    if (dump.offsetRot.y > 90.0) then dump.offsetRot.y = 90.0 elseif (dump.offsetRot.y < -90.0) then dump.offsetRot.y = -90.0 end
    if (dump.offsetRot.z > 360.0) then dump.offsetRot.z = dump.offsetRot.z - 360.0 elseif (dump.offsetRot.z < -360.0) then dump.offsetRot.z = dump.offsetRot.z + 360.0 end
    
    SetFocusArea(ecoords.x, ecoords.y, ecoords.z + 2.0, 0.0, 0.0, 0.0)
    SetCamRot(dump.Cam, dump.offsetRot.x, dump.offsetRot.y, dump.offsetRot.z, 2)
end
