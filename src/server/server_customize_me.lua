local QBCore = nil
local ESX = nil

if SDC.Framework == "qb-core" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif SDC.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
end

function GetCurrentCashAmount(src)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        return Player.PlayerData.money['cash']
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer.getAccount('money').money
    end
end

function RemoveCashMoney(src, amt)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.RemoveMoney('cash', amt)
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeAccountMoney('money', amt)
    end
end

function GiveCashMoney(src, amt)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddMoney('cash', amt)
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addAccountMoney('money', amt)
    end
end

function GiveItem(src, item, amt)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddItem(item, amt)
        TriggerClientEvent("inventory:client:ItemBox", src, item, "add")
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addInventoryItem(item, amt)
    end
end

function RemoveItem(src, item, amt)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.RemoveItem(item, amt)
        TriggerClientEvent("inventory:client:ItemBox", src, item, "remove")
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(item, amt)
    end
end

function HasItemAmt(src, item, amt)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item) and Player.Functions.GetItemByName(item).amount >= amt then
            return true
        else
            return false
        end
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getInventoryItem(item) and xPlayer.getInventoryItem(item).count >= amt then
            return true
        else
            return false
        end
    end
end

function GetItemAmt(src, item)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item) and Player.Functions.GetItemByName(item).amount then
            return Player.Functions.GetItemByName(item).amount
        else
            return 0
        end
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getInventoryItem(item) and xPlayer.getInventoryItem(item).count then
            return xPlayer.getInventoryItem(item).count
        else
            return 0
        end
    end
end

function GetOwnerTag(src)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.PlayerData.citizenid
        else
            return nil
        end
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            return xPlayer.identifier
        else
            return nil
        end
    end
end

function SendDispatchAlert(event, coords, extras)
    if SDC.DispatchSystem == "none" then
        TriggerClientEvent(event, -1, coords, extras)
    elseif SDC.DispatchSystem == "cd_dispatch" then
        local jobTab = {}
        for k,v in pairs(SDC.Meter.RobbingMeter.JobsToNotify) do
            table.insert(jobTab, k)
        end
        TriggerClientEvent('cd_dispatch:AddNotification', -1, {
            job_table = jobTab,
            coords = vector3(coords.x, coords.y, coords.z),
            title = extras.Title,
            message = extras.Message,
            flash = 0,
            unique_id = tostring(math.random(0000000,9999999)),
            sound = 1,
            blip = {
                sprite = extras.Blip.Sprite,
                scale = extras.Blip.Size,
                colour = extras.Blip.Color,
                flashes = false,
                text = extras.Title,
                time = 5,
                radius = 0,
            }
        })
    elseif SDC.DispatchSystem == "ps-dispatch" then
        local playerid = nil
        if SDC.Framework == "qb-core" then
            local Players = QBCore.Functions.GetPlayers()
            if #Players > 0 then
                for i=1, #Players do
                    local Player = QBCore.Functions.GetPlayer(Players[i])
                    if Player and GetPlayerName(Players[i]) and not playerid then
                        playerid = Players[i]
                    end
                end
            end
        elseif SDC.Framework == "esx" then
            local Players = ESX.GetPlayers()
            if #Players > 0 then
                for i=1, #Players do
                    local Player = ESX.GetPlayerFromId(Players[i])
                    if Player and GetPlayerName(Players[i]) and not playerid then
                        playerid = Players[i]
                    end
                end
            end
        end
        TriggerClientEvent(event, playerid, coords, extras)
    end
end