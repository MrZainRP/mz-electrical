local QBCore = exports['qb-core']:GetCoreObject()

local playerJob = nil

local BreakdownLocations = nil 
local BreakdownLocationsTier2 = nil
local BreakdownLocationsTier3 = nil
local BreakdownLocationsTierPrep = nil
local jobsComplete = 0
local jobsCompleteT2 = 0
local jobsCompleteT3 = 0
local jobsCompletePrep = 0
local jobStart = false
local jobtime = 0 
local jobFinished = false
local jobFinishedPrep = false
local working = false

local JobTier1 = false
local JobTier2 = false 
local JobTier3 = false 
local JobTierPrep = false 

local lvl8 = false
local lvl7 = false
local lvl6 = false
local lvl5 = false
local lvl4 = false
local lvl3 = false
local lvl2 = false
local lvl1 = false
local lvl0 = false

local pickupTargetID = 'pickupTarget'
local pickupTargetID2 = 'pickupTarget2'
local isInsidePickupZone = false
local pickupZone = nil

-- Random work point functions per tier
local function GetRandomWork()
    BreakdownLocations = Config.BreakdownLocations[math.random(1, #Config.BreakdownLocations)]
    RegisterPickupTarget(BreakdownLocations)
end
local function GetRandomWorkTier2()
    BreakdownLocationsTier2 = Config.BreakdownLocationsTier2[math.random(1, #Config.BreakdownLocationsTier2)]
    RegisterPickupTarget(BreakdownLocationsTier2)
end
local function GetRandomWorkTier3()
    BreakdownLocationsTier3 = Config.BreakdownLocationsTier3[math.random(1, #Config.BreakdownLocationsTier3)]
    RegisterPickupTarget(BreakdownLocationsTier3)
end
local function GetRandomWorkTierPrep()
    BreakdownLocationsTierPrep = Config.BreakdownLocationsTierPrep[math.random(1, #Config.BreakdownLocationsTierPrep)]
    RegisterPickupTargetPrep(BreakdownLocationsTierPrep)
end

-- Blip markers depending on tier of job acquired.
local function DrawPackageLocationBlip()
    DrawMarker(2, BreakdownLocations.x, BreakdownLocations.y, BreakdownLocations.z + 3, 0, 0, 0, 180.0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 0, 100, false, false, 2, true, nil, nil, false)
end
local function DrawPackageLocationBlipTier2()
    DrawMarker(2, BreakdownLocationsTier2.x, BreakdownLocationsTier2.y, BreakdownLocationsTier2.z + 3, 0, 0, 0, 180.0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 0, 100, false, false, 2, true, nil, nil, false)
end
local function DrawPackageLocationBlipTier3()
    DrawMarker(2, BreakdownLocationsTier3.x, BreakdownLocationsTier3.y, BreakdownLocationsTier3.z + 3, 0, 0, 0, 180.0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 0, 100, false, false, 2, true, nil, nil, false)
end
local function DrawPackageLocationBlipTierPrep()
    DrawMarker(2, BreakdownLocationsTierPrep.x, BreakdownLocationsTierPrep.y, BreakdownLocationsTierPrep.z + 4, 0, 0, 0, 180.0, 0, 0, 0.5, 0.5, 0.5, 0, 255, 0, 100, false, false, 3, true, nil, nil, false)
end

local function DestroyPickupTarget()
    exports['qb-target']:RemoveZone(pickupTargetID)
    pickupZone = nil
    isInsidePickupZone = false
end

local function DestroyPickupTarget2()
    exports['qb-target']:RemoveZone(pickupTargetID2)
    pickupZone = nil
    isInsidePickupZone = false
end

local function DestoryInsideZones()
    DestroyPickupTarget()
    DestroyPickupTarget2()
end

local function SetLocationBlip()
    local ElectricalBlip = AddBlipForCoord(Config.ElectricalWork.x, Config.ElectricalWork.y, Config.ElectricalWork.z)
    SetBlipSprite(ElectricalBlip, 446)
    SetBlipColour(ElectricalBlip, 5)
    SetBlipScale(ElectricalBlip, 0.8)
    SetBlipAsShortRange(ElectricalBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Department of Power and Water')
    EndTextCommandSetBlipName(ElectricalBlip)
end

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        playerJob = QBCore.Functions.GetPlayerData().job
    end
    DestoryInsideZones()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerJob = QBCore.Functions.GetPlayerData().job
    DestoryInsideZones()
end)

RegisterNetEvent('mz-electrical:client:JobStartCooldown', function(timevariable)
    jobStart = true 
    jobtime = 30 
    while jobStart do
        Wait(1000)
        jobtime = jobtime - 1
        if jobtime <= 0 then
            jobStart = false 
        end
    end
end)

RegisterNetEvent('mz-electrical:client:GetPikachud', function()
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(500)
    QBCore.Functions.Progressbar("search_register", "ZAP! (hosting?)...", 2300, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        DisableControlAction(0, 170, true),
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end)
    SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) - Config.HealthDecay)
    Wait(2900)
    local pikachu = math.random(1, 2)
    if pikachu == 1 then 
        TriggerEvent('animations:client:EmoteCommandStart', {"stunned"})
    else 
        TriggerEvent('animations:client:EmoteCommandStart', {"sleep"})
    end 
    Wait(200)
    DoScreenFadeIn(1000)
    if GetEntityHealth(PlayerPedId()) > 0 then 
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "lord2", 0.25)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Someone upstairs must really like you...", "primary", 3000)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("...", "Someone upstairs must really like you...", 3000, "info")
        end
    end 
    Wait(500)
end)

---------------
--DUTY TOGGLE--
---------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("ElectricalworkOnDuty", vector3(724.23, 134.32, 80.96), 1, 0.4, {
        name = "ElectricalworkOnDuty",
        heading = 330,
        debugPoly = false,
        minZ = 77.76,
        maxZ = 81.76,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-electrical:client:ToggleDuty",
                icon = 'fas fa-tools',
                label = 'Go On/Off Duty'
            },
            {
                type = "client",
                event = "mz-electrical:client:Tutorial",
                icon = 'fas fa-tools',
                label = 'How do I work here?'
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-electrical:client:ToggleDuty', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.name == "technician" then
            TriggerServerEvent("QBCore:ToggleDuty")
        else 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("You aren't a technician... Please visit the Cityhall/Job centre...", "primary", 3000)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NOT A TECH?", "You aren't a technician... Please visit the Cityhall/Job centre...", 3000, "info")
            end
        end
    end)
end)

RegisterNetEvent('mz-electrical:client:Tutorial', function()
    if not TutorialStarted then 
        TutorialStarted = true 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Welcome to the Department of Power and Water", "primary", 4000)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "Welcome to the Department of Power and Water", 4000, "info")
        end
        Wait(4250)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("The city generators are constantly under high stress and need your maintenance", "primary", 4000)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "The city generators are constantly under high stress and need your maintenance", 4000, "info")
        end
        Wait(4250)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("In some cities, you will need to apply for 'Electrical Technician' employment before you can work here.", "primary", 5000)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "In some cities, you will need to apply for 'Electrical Technician' employment before you can work here.", 5000, "info")
        end
        Wait(5250)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You can usually do that by visiting City Hall or your city's Job Centre.", "primary", 4000)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "You can usually do that by visiting City Hall or your city's Job Centre.", 4000, "info")
        end
        Wait(4250)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Once you have the required job, you may need to gain some Electrical XP to help out.", "primary", 4500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "Once you have the required job, you may need to gain some Electrical XP to help out.", 4500, "info")
        end
        Wait(4750)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Not all cities have Electrical XP. If yours does not then you can do all work from the start!", "primary", 4500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "Not all cities have Electrical XP. If yours does not then you can do all work from the start!", 4500, "info")
        end
        Wait(4750)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You can start by preparing the job site here...", "primary", 5500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "You can start by preparing the job site here...", 5500, "info")
        end
        Wait(2500)
        exports['ps-ui']:ShowImage("https://i.imgur.com/rtlEP7d.png") -- 1
        Wait(2500)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Just head over from where you are to the tool location on your right.", "primary", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "Just head over from where you are to the tool location on your right.", 3500, "info")
        end
        Wait(4500)
        exports['ps-ui']:ShowImage("https://i.imgur.com/mPm5oSU.png") -- 2
        Wait(2000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("When you are finished, return your supplies here to get paid (and start a new job) at this same place.", "primary", 5500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "When you are finished, return your supplies here to get paid (and start a new job) at this same place.", 5500, "info")
        end
        Wait(5750)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Once you have a bit of experience, you can do some more work.", "primary", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "Once you have a bit of experience, you can do some more work.", 3500, "info")
        end
        Wait(3750)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Here is where you start Tier 1 jobs.", "primary", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "Here is where you start Tier 1 jobs.", 3500, "info")
        end
        Wait(1000)
        exports['ps-ui']:ShowImage("https://i.imgur.com/EVOESau.png") -- 3
        Wait(5000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Over on the other side of the plant you can start Tier 2 jobs.", "primary", 4500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "Over on the other side of the plant you can start Tier 2 jobs.", 4500, "info")
        end
        Wait(1000)
        exports['ps-ui']:ShowImage("https://i.imgur.com/RcBWQUK.png") -- 4
        Wait(5000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("And back next to the Tier 1 jobs you can start the Tier 3 jobs here.", "primary", 4500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "And back next to the Tier 1 jobs you can start the Tier 3 jobs here.", 4500, "info")
        end
        Wait(1000)
        exports['ps-ui']:ShowImage("https://i.imgur.com/Q7TqONP.png") -- 5
        Wait(5000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("When you are done with any T1, T2 or T3 job, you can get paid here.", "primary", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "When you are done with any T1, T2 or T3 job, you can get paid here.", 3500, "info")
        end
        Wait(1000)
        exports['ps-ui']:ShowImage("https://i.imgur.com/YCcXB1F.png") -- 6
        Wait(3500)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You cannot start more than one job before collecting your payment.", "primary", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "You cannot start more than one job before collecting your payment.", 3500, "info")
        end
        Wait(3750)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Look for the double doors near the Prep Tier work, closest to the entrance.", "primary", 4500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "Look for the double doors near the Prep Tier work, closest to the entrance.", 4500, "info")
        end
        Wait(1000)
        exports['ps-ui']:ShowImage("https://i.imgur.com/Ma4Hrt9.png") -- 7
        Wait(4500)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You can go through this tutorial as many times as you like, please visit again if you need to.", "primary", 4500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "You can go through this tutorial as many times as you like, please visit again if you need to.", 4500, "info")
        end
        Wait(4500)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Thank you for your work!", "primary", 4500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WELCOME", "Thank you for your work!", 4500, "info")
        end
        Wait(1000)
        TutorialStarted = false
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You cannot skip the tutorial or start it again, please pay attention.", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("FOREMAN", "You cannot skip the tutorial or start it again, please pay attention.", 3500, "error")
        end
    end
end)

--------------------------
--START WORK - TIER PREP--
--------------------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("ElectricalworkTierPrep", vector3(733.11, 145.44, 80.75), 0.85, 1, {
        name = "ElectricalworkTierPrep",
        heading = 60,
        debugPoly = false,
        minZ = 78.15,
        maxZ = 82.15,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-electrical:client:mzskillcheckprep",
                icon = 'fas fa-tools',
                label = 'Collect supplies'
            },
            {
                type = "client",
                event = "mz-electrical:client:ReturnSupplies",
                icon = 'fas fa-tools',
                label = 'Return Supplies'
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-electrical:client:mzskillcheckprep', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if Config.NeedJob then 
            if PlayerData.job.name == "technician" then
                if Config.mzskills then 
                    exports["mz-skills"]:CheckSkill("Electrical", Config.tierPrepXP, function(hasskill)
                        if hasskill then 
                            TriggerEvent('mz-electrical:client:PrepareJob')
                        else 
                            if Config.NotifyType == 'qb' then
                                QBCore.Functions.Notify("You need at least "..Config.tierPrepXP.." 'Electrical' XP to attend to this sort of work.", "error", 3500)
                            elseif Config.NotifyType == "okok" then
                                exports['okokNotify']:Alert("MORE XP NEEDED", "You need at least "..Config.tierPrepXP.." 'Electrical' XP to attend to this sort of work.", 3500, "error")
                            end    
                        end 
                    end) 
                else 
                    TriggerEvent('mz-electrical:client:PrepareJob')
                end
            else 
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("You are not qualified to assist here. Please go to the job centre and apply for technician employment.", "primary", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("NOT QUALIFIED?", "You are not qualified to assist here. Please go to the job centre and apply for technician employment.", 3500, "info")
                end    
            end
        else 
            if Config.mzskills then 
                exports["mz-skills"]:CheckSkill("Electrical", Config.tierPrepXP, function(hasskill)
                    if hasskill then 
                        TriggerEvent('mz-electrical:client:PrepareJob')
                    else 
                        if Config.NotifyType == 'qb' then
                            QBCore.Functions.Notify("You need at least "..Config.tierPrepXP.." 'Electrical' XP to attend to this sort of work.", "error", 3500)
                        elseif Config.NotifyType == "okok" then
                            exports['okokNotify']:Alert("MORE XP NEEDED", "You need at least "..Config.tierPrepXP.." 'Electrical' XP to attend to this sort of work.", 3500, "error")
                        end    
                    end 
                end) 
            else 
                TriggerEvent('mz-electrical:client:PrepareJob')
            end
        end
    end)
end)

RegisterNetEvent('mz-electrical:client:PrepareJob', function(timevariable)
    if not jobTier1 and not jobTier2 and not jobTier3 then 
        if not jobStart then  
            if not jobFinished then 
                jobTierPrep = true 
                TriggerEvent('mz-electrical:client:JobStartCooldown')
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"think"})
                Wait(1000)
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("As an apprentice it is important to make sure the worksite is properly prepared.", "primary", 3000)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("PREPARATION", "As an apprentice it is important to make sure the worksite is properly prepared.", 3000, "info")
                end
                Wait(3000)
                TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
                Wait(500)
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("This involves ensuring that equipment is well maintained and clean.", "primary", 3000)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("WORK", "This involves ensuring that equipment is well maintained and clean.", 3000, "info")
                end
                Wait(1000)
                TriggerEvent('animations:client:EmoteCommandStart', {"clipboard"})
                QBCore.Functions.Progressbar("search_register", "Checking requirements...", Config.GetJob, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    DisableControlAction(0, 170, true),
                }, {}, {}, {}, function() -- Done
                    Wait(500)
                    ClearPedTasks(PlayerPedId()) 
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify("Please move to the blip to attempt to resolve the issue.", "primary", 3000)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("MOVE TO PING", "Please move to the blip to attempt to resolve the issue.", 3000, "info")
                    end   
                    Wait(500)
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    GetRandomWorkTierPrep()
                end, function() -- Cancel
                    ClearPedTasks(PlayerPedId())
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify("Process Cancelled", "error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
                    end        
                end)
            else 
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("You are done, please return your supplies.", "primary", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("WORK COMPLETE", "You are done, please return your supplies.", 3500, "info")
                end      
            end
        else 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("You have already started work. Please check for the blip...", "primary", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("WORK STARTED", "You have already started work. Please check for the blip...", 3500, "info")
            end    
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("Cooldown remaining: "..jobtime.." seconds.", "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("COOLDOWN", "Cooldown remaining: "..jobtime.." seconds.", 3500, "error")
            end  
        end
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You are already consigned to do something else, please complete that work...", "primary", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("OTHER JOB?", "You are already consigned to do something else, please complete that work...", 3500, "info")
        end    
    end
end)

RegisterNetEvent('mz-electrical:client:ReturnSupplies', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    Wait(1000)
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    if jobFinishedPrep then 
        TriggerServerEvent('mz-electrical:server:GetPaymentPrep')
        Wait(500)
        local TierPrepMultiplier = 0
        while TierPrepMultiplier <= (Config.TierPrepMultiplier - 1) do
            TriggerServerEvent('mz-electrical:server:GetPaymentItems')
            Wait(1000)
        TierPrepMultiplier = TierPrepMultiplier + 1
        end 
        ClearPedTasks(PlayerPedId())
        working = false
        jobStart = false 
        jobTierPrep = false
        jobFinishedPrep = false 
        jobsCompletePrep = 0
        Wait(1000)
        if Config.RareItems then 
            TriggerServerEvent('mz-electrical:server:GetPaymentItemsRare')
        end
    else 
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You have not completed any work...", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("???", "You have not completed any work...", 3500, "error")
        end  
    end 
end)

-----------------------
--START WORK - TIER 1--
-----------------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("ElectricalworkTier1", vector3(718.92, 152.87, 80.75), 1.2, 0.3, {
        name = "ElectricalworkTier1",
        heading = 60,
        debugPoly = false,
        minZ = 78.35,
        maxZ = 82.35,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-electrical:client:mzskillchecktier1",
                icon = 'fas fa-tools',
                label = 'Confer with Site Warden'
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-electrical:client:mzskillchecktier1', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if Config.NeedJob then 
            if PlayerData.job.name == "technician" then
                if Config.mzskills then 
                    exports["mz-skills"]:CheckSkill("Electrical", Config.tier1XP, function(hasskill)
                        if hasskill then 
                            TriggerEvent('mz-electrical:client:StartRepair')
                        else 
                            if Config.NotifyType == 'qb' then
                                QBCore.Functions.Notify("You need at least "..Config.tier1XP.." 'Electrical' XP to attend to this sort of work.", "error", 3500)
                            elseif Config.NotifyType == "okok" then
                                exports['okokNotify']:Alert("MORE XP NEEDED", "You need at least "..Config.tier1XP.." 'Electrical' XP to attend to this sort of work.", 3500, "error")
                            end    
                        end 
                    end) 
                else 
                    TriggerEvent('mz-electrical:client:StartRepair')
                end
            else 
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("You are not qualified to assist here. Please go to the job centre and apply for technician employment.", "primary", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("NOT QUALIFIED?", "You are not qualified to assist here. Please go to the job centre and apply for technician employment.", 3500, "info")
                end    
            end
        else 
            if Config.mzskills then 
                exports["mz-skills"]:CheckSkill("Electrical", Config.tier1XP, function(hasskill)
                    if hasskill then 
                        TriggerEvent('mz-electrical:client:StartRepair')
                    else 
                        if Config.NotifyType == 'qb' then
                            QBCore.Functions.Notify("You need at least "..Config.tier1XP.." 'Electrical' XP to attend to this sort of work.", "error", 3500)
                        elseif Config.NotifyType == "okok" then
                            exports['okokNotify']:Alert("MORE XP NEEDED", "You need at least "..Config.tier1XP.." 'Electrical' XP to attend to this sort of work.", 3500, "error")
                        end    
                    end 
                end) 
            else 
                TriggerEvent('mz-electrical:client:StartRepair')
            end
        end
    end)
end)

RegisterNetEvent('mz-electrical:client:StartRepair', function(timevariable)
    if not jobTier2 and not jobTier3 then 
        if not jobStart then  
            if not jobFinished then
                TriggerEvent('mz-electrical:client:JobStartCooldown')
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"knock"})
                Wait(2000)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("YOU: I have been sent to look at some generators?", "primary", 3000)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("YOU", "I have been sent to look at some generators?", 3000, "info")
                end
                Wait(2000)
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("FOREMAN: Yes yes, just across from us. Please get them functioning again!", "neutral", 3000)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("FOREMAN", "Yes yes, just across from us. Please get them functioning again!", 3000, "neutral")
                end 
                Wait(1000)
                TriggerEvent('animations:client:EmoteCommandStart', {"clipboard"})
                QBCore.Functions.Progressbar("search_register", "Checking work order...", Config.GetJob, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    DisableControlAction(0, 170, true),
                }, {}, {}, {}, function() -- Done
                    Wait(500)
                    ClearPedTasks(PlayerPedId()) 
                    jobTier1 = true 
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify("Please move to the blip to attempt to resolve the issue.", "primary", 3000)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("MOVE TO PING", "Please move to the blip to attempt to resolve the issue.", 3000, "info")
                    end   
                    Wait(500)
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    GetRandomWork()
                end, function() -- Cancel
                    ClearPedTasks(PlayerPedId())
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify("Process Cancelled", "error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
                    end        
                end)
            else 
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("You have already finished repairing the generator, collect your payment.", "primary", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("WORK COMPLETE", "You have already finished repairing the generator, collect your payment.", 3500, "info")
                end   
            end
        else 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("You have already started work. Please find the fault at the blip...", "primary", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("WORK STARTED", "You have already started work. Please find the fault at the blip...", 3500, "info")
            end    
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("Cooldown remaining: "..jobtime.." seconds.", "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("COOLDOWN", "Cooldown remaining: "..jobtime.." seconds.", 3500, "error")
            end  
        end
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You are already consigned to do something else, please complete that work...", "primary", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("OTHER JOB?", "You are already consigned to do something else, please complete that work...", 3500, "info")
        end    
    end
end)

-----------------------
--START WORK - TIER 2--
-----------------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("ElectricalworkTier2", vector3(669.69, 100.67, 80.75), 1.2, 0.2, {
        name = "ElectricalworkTier2",
        heading = 90,
        debugPoly = false,
        minZ = 78.35,
        maxZ = 82.35,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-electrical:client:mzskillchecktier2",
                icon = 'fas fa-tools',
                label = 'Speak to Foreman'
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-electrical:client:mzskillchecktier2', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if Config.NeedJob then 
            if PlayerData.job.name == "technician" then 
                if Config.mzskills then 
                    exports["mz-skills"]:CheckSkill("Electrical", Config.tier2XP, function(hasskill)
                        if hasskill then 
                            TriggerEvent('mz-electrical:client:StartRepairTier2')
                        else 
                            if Config.NotifyType == 'qb' then
                                QBCore.Functions.Notify("You need at least "..Config.tier2XP.." 'Electrical' XP to attend to this sort of work.", "error", 3500)
                            elseif Config.NotifyType == "okok" then
                                exports['okokNotify']:Alert("MORE XP NEEDED", "You need at least "..Config.tier2XP.." 'Electrical' XP to attend to this sort of work.", 3500, "error")
                            end    
                        end 
                    end) 
                else 
                    TriggerEvent('mz-electrical:client:StartRepairTier2')
                end
            else 
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("You are not qualified to assist here. Please go to the job centre and apply for technician employment.", "primary", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("NOT QUALIFIED?", "You are not qualified to assist here. Please go to the job centre and apply for technician employment.", 3500, "info")
                end    
            end
        else 
            if Config.mzskills then 
                exports["mz-skills"]:CheckSkill("Electrical", Config.tier2XP, function(hasskill)
                    if hasskill then 
                        TriggerEvent('mz-electrical:client:StartRepairTier2')
                    else 
                        if Config.NotifyType == 'qb' then
                            QBCore.Functions.Notify("You need at least "..Config.tier2XP.." 'Electrical' XP to attend to this sort of work.", "error", 3500)
                        elseif Config.NotifyType == "okok" then
                            exports['okokNotify']:Alert("MORE XP NEEDED", "You need at least "..Config.tier2XP.." 'Electrical' XP to attend to this sort of work.", 3500, "error")
                        end    
                    end 
                end) 
            else 
                TriggerEvent('mz-electrical:client:StartRepairTier2')
            end 
        end
    end)
end)

RegisterNetEvent('mz-electrical:client:StartRepairTier2', function(timevariable)
    if not JobTier1 and not jobTier3 then 
        if not jobStart then  
            if not jobFinished then
                jobTier2 = true 
                TriggerEvent('mz-electrical:client:JobStartCooldown')
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"knock"})
                Wait(2000)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("YOU: I heard you had an issue with the power?", "primary", 3000)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("YOU", "I heard you had an issue with the power?", 3000, "info")
                end   
                Wait(2000)
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("FOREMAN: Ahh you are finally here, yes yes, have a look here...", "neutral", 3000)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("FOREMAN", "Ahh you are finally here, yes yes, have a look here...", 3000, "neutral")
                end 
                Wait(500)
                TriggerEvent('animations:client:EmoteCommandStart', {"clipboard"})
                Wait(1000)
                QBCore.Functions.Progressbar("search_register", "Reviewing report...", Config.GetJob, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    DisableControlAction(0, 170, true),
                }, {}, {}, {}, function() -- Done
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify("Please move to the blip to attempt to resolve the issue.", "primary", 3000)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("MOVE TO PING", "Please move to the blip to attempt to resolve the issue.", 3000, "info")
                    end   
                    Wait(500)
                    GetRandomWorkTier2()
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                end, function() -- Cancel
                    ClearPedTasks(PlayerPedId())
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify("Process Cancelled", "error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
                    end        
                end)
            else 
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("You have already finished repairing the generator, collect your payment.", "primary", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("WORK COMPLETE", "You have already finished repairing the generator, collect your payment.", 3500, "info")
                end      
            end
        else 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("You have already started work. Please find the fault at the blip...", "primary", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("WORK STARTED", "You have already started work. Please find the fault at the blip...", 3500, "info")
            end    
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("Cooldown remaining: "..jobtime.." seconds.", "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("COOLDOWN", "Cooldown remaining: "..jobtime.." seconds.", 3500, "error")
            end  
        end
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You are already consigned to do something else, please complete that work...", "primary", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("OTHER JOB?", "You are already consigned to do something else, please complete that work...", 3500, "info")
        end    
    end
end)

-----------------------
--START WORK - TIER 3--
-----------------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("ElectricalworkTier3", vector3(711.97, 165.46, 80.75), 1.2, 0.2, {
        name = "ElectricalworkTier3",
        heading = 69,
        debugPoly = false,
        minZ = 78.35,
        maxZ = 82.35,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-electrical:client:mzskillchecktier3",
                icon = 'fas fa-tools',
                label = 'Speak to Site Manager'
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-electrical:client:mzskillchecktier3', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if Config.NeedJob then 
            if PlayerData.job.name == "technician" then 
                if Config.mzskills then 
                    exports["mz-skills"]:CheckSkill("Electrical", Config.tier3XP, function(hasskill)
                        if hasskill then 
                            TriggerEvent('mz-electrical:client:StartRepairTier3')
                        else 
                            if Config.NotifyType == 'qb' then
                                QBCore.Functions.Notify("You need at least "..Config.tier3XP.." 'Electrical' XP to attend to this sort of work.", "error", 3500)
                            elseif Config.NotifyType == "okok" then
                                exports['okokNotify']:Alert("MORE XP NEEDED", "You need at least "..Config.tier3XP.." 'Electrical' XP to attend to this sort of work.", 3500, "error")
                            end    
                        end 
                    end) 
                else 
                    TriggerEvent('mz-electrical:client:StartRepairTier3')
                end
            else 
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("You are not qualified to assist here. Please go to the job centre and apply for technician employment.", "primary", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("NOT QUALIFIED?", "You are not qualified to assist here. Please go to the job centre and apply for technician employment.", 3500, "info")
                end    
            end
        else 
            if Config.mzskills then 
                exports["mz-skills"]:CheckSkill("Electrical", Config.tier3XP, function(hasskill)
                    if hasskill then 
                        TriggerEvent('mz-electrical:client:StartRepairTier3')
                    else 
                        if Config.NotifyType == 'qb' then
                            QBCore.Functions.Notify("You need at least "..Config.tier3XP.." 'Electrical' XP to attend to this sort of work.", "error", 3500)
                        elseif Config.NotifyType == "okok" then
                            exports['okokNotify']:Alert("MORE XP NEEDED", "You need at least "..Config.tier3XP.." 'Electrical' XP to attend to this sort of work.", 3500, "error")
                        end    
                    end 
                end) 
            else 
                TriggerEvent('mz-electrical:client:StartRepairTier3')
            end
        end
    end)
end)

RegisterNetEvent('mz-electrical:client:StartRepairTier3', function(timevariable)
    if not JobTier1 and not jobTier2 then 
        if not jobStart then  
            if not jobFinished then 
                jobTier3 = true 
                TriggerEvent('mz-electrical:client:JobStartCooldown')
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"knock"})
                Wait(2000)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("YOU: They've sent the most experienced sparky they have...", "primary", 3000)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("YOU", "They've sent the most experienced sparky they have...", 3000, "info")
                end   
                Wait(2000)
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("FOREMAN: Excellent, please fix this, the city needs the power!", "neutral", 3000)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("FOREMAN", "Excellent, please fix this, the city needs the power!", 3000, "neutral")
                end 
                Wait(500)
                TriggerEvent('animations:client:EmoteCommandStart', {"clipboard"})
                Wait(1000)
                QBCore.Functions.Progressbar("search_register", "Reviewing schematics...", Config.GetJob, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    DisableControlAction(0, 170, true),
                }, {}, {}, {}, function() -- Done
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify("Please move to the blip to attempt to resolve the issue.", "primary", 3000)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("MOVE TO PING", "Please move to the blip to attempt to resolve the issue.", 3000, "info")
                    end   
                    Wait(500)
                    GetRandomWorkTier3()
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                end, function() -- Cancel
                    ClearPedTasks(PlayerPedId())
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify("Process Cancelled", "error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
                    end        
                end)
            else 
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify("You have already finished repairing the generator, collect your payment.", "primary", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("WORK COMPLETE", "You have already finished repairing the generator, collect your payment.", 3500, "info")
                end      
            end
        else 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("You have already started work. Please find the fault at the blip...", "primary", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("WORK STARTED", "You have already started work. Please find the fault at the blip...", 3500, "info")
            end    
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("Cooldown remaining: "..jobtime.." seconds.", "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("COOLDOWN", "Cooldown remaining: "..jobtime.." seconds.", 3500, "error")
            end  
        end
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You are already consigned to do something else, please complete that work...", "primary", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("OTHER JOB?", "You are already consigned to do something else, please complete that work...", 3500, "info")
        end    
    end
end)

---------------
--WORK EVENTS--
---------------

function RegisterPickupTarget(coords)
    local targetCoords = vector3(coords.x, coords.y, coords.z)
    pickupZone = exports['qb-target']:AddBoxZone(pickupTargetID2, targetCoords, 4, 1.5, {
        name = pickupTargetID2,
        heading = coords.h,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 2.0,
        debugPoly = false,
    }, {
        options = {
            {
                type = 'client',
                event = 'mz-electrical:client:OpenComponent',
                label = "Expose electrical components",
            },
        },
        distance = 1.0
    })
end

RegisterNetEvent('mz-electrical:client:OpenComponent', function()
    if not working then 
        working = true 
        local emotechance = math.random(1, 2)
        if emotechance == 1 then 
            TriggerEvent('animations:client:EmoteCommandStart', {"hammer"})
        else 
            TriggerEvent('animations:client:EmoteCommandStart', {"weld"})
        end
        Wait(1000)
        if Config.Skillcheck then 
            exports['ps-ui']:Circle(function(success)
                if success then
                    TriggerEvent('mz-electrical:client:OpenComponentProgressbar')
                else
                    local zapchance = math.random(1, 100)
                    if Config.ElectrocutionChance >= zapchance then 
                        Wait(200)
                        TriggerEvent('mz-electrical:client:GetPikachud')
                    else 
                        Wait(500)
                        if Config.NotifyType == 'qb' then
                            QBCore.Functions.Notify("You fail to fix the wires and almost electructe yourself... Be careful!", "error", 3500)
                        elseif Config.NotifyType == "okok" then
                            exports['okokNotify']:Alert("WIRES BROKEN", "You fail to fix the wires and almost electructe yourself... Be careful!", 3500, "error")
                        end
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    end 
                    working = false 
                end
            end, Config.Skillparses, Config.Skilltime)
        else 
            TriggerEvent('mz-electrical:client:OpenComponentProgressbar')
        end 
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You are already doing something, slow down!", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("SLOW DOWN", "You are already doing something, slow down!", 3500, "error")
        end      
    end
end)

RegisterNetEvent('mz-electrical:client:OpenComponentProgressbar', function()
    QBCore.Functions.Progressbar("search_register", "Opening component case...", Config.Componentcase, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        DisableControlAction(0, 170, true),
    }, {}, {}, {}, function() -- Done
        Wait(500)
        ClearPedTasks(PlayerPedId())
        Wait(500)
        TriggerEvent('mz-electrical:client:FixWires')
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Process Cancelled", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
        end        
    end)
end)

RegisterNetEvent('mz-electrical:client:FixWires', function()
    local emotechance = math.random(1, 2)
    if emotechance == 1 then 
        TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
    else 
        TriggerEvent('animations:client:EmoteCommandStart', {"type3"})
    end
    Wait(500)
    if Config.Skillcheck then 
        exports['ps-ui']:Circle(function(success)
            if success then
                TriggerEvent('mz-electrical:client:FixWiresProgressbar')
            else
                local zapchance = math.random(1, 100)
                if Config.ElectrocutionChance >= zapchance then 
                    Wait(200)
                    TriggerEvent('mz-electrical:client:GetPikachud')
                else 
                    Wait(500)
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify("You fail to fix the wires and almost electructe yourself... Be careful!", "error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("WIRES BROKEN", "You fail to fix the wires and almost electructe yourself... Be careful!", 3500, "error")
                    end
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                end 
                working = false 
            end
        end, Config.SkillparsesFix, Config.SkilltimeFix) 
    else 
        Wait(500)
        TriggerEvent('mz-electrical:client:FixWiresProgressbar')
    end 
end)

RegisterNetEvent('mz-electrical:client:FixWiresProgressbar', function()
    QBCore.Functions.Progressbar("search_register", "Fixing loose wires...", Config.FixWires, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        DisableControlAction(0, 170, true),
    }, {}, {}, {}, function() -- Done
        Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        Wait(500)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You seem to have addressed this issue...", "success", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("PROBLEM SOLVED", "You seem to have addressed this issue...", 3500, "success")
        end   
        Wait(100)
        if jobTier1 then 
            jobsComplete = jobsComplete + 1
            if Config.mzskills then 
                local BetterXP = math.random(Config.T1elecXPlow, Config.T1elecXPhigh)
                local xpmultiple = math.random(1, 4)
                if xpmultiple > 3 then
                    chance = BetterXP
                elseif xpmultiple < 4 then
                    chance = Config.T1elecXPlow
                end
                exports["mz-skills"]:UpdateSkill("Electrical", chance)
            end
        elseif jobTier2 then 
            jobsCompleteT2 = jobsCompleteT2 + 1
            if Config.mzskills then 
                local BetterXP = math.random(Config.T2elecXPlow, Config.T2elecXPhigh)
                local xpmultiple = math.random(1, 4)
                if xpmultiple > 3 then
                    chance = BetterXP
                elseif xpmultiple < 4 then
                    chance = Config.T2elecXPlow
                end
                exports["mz-skills"]:UpdateSkill("Electrical", chance)
            end
        elseif jobTier3 then 
            jobsCompleteT3 = jobsCompleteT3 + 1 
            if Config.mzskills then 
                local BetterXP = math.random(Config.T3elecXPlow, Config.T3elecXPhigh)
                local xpmultiple = math.random(1, 4)
                if xpmultiple > 3 then
                    chance = BetterXP
                elseif xpmultiple < 4 then
                    chance = Config.T3elecXPlow
                end
                exports["mz-skills"]:UpdateSkill("Electrical", chance)
            end
        end 
        if jobsComplete == Config.Tier1Jobs or jobsCompleteT2 == Config.Tier2Jobs or jobsCompleteT3 == Config.Tier3Jobs then
            Wait(2000) 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("This generator is back to functioning, head over to head office!", "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("GENERATOR REPAIRED", "This generator is back to functioning, head over to head office!", 3500, "success")
            end   
            jobFinished = true 
            BreakdownLocations = nil
            BreakdownLocationsTier2 = nil
            BreakdownLocationsTier3 = nil
            DestoryInsideZones()
        else 
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("Please move to the next fault when you are ready.", "primary", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEW FAULT", "Please move to the next fault when you are ready.", 3500, "info")
            end 
            if jobTier1 then 
                GetRandomWork()
            elseif jobTier2 then 
                GetRandomWorkTier2()
            elseif jobTier3 then 
                GetRandomWorkTier3()
            end 
            Wait(500)
            working = false
        end
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Process Cancelled", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
        end        
    end)
end)

-------------
--PREP WORK--
-------------

function RegisterPickupTargetPrep(coords)
    local targetCoords = vector3(coords.x, coords.y, coords.z)
    pickupZone = exports['qb-target']:AddBoxZone(pickupTargetID2, targetCoords, 4, 1.5, {
        name = pickupTargetID2,
        heading = coords.h,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 2.0,
        debugPoly = false,
    }, {
        options = {
            {
                type = 'client',
                event = 'mz-electrical:client:PrepareWorksite',
                label = "Prepare worksite",
            },
        },
        distance = 1.0
    })
end

RegisterNetEvent('mz-electrical:client:PrepareWorksite', function()
    if not working then 
        working = true 
        TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
        Wait(1000)
        QBCore.Functions.Progressbar("search_register", "Preparing work station...", Config.PrepareWorkStation, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            DisableControlAction(0, 170, true),
        }, {}, {}, {}, function() -- Done
            Wait(500)
            ClearPedTasks(PlayerPedId())
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            Wait(500)
            local chance = math.random(1, 4)
            if chance == 1 then 
                TriggerEvent('mz-electrical:client:PrepPhase1')
            else 
                TriggerEvent('mz-electrical:client:PrepPhase2')
            end 
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId())
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("Process Cancelled", "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
            end        
        end)
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You are already doing something, slow down!", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("SLOW DOWN", "You are already doing something, slow down!", 3500, "error")
        end      
    end
end)

RegisterNetEvent('mz-electrical:client:PrepPhase1', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"kneel2"})
    Wait(750)
    TriggerEvent('animations:client:EmoteCommandStart', {"clean2"})
    QBCore.Functions.Progressbar("search_register", "Cleaning up site...", Config.CleanUp, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        DisableControlAction(0, 170, true),
    }, {}, {}, {}, function() -- Done
        Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        Wait(500)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You seem to have addressed this issue...", "success", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("PROBLEM SOLVED", "You seem to have addressed this issue...", 3500, "success")
        end   
        Wait(100)
        jobsCompletePrep = jobsCompletePrep + 1
        if Config.mzskills then 
            local BetterXP = math.random(Config.TPrepelecXPlow, Config.TPrepelecXPhigh)
            local xpmultiple = math.random(1, 4)
            if xpmultiple > 3 then
                chance = BetterXP
            elseif xpmultiple < 4 then
                chance = Config.TPrepelecXPlow
            end
            exports["mz-skills"]:UpdateSkill("Electrical", chance)
        end
        if jobsCompletePrep == Config.TierPrepJobs then
            Wait(2000) 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("You have finished your job for the day, please return your supplies.", "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("WORK COMPLETE", "You have finished your job for the day, please return your supplies.", 3500, "success")
            end   
            jobFinishedPrep = true 
            BreakdownLocations = nil
            BreakdownLocationsTier2 = nil
            BreakdownLocationsTier3 = nil
            BreakdownLocationsTierPrep = nil
            DestoryInsideZones()
        else 
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("Please move to the next location when you are ready.", "primary", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEXT SITE", "Please move to the next location when you are ready.", 3500, "info")
            end 
            GetRandomWorkTierPrep()
            Wait(500)
            working = false
        end
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Process Cancelled", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
        end 
        working = false       
    end)
end)

RegisterNetEvent('mz-electrical:client:PrepPhase2', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"})
    Wait(750)
    TriggerEvent('animations:client:EmoteCommandStart', {"kneel2"})
    Wait(750)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    QBCore.Functions.Progressbar("search_register", "Ensuring component quality...", Config.EnsureQuality, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        DisableControlAction(0, 170, true),
    }, {}, {}, {}, function() -- Done
        Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        Wait(500)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You seem to have addressed this issue...", "success", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("PROBLEM SOLVED", "You seem to have addressed this issue...", 3500, "success")
        end   
        Wait(100)
        jobsCompletePrep = jobsCompletePrep + 1
        if Config.mzskills then 
            local BetterXP = math.random(Config.TPrepelecXPlow, Config.TPrepelecXPhigh)
            local xpmultiple = math.random(1, 4)
            if xpmultiple > 3 then
                chance = BetterXP
            elseif xpmultiple < 4 then
                chance = Config.TPrepelecXPlow
            end
            exports["mz-skills"]:UpdateSkill("Electrical", chance)
        end
        if jobsCompletePrep == Config.TierPrepJobs then
            Wait(2000) 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("You have finished your job for the day, please return your supplies.", "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("WORK COMPLETE", "You have finished your job for the day, please return your supplies.", 3500, "success")
            end   
            jobFinishedPrep = true 
            BreakdownLocations = nil
            BreakdownLocationsTier2 = nil
            BreakdownLocationsTier3 = nil
            BreakdownLocationsTierPrep = nil
            DestoryInsideZones()
            Wait(1500)
            if Config.mzskills then 
                local BetterXP = math.random(Config.TierPrepCompletelow, Config.TierPrepCompletehigh)
                local xpmultiple = math.random(1, 4)
                if xpmultiple > 3 then
                    chance = BetterXP
                elseif xpmultiple < 4 then
                    chance = Config.TierPrepCompletelow
                end
                exports["mz-skills"]:UpdateSkill("Electrical", chance)
            end
        else 
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("Please move to the next location when you are ready.", "primary", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEXT SITE", "Please move to the next location when you are ready.", 3500, "info")
            end 
            GetRandomWorkTierPrep()
            Wait(500)
            working = false
        end
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Process Cancelled", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
        end
        working = false        
    end)
end)

---------------
--FINISH WORK--
---------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("FinishElectricalWork", vector3(728.68, 148.79, 80.75), 2.8, 0.4, {
        name = "FinishElectricalWork",
        heading = 62,
        debugPoly = false,
        minZ = 78.55,
        maxZ = 82.55,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-electrical:client:GetPaid",
                icon = 'fas fa-sack-dollar',
                label = 'Finalise work'
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-electrical:client:GetPaid', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"clipboard"})
    Wait(1000)
    if jobFinished then 
        if jobTier1 then 
            TriggerServerEvent('mz-electrical:server:GetPayment')
            Wait(500)
            local Tier1Multiplier = 0
            while Tier1Multiplier <= (Config.Tier1Multiplier - 1) do
                TriggerServerEvent('mz-electrical:server:GetPaymentItems')
                Wait(1000)
            Tier1Multiplier = Tier1Multiplier + 1
            end 
            ClearPedTasks(PlayerPedId())
            working = false
            jobTier1 = false
            jobFinished = false 
            jobsComplete = 0
            Wait(1000)
            if Config.RareItems then 
                TriggerServerEvent('mz-electrical:server:GetPaymentItemsRare')
            end 
            Wait(1500)
            if Config.mzskills then 
                local BetterXP = math.random(Config.Tier1Completelow, Config.Tier1Completehigh)
                local xpmultiple = math.random(1, 4)
                if xpmultiple > 3 then
                    chance = BetterXP
                elseif xpmultiple < 4 then
                    chance = Config.Tier1Completelow
                end
                exports["mz-skills"]:UpdateSkill("Electrical", chance)
            end
        elseif jobTier2 then 
            TriggerServerEvent('mz-electrical:server:GetPaymentTier2') 
            Wait(500)
            local Tier2Multiplier = 0
            while Tier2Multiplier <= (Config.Tier2Multiplier - 1) do
                TriggerServerEvent('mz-electrical:server:GetPaymentItems')
                Wait(1000)
            Tier2Multiplier = Tier2Multiplier + 1
            end 
            ClearPedTasks(PlayerPedId())
            working = false
            jobTier2 = false
            jobFinished = false
            jobsCompleteT2 = 0
            Wait(1000)
            if Config.RareItems then 
                TriggerServerEvent('mz-electrical:server:GetPaymentItemsRare')
            end 
            Wait(1500)
            if Config.mzskills then 
                local BetterXP = math.random(Config.Tier2Completelow, Config.Tier2Completehigh)
                local xpmultiple = math.random(1, 4)
                if xpmultiple > 3 then
                    chance = BetterXP
                elseif xpmultiple < 4 then
                    chance = Config.Tier2Completelow
                end
                exports["mz-skills"]:UpdateSkill("Electrical", chance)
            end
        elseif jobTier3 then 
            TriggerServerEvent('mz-electrical:server:GetPaymentTier3')
            Wait(500)
            local Tier3Multiplier = 0
            while Tier3Multiplier <= (Config.Tier3Multiplier - 1) do
                TriggerServerEvent('mz-electrical:server:GetPaymentItems')
                Wait(1000)
            Tier3Multiplier = Tier3Multiplier + 1
            end 
            ClearPedTasks(PlayerPedId())
            working = false
            jobTier3 = false
            jobFinished = false
            jobsCompleteT3 = 0
            Wait(1000)
            if Config.RareItems then 
                TriggerServerEvent('mz-electrical:server:GetPaymentItemsRare')
            end 
            Wait(1500)
            if Config.mzskills then 
                local BetterXP = math.random(Config.Tier3Completelow, Config.Tier3Completehigh)
                local xpmultiple = math.random(1, 4)
                if xpmultiple > 3 then
                    chance = BetterXP
                elseif xpmultiple < 4 then
                    chance = Config.Tier3Completelow
                end
                exports["mz-skills"]:UpdateSkill("Electrical", chance)
            end
        end
        Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    else 
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You have not completed any work...", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("???", "You have not completed any work...", 3500, "error")
        end  
    end 
end)

-----------
--THREADS--
-----------

CreateThread(function()
    local sleep = 500
    while not LocalPlayer.state.isLoggedIn do 
        Wait(sleep) -- do nothing
    end
    SetLocationBlip()
    while true do
        sleep = 500
        if BreakdownLocations then
            sleep = 0
            DrawPackageLocationBlip()
        end
        if BreakdownLocationsTier2 then
            sleep = 0
            DrawPackageLocationBlipTier2()
        end
        if BreakdownLocationsTier3 then
            sleep = 0
            DrawPackageLocationBlipTier3()
        end
        if BreakdownLocationsTierPrep then
            sleep = 0
            DrawPackageLocationBlipTierPrep()
        end
        Wait(sleep)
    end
end)