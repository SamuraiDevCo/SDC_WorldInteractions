local loadedClient = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			Citizen.Wait(200)
			loadedClient = true
            TriggerServerEvent("SDWI:Server:LoadedIn")
			return -- break the loop
		end
	end
end)


local allTargetModels = {}
local closeEntities = {}
local closestEnt = nil
local showingUI = nil

Citizen.CreateThread(function()
	if SDC.Target == "none" then
		while true do
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local closeEntities2 = {}
			for ent in EnumerateObjects() do
				if allTargetModels[tostring(GetEntityModel(ent))] and Vdist(coords.x, coords.y, coords.z, GetEntityCoords(ent)) <= SDC.CloseEntityDistance then
					table.insert(closeEntities2, ent)
				end
			end
			closeEntities = closeEntities2
	
			local minDistance = 100
			local closestEnt2 = nil
			if closeEntities[1] then
				for i=1, #closeEntities do
					dist = Vdist(coords.x, coords.y, coords.z, GetEntityCoords(closeEntities[i]))
					if dist < minDistance then
						minDistance = dist
						closestEnt2 = closeEntities[i]
					end
				end
			end
			closestEnt = closestEnt2
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	if SDC.Target == "none" then
		while true do
			if closestEnt then
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
	
				if closestEnt and Vdist(coords.x, coords.y, coords.z, GetEntityCoords(closestEnt)) <= allTargetModels[tostring(GetEntityModel(closestEnt))].Distance then
					if closestEnt and not showingUI or showingUI ~= allTargetModels[tostring(GetEntityModel(closestEnt))].Value then
						showingUI = allTargetModels[tostring(GetEntityModel(closestEnt))].Value
						if showingUI == "PAP" then
							lib.showTextUI('['..SDC.PAPInteractKeybind.Label..'] - '..SDC.Lang.UsePorta, {
								position = "right-center",
								icon = 'hand',
							})
						elseif showingUI == "Trash" then
							lib.showTextUI('['..SDC.TrashSearchKeybind.Label..'] - '..SDC.Lang.SearchTrash, {
								position = "right-center",
								icon = 'hand',
							})
						elseif showingUI == "Dumpster" then
							lib.showTextUI('['..SDC.DumpsterSearchKeybind.Label..'] - '..SDC.Lang.SearchDumpster.."\n\n"..'['..SDC.DumpsterHideKeybind.Label..'] - '..SDC.Lang.HideInDumpster, {
								position = "right-center",
								icon = 'hand',
							})
						elseif showingUI == "Meter" then
							if SDC.Meter.RobbingMeter.Enabled then
								lib.showTextUI('['..SDC.MeterInteractKeybind.Label..'] - '..SDC.Lang.UseMeter.."\n\n"..'['..SDC.MeterPoliceKeybind.Label..'] - '..SDC.Lang.CheckMeter.."\n\n"..'['..SDC.MeterRobKeybind.Label..'] - '..SDC.Lang.RobMeter, {
									position = "right-center",
									icon = 'hand',
								})
							else
								lib.showTextUI('['..SDC.MeterInteractKeybind.Label..'] - '..SDC.Lang.UseMeter.."\n\n"..'['..SDC.MeterPoliceKeybind.Label..'] - '..SDC.Lang.CheckMeter, {
									position = "right-center",
									icon = 'hand',
								})
							end
						elseif showingUI == "Toilets" then
							lib.showTextUI('['..SDC.ToiletUseStandingKeybind.Label..'] - '..SDC.Lang.UseToiletStanding.."\n\n"..'['..SDC.ToiletUseSittingKeybind.Label..'] - '..SDC.Lang.UseToiletSitting, {
								position = "right-center",
								icon = 'hand',
							})
						elseif showingUI == "Vending" then
							lib.showTextUI('['..SDC.VendingInteractKeybind.Label..'] - '..SDC.Lang.InteractWithMachine, {
								position = "right-center",
								icon = 'hand',
							})
						elseif showingUI == "Chairs" then
							lib.showTextUI('['..SDC.ChairInteractKeybind.Label..'] - '..SDC.Lang.UseChair, {
								position = "right-center",
								icon = 'hand',
							})
						end
					end
	
					if closestEnt and showingUI and showingUI == "PAP" then
						if IsControlJustReleased(0, SDC.PAPInteractKeybind.Input) then
							TriggerEvent("SDWI:Client:PAP:UsePorta", {entity = closestEnt})
							lib.hideTextUI()
							Citizen.Wait(2000)
						end
					elseif closestEnt and showingUI and showingUI == "Trash" then
						if IsControlJustReleased(0, SDC.TrashSearchKeybind.Input) then
							TriggerEvent("SDWI:Client:Dump:SearchTrash", {entity = closestEnt})
							lib.hideTextUI()
							Citizen.Wait(2000)
						end
					elseif closestEnt and showingUI and showingUI == "Dumpster" then
						if IsControlJustReleased(0, SDC.DumpsterSearchKeybind.Input) then
							TriggerEvent("SDWI:Client:Dump:SearchDumpster", {entity = closestEnt})
							lib.hideTextUI()
							Citizen.Wait(2000)
						elseif IsControlJustReleased(0, SDC.DumpsterHideKeybind.Input) then
							TriggerEvent("SDWI:Client:Dump:UseDumpster", {entity = closestEnt})
							lib.hideTextUI()
							Citizen.Wait(2000)
						end
					elseif closestEnt and showingUI and showingUI == "Meter" then
						if SDC.Meter.RobbingMeter.Enabled then
							if IsControlJustReleased(0, SDC.MeterInteractKeybind.Input) then
								TriggerEvent("SDWI:Client:Meters:UseMeter", {entity = closestEnt})
								lib.hideTextUI()
								Citizen.Wait(2000)
							elseif IsControlJustReleased(0, SDC.MeterPoliceKeybind.Input) then
								TriggerEvent("SDWI:Client:Meters:CheckMeter", {entity = closestEnt})
								lib.hideTextUI()
								Citizen.Wait(2000)
							elseif IsControlJustReleased(0, SDC.MeterRobKeybind.Input) then
								TriggerEvent("SDWI:Client:Meters:RobMeter", {entity = closestEnt})
								lib.hideTextUI()
								Citizen.Wait(2000)
							end
						else
							if IsControlJustReleased(0, SDC.MeterInteractKeybind.Input) then
								TriggerEvent("SDWI:Client:Meters:UseMeter", {entity = closestEnt})
								lib.hideTextUI()
								Citizen.Wait(2000)
							elseif IsControlJustReleased(0, SDC.MeterPoliceKeybind.Input) then
								TriggerEvent("SDWI:Client:Meters:CheckMeter", {entity = closestEnt})
								lib.hideTextUI()
								Citizen.Wait(2000)
							end
						end
					elseif closestEnt and showingUI and showingUI == "Toilets" then
						if IsControlJustReleased(0, SDC.ToiletUseStandingKeybind.Input) then
							TriggerEvent("SDWI:Client:Toilet:UseStanding", {entity = closestEnt})
							lib.hideTextUI()
							Citizen.Wait(2000)
						elseif IsControlJustReleased(0, SDC.ToiletUseSittingKeybind.Input) then
							TriggerEvent("SDWI:Client:Toilet:UseSitting", {entity = closestEnt})
							lib.hideTextUI()
							Citizen.Wait(2000)
						end
					elseif closestEnt and showingUI and showingUI == "Vending" then
						if IsControlJustReleased(0, SDC.VendingInteractKeybind.Input) then
							TriggerEvent("SDWI:Client:Vending:UseMachine", {entity = closestEnt})
							lib.hideTextUI()
							Citizen.Wait(2000)
						end
					elseif closestEnt and showingUI and showingUI == "Chairs" then
						if IsControlJustReleased(0, SDC.ChairInteractKeybind.Input) then
							TriggerEvent("SDWI:Client:Chairs:UseChair", {entity = closestEnt})
							lib.hideTextUI()
							Citizen.Wait(2000)
						end
					end
	
					Citizen.Wait(5)
				else
					if showingUI then
						lib.hideTextUI()
						showingUI = nil
					end
					Citizen.Wait(500)
				end
			else
				if showingUI then
					lib.hideTextUI()
					showingUI = nil
				end
				Citizen.Wait(1000)
			end
		end
	end
end)

RegisterNetEvent("SDWI:Client:AddTextModels")
AddEventHandler("SDWI:Client:AddTextModels", function(tab, typee, dist)
	for i=1, #tab do
		allTargetModels[tostring(GetHashKey(tab[i]))] = {Value = typee, Distance = dist}
	end
end)


function MakeEntityFaceEntity(entity1, entity2)
	local p1 = GetEntityCoords(entity1, true)
	local p2 = GetEntityCoords(entity2, true)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)
	SetEntityHeading( entity1, heading )
end

function MakeEntityFaceCoords(entity, coords)
	local p1 = GetEntityCoords(entity, true)
	local p2 = coords

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)
	SetEntityHeading( entity, heading )
end

function LoadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
	  RequestModel(GetHashKey(model))
	  Wait(10)
	end
end

function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
	  RequestAnimDict(dict)
	  Wait(10)
	end
end

--Enums
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end
