local portaTable = {}
local waitingPorta = nil
local porta = {
    In = false,
    PortaEnt = nil,
    Cam = nil,
    offsetRot = {x = 0.0, y = 0.0, z = 0.0},
    SaveCoords = nil
}

RegisterNetEvent("SDWI:Client:PAP:UpdatePotties")
AddEventHandler("SDWI:Client:PAP:UpdatePotties", function(tab)
    portaTable = tab
end)

Citizen.CreateThread(function()
    DoScreenFadeIn(500)
    if SDC.PAP.Enabled then
        AddTextEntry("SDWI_Porta", "~s~~y~"..SDC.Lang.Porta.."~n~~"..SDC.PAPKeybinds.Exit.Input.."~ ~r~"..SDC.Lang.Exit)
        AddPortaModel(SDC.PAPModels, "SDWI:Client:PAP:UsePorta", SDC.Lang.UsePorta)
    end
end)


RegisterNetEvent("SDWI:Client:PAP:UsePorta")
AddEventHandler("SDWI:Client:PAP:UsePorta", function(dat)
    local entity = dat.entity
    local ecoords = GetEntityCoords(entity)
    scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

    if porta.In then
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.AlreadyUsingPorta, "error")
        return
    end

    if not SDC.PAP.Enabled then
        return
    end

    if not portaTable[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] then
        waitingPorta = entity
        TriggerServerEvent("SDWI:Server:PAP:UsePortaNow", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z))
    else
        TriggerEvent("SDWI:Client:Notification", SDC.Lang.PortaInUse, "error")
    end
end)
RegisterNetEvent("SDWI:Client:PAP:CancelWait")
AddEventHandler("SDWI:Client:PAP:CancelWait", function()
    waitingPorta = nil
end)

RegisterNetEvent("SDWI:Client:PAP:StartUsingPorta")
AddEventHandler("SDWI:Client:PAP:StartUsingPorta", function()
    if waitingPorta then
        porta.PortaEnt = waitingPorta
        local ped = PlayerPedId()
        local ecoords = GetEntityCoords(porta.PortaEnt)
        scoords = {x = math.ceil(ecoords.x), y = math.ceil(ecoords.y), z = math.ceil(ecoords.z)}

        porta.SaveCoords = GetEntityCoords(ped)
        porta.In = true

        DoScreenFadeOut(500)
        Wait(500)
        SetEntityCoords(ped, ecoords.x, ecoords.y, ecoords.z-5.0, false, false, false, false)
        Wait(10)
        FreezeEntityPosition(ped, true)
        StartPortaCam()

        DoScreenFadeIn(500)
        waitingPorta = nil
        while porta.Cam do
            Wait(1)

            BeginTextCommandDisplayHelp("SDWI_Porta")
            EndTextCommandDisplayHelp(false, false, false, -1)
            ProcessPortaControls()

            if IsControlJustReleased(0, SDC.PAPKeybinds.Exit.InputNum) then
                TriggerServerEvent("SDWI:Server:PAP:ExitPorta", tostring(scoords.x.."_"..scoords.y.."_"..scoords.z))
                DoScreenFadeOut(500)
                Wait(500)
                FreezeEntityPosition(ped, false)
                SetEntityCoords(ped, porta.SaveCoords.x, porta.SaveCoords.y, porta.SaveCoords.z, false, false, false, false)
                EndPortaCam()
                porta = {
                    In = false,
                    PortaEnt = nil,
                    Cam = nil,
                    offsetRot = {x = 0.0, y = 0.0, z = 0.0},
                    SaveCoords = nil
                }
                DoScreenFadeIn(500)
            end
        end
    end
    waitingPorta = nil
end)


function StartPortaCam()
    ClearFocus()

    local ped = PlayerPedId()
    local ecoords = GetEntityCoords(porta.PortaEnt)
    porta.Cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", vec3(ecoords.x, ecoords.y, ecoords.z + 3.0), 0, 0, 0, SDC.PAP.CamFOV*1.0)

    SetCamActive(porta.Cam, true)
    RenderScriptCams(true, false, 0, true, false)
end
function EndPortaCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(porta.Cam, false)
    
    porta.offsetRot.x = 0.0
    porta.offsetRot.y = 0.0
    porta.offsetRot.z = 0.0

    porta.Cam = nil
end
function ProcessPortaControls()
    DisableFirstPersonCamThisFrame()
    DisableControlAction(1, 2, true)
    DisableControlAction(1, 1, true)
    local ecoords = GetEntityCoords(porta.PortaEnt)
    
    porta.offsetRot.x = porta.offsetRot.x - (GetDisabledControlNormal(1, 2) * 8.0)
    porta.offsetRot.z = porta.offsetRot.z - (GetDisabledControlNormal(1, 1) * 8.0)
    if (porta.offsetRot.x > 90.0) then porta.offsetRot.x = 90.0 elseif (porta.offsetRot.x < -90.0) then porta.offsetRot.x = -90.0 end
    if (porta.offsetRot.y > 90.0) then porta.offsetRot.y = 90.0 elseif (porta.offsetRot.y < -90.0) then porta.offsetRot.y = -90.0 end
    if (porta.offsetRot.z > 360.0) then porta.offsetRot.z = porta.offsetRot.z - 360.0 elseif (porta.offsetRot.z < -360.0) then porta.offsetRot.z = porta.offsetRot.z + 360.0 end
    
    SetFocusArea(ecoords.x, ecoords.y, ecoords.z + 3.0, 0.0, 0.0, 0.0)
    SetCamRot(porta.Cam, porta.offsetRot.x, porta.offsetRot.y, porta.offsetRot.z, 2)
end
