local QBCore = nil
local ESX = nil

if SDC.Framework == "qb-core" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif SDC.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
end


function GetCurrentJob()
    if SDC.Framework == "qb-core" then
        local PlayerData = QBCore.Functions.GetPlayerData()
        return PlayerData.job.name
    elseif SDC.Framework == "esx" then
        local PlayerData = ESX.GetPlayerData()
        return ESX.PlayerData.job.name
    end
end

function GetCurrentJobGrade()
    if SDC.Framework == "qb-core" then
        local PlayerData = QBCore.Functions.GetPlayerData()
        return PlayerData.job.grade.level
    elseif SDC.Framework == "esx" then
        local PlayerData = ESX.GetPlayerData()
        return ESX.PlayerData.job.grade
    end
end

function DoProgressbar(time, label)
    if SDC.UseProgBar == "progressBars" then
        exports['progressBars']:startUI(time, label)
        Wait(time)
        return true
    elseif SDC.UseProgBar == "mythic_progbar" then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "sdc_cranejob",
            duration = time,
            label = label,
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }
        })
        Wait(time)
        return true
    elseif SDC.UseProgBar == "ox_lib" then
        if lib.progressBar({
            duration = time,
            label =  label,
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
        }) then 
            return true
        end
    else
        Wait(time)
        return true
    end
end


RegisterNetEvent("SDWI:Client:Notification")
AddEventHandler("SDWI:Client:Notification", function(msg, extra)
	if SDC.NotificationSystem == 'tnotify' then
		exports['t-notify']:Alert({
			style = 'message', 
			message = msg
		})
	elseif SDC.NotificationSystem == 'mythic_old' then
		exports['mythic_notify']:DoHudText('inform', msg)
	elseif SDC.NotificationSystem == 'mythic_new' then
		exports['mythic_notify']:SendAlert('inform', msg)
	elseif SDC.NotificationSystem == 'okoknotify' then
		exports['okokNotify']:Alert(SDC.Lang.WorldInteractions, msg, 3000, 'neutral')
	elseif SDC.NotificationSystem == 'print' then
		print(msg)
	elseif SDC.NotificationSystem == 'framework' then
        if SDC.Framework == "qb-core" then
            QBCore.Functions.Notify(msg, extra)
        elseif SDC.Framework == "esx" then
            ESX.ShowNotification(msg)
        end
	end 
end)



----------------Targets
--Port-A-Potty
function AddPortaModel(model, eventtotrigger)
    if SDC.Target == "qb-target" then
        exports['qb-target']:AddTargetModel(model, { 
        options = {  
            {  
              type = "client",  
              event = eventtotrigger,   
              icon = 'fas fa-hand',   
              label = SDC.Lang.UsePorta,  
            }
        },
        distance = 1.5, 
      })
    elseif SDC.Target == "ox-target" then
        exports.ox_target:addModel(model, {
            {  
                label = SDC.Lang.UsePorta, 
                icon = 'fa-hand', 
                distance = 1.5,
                event = eventtotrigger, 
            }
        })
    elseif SDC.Target == "none" then
        TriggerEvent("SDWI:Client:AddTextModels", model, "PAP", 1.5)
    end
end

--Trash & Dumpsters
function AddTrashModel(model, eventtotrigger)
    if SDC.Target == "qb-target" then
        exports['qb-target']:AddTargetModel(model, { 
        options = {  
            {  
              type = "client",  
              event = eventtotrigger,   
              icon = 'fas fa-hand',   
              label = SDC.Lang.SearchTrash,  
            }
        },
        distance = 1.0, 
      })
    elseif SDC.Target == "ox-target" then
        exports.ox_target:addModel(model, {
            {  
                label = SDC.Lang.SearchTrash, 
                icon = 'fa-hand', 
                distance = 1.0,
                event = eventtotrigger, 
            }
        })
    elseif SDC.Target == "none" then
        TriggerEvent("SDWI:Client:AddTextModels", model, "Trash", 1.5)
    end
end
function AddDumpsterModel(model, eventtotrigger, eventtotrigger2)
    if SDC.Target == "qb-target" then
        exports['qb-target']:AddTargetModel(model, { 
        options = {  
            {  
              type = "client",  
              event = eventtotrigger,   
              icon = 'fas fa-hand',   
              label = SDC.Lang.SearchDumpster,  
            },
            {  
                type = "client",  
                event = eventtotrigger2,   
                icon = 'fas fa-hand',   
                label = SDC.Lang.HideInDumpster,  
            }
        },
        distance = 1.5, 
      })
    elseif SDC.Target == "ox-target" then
        exports.ox_target:addModel(model, {
            {  
                label = SDC.Lang.SearchDumpster, 
                icon = 'fa-hand', 
                distance = 1.5,
                event = eventtotrigger, 
            },
            {  
                label = SDC.Lang.HideInDumpster, 
                icon = 'fa-hand', 
                distance = 1.5,
                event = eventtotrigger2, 
            }
        })
    elseif SDC.Target == "none" then
        TriggerEvent("SDWI:Client:AddTextModels", model, "Dumpster", 2.5)
    end
end

--Parking Meters
function AddMeterModel(model, eventtotrigger, eventtotrigger2, eventtotrigger3)
    if eventtotrigger3 then
        if SDC.Target == "qb-target" then
            exports['qb-target']:AddTargetModel(model, { 
            options = {  
                {  
                  type = "client",  
                  event = eventtotrigger,   
                  icon = 'fas fa-hand',   
                  label = SDC.Lang.UseMeter,  
                },
                {  
                    type = "client",  
                    event = eventtotrigger2,   
                    icon = 'fas fa-hand',   
                    label = SDC.Lang.CheckMeter,  
                },
                {  
                    type = "client",  
                    event = eventtotrigger3,   
                    icon = 'fas fa-sack-dollar',   
                    label = SDC.Lang.RobMeter,  
                }
            },
            distance = 1.0,
          })
        elseif SDC.Target == "ox-target" then
            exports.ox_target:addModel(model, {
                {  
                    label = SDC.Lang.UseMeter, 
                    icon = 'fa-hand', 
                    distance = 1.0,
                    event = eventtotrigger, 
                },
                {  
                    label = SDC.Lang.CheckMeter, 
                    icon = 'fa-hand', 
                    distance = 1.0,
                    event = eventtotrigger2, 
                },
                {  
                    label = SDC.Lang.RobMeter, 
                    icon = 'fa-sack-dollar', 
                    distance = 1.0,
                    event = eventtotrigger3, 
                }
            })
        elseif SDC.Target == "none" then
            TriggerEvent("SDWI:Client:AddTextModels", model, "Meter", 1.5)
        end
    else
        if SDC.Target == "qb-target" then
            exports['qb-target']:AddTargetModel(model, { 
            options = {  
                {  
                  type = "client",  
                  event = eventtotrigger,   
                  icon = 'fas fa-hand',   
                  label = SDC.Lang.UseMeter,  
                },
                {  
                    type = "client",  
                    event = eventtotrigger2,   
                    icon = 'fas fa-hand',   
                    label = SDC.Lang.CheckMeter,  
                }
            },
            distance = 1.0,
          })
        elseif SDC.Target == "ox-target" then
            exports.ox_target:addModel(model, {
                {  
                    label = SDC.Lang.UseMeter, 
                    icon = 'fa-hand', 
                    distance = 1.0,
                    event = eventtotrigger, 
                },
                {  
                    label = SDC.Lang.CheckMeter, 
                    icon = 'fa-hand', 
                    distance = 1.0,
                    event = eventtotrigger2, 
                }
            })
        elseif SDC.Target == "none" then
            TriggerEvent("SDWI:Client:AddTextModels", model, "Meter", 1.5)
        end
    end
end

--Toilets
function AddToiletModel(model, eventtotrigger, eventtotrigger2)
    if SDC.Target == "qb-target" then
        exports['qb-target']:AddTargetModel(model, { 
        options = {  
            {  
              type = "client",  
              event = eventtotrigger,   
              icon = 'fas fa-hand',   
              label = SDC.Lang.UseToiletStanding,  
            },
            {  
                type = "client",  
                event = eventtotrigger2,   
                icon = 'fas fa-hand',   
                label = SDC.Lang.UseToiletSitting,  
            }
        },
        distance = 1.5, 
      })
    elseif SDC.Target == "ox-target" then
        exports.ox_target:addModel(model, {
            {  
                label = SDC.Lang.UseToiletStanding, 
                icon = 'fa-hand', 
                distance = 1.5,
                event = eventtotrigger, 
            },
            {  
                label = SDC.Lang.UseToiletSitting, 
                icon = 'fa-hand', 
                distance = 1.5,
                event = eventtotrigger2, 
            }
        })
    elseif SDC.Target == "none" then
        TriggerEvent("SDWI:Client:AddTextModels", model, "Toilets", 1.5)
    end
end


--Vending Machines
function AddVendingModel(model, eventtotrigger)
    if SDC.Target == "qb-target" then
        exports['qb-target']:AddTargetModel(model, { 
        options = {  
            {  
              type = "client",  
              event = eventtotrigger,   
              icon = 'fas fa-hand',   
              label = SDC.Lang.InteractWithMachine,  
            }
        },
        distance = 1.5, 
      })
    elseif SDC.Target == "ox-target" then
        exports.ox_target:addModel(model, {
            {  
                label = SDC.Lang.InteractWithMachine, 
                icon = 'fa-hand', 
                distance = 1.5,
                event = eventtotrigger, 
            }
        })
    elseif SDC.Target == "none" then
        TriggerEvent("SDWI:Client:AddTextModels", model, "Vending", 1.5)
    end
end

--Chairs
function AddChairModel(model, eventtotrigger)
    if SDC.Target == "qb-target" then
        exports['qb-target']:AddTargetModel(model, { 
        options = {  
            {  
              type = "client",  
              event = eventtotrigger,   
              icon = 'fas fa-hand',   
              label = SDC.Lang.UseChair,  
            }
        },
        distance = 1.5, 
      })
    elseif SDC.Target == "ox-target" then
        exports.ox_target:addModel(model, {
            {  
                label = SDC.Lang.UseChair, 
                icon = 'fa-hand', 
                distance = 1.5,
                event = eventtotrigger, 
            }
        })
    elseif SDC.Target == "none" then
        TriggerEvent("SDWI:Client:AddTextModels", model, "Chairs", 1.5)
    end
end











---Police Alerts
--Parking Meter
local meterAlerts = {}
RegisterNetEvent("SDWI:Client:Meters:CopAlert")
AddEventHandler("SDWI:Client:Meters:CopAlert", function(coordss, extra)
    if SDC.DispatchSystem == "none" then
        scoords = {x = math.ceil(coordss.x), y = math.ceil(coordss.y), z = math.ceil(coordss.z)}
        if SDC.Meter.RobbingMeter.JobsToNotify[GetCurrentJob()] and not meterAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] then
            TriggerEvent("SDWI:Client:Notification", SDC.Lang.ParkingMeterRobbery2, "primary")
            local robBlip = AddBlipForCoord(coordss.x, coordss.y, coordss.z)
            SetBlipSprite(robBlip, extra.Blip.Sprite)
            SetBlipScale(robBlip, extra.Blip.Size)
            SetBlipColour(robBlip, extra.Blip.Color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(SDC.Lang.ParkingMeterRobbery)
            EndTextCommandSetBlipName(robBlip)
            meterAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] = robBlip
            Wait(45 *1000)--45 Seconds
            if meterAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] and DoesBlipExist(meterAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)]) then
                RemoveBlip(robBlip)
            end
            meterAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] = nil
        end
    elseif SDC.DispatchSystem == "ps-dispatch" then
        local jobTab = {}
        for k,v in pairs(SDC.Meter.RobbingMeter.JobsToNotify) do
            table.insert(jobTab, k)
        end

        exports["ps-dispatch"]:CustomAlert({
            message = SDC.Lang.ParkingMeterRobbery,
            icon = "fas fa-sack-dollar",
            coords = coordss,
            job = jobTab,
            alert = {
                sprite = extras.Blip.Sprite,
                scale = extras.Blip.Size,
                color = extras.Blip.Color,
            }
        })
    end
end)





-- Functions
function LoadPropDict(model)
	while not HasModelLoaded(model) do
	  RequestModel(model)
	  Wait(10)
	end
end

function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
	  RequestAnimDict(dict)
	  Wait(10)
	end
end