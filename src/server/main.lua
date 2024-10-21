Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000*SDC.UpdateInterval)
        TriggerEvent("SDWI:Server:UpdateInterval")
    end
end)