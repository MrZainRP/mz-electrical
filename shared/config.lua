-----------------
--MZ-ELECTRICAL--
-----------------

Config = {
    
    ElectricalWork 	= vector4(687.54, 132.27, 80.75, 79.38),    -- Location of Blip on map (no need to adjust)
    
    ---------------------
    --NOTIFICATION TYPE--
    ---------------------
    NotifyType = "okok",                    -- Change to "qb" for standard qb-core notifications or "okok" for okokNotify

    ----------------
    --CITYHALL JOB--
    ----------------
    NeedJob = true,                          -- Change this to "false" if you do not require players to have the "Technician" job

    -------------
    --MZ-SKILLS--
    -------------
    mzskills = true,                        -- Change to "false" to run the resource without reference to mz-skills    
    -- if "Config.Skillcheck = true", then the following parameters apply:
    tierPrepXP = 0,                         -- Amount of "Electrical" XP needed to perform Prep Tier work.
    tier1XP = 400,                          -- Amount of "Electrical" XP needed to perform Tier 1 work.
    tier2XP = 2400,                         -- Amount of "Electrical" XP needed to perform Tier 2 work.
    tier3XP = 6400,                         -- Amount of "Electrical" XP needed to perform Tier 3 work.
    -- XP gain for completing each task:
    TPrepelecXPlow = 1,                     -- Lowest amount of "Electrical" XP gained from completing a Prep Tier task.
    TPrepelecXPhigh = 2,                    -- Highest amount of "Electrical" XP gained from completing a Prep Tier task.
    T1elecXPlow = 1,                        -- Lowest amount of "Electrical" XP gained from completing a Tier 1 task.
    T1elecXPhigh = 3,                       -- Highest amount of "Electrical" XP gained from completing a Tier 1 task.
    T2elecXPlow = 1,                        -- Lowest amount of "Electrical" XP gained from completing a Tier 2 task.
    T2elecXPhigh = 5,                       -- Highest amount of "Electrical" XP gained from completing a Tier 2 task.
    T3elecXPlow = 2,                        -- Lowest amount of "Electrical" XP gained from completing a Tier 3 task.
    T3elecXPhigh = 7,                       -- Highest amount of "Electrical" XP gained from completing a Tier 3 task.
    -- XP gain for completing all jobs:
    TierPrepCompletelow = 3,                -- Lowest amount of "Electrical" XP gained from completing Prep Tier work. 
    TierPrepCompletehigh = 5,               -- Highest amount of "Electrical" XP gained from completing Prep Tier work. 
    Tier1Completelow = 3,                   -- Lowest amount of "Electrical" XP gained from completing Tier 1 work.
    Tier1Completehigh = 7,                  -- Highest amount of "Electrical" XP gained from completing Tier 1 work.
    Tier2Completelow = 4,                   -- Lowest amount of "Electrical" XP gained from completing Tier 2 work.
    Tier2Completehigh = 9,                  -- Highest amount of "Electrical" XP gained from completing Tier 2 work.
    Tier3Completelow = 5,                   -- Lowest amount of "Electrical" XP gained from completing Tier 3 work.
    Tier3Completehigh = 11,                 -- Highest amount of "Electrical" XP gained from completing Tier 3 work.
    
    --------------
    --SKILLCHECK--
    --------------
    Skillcheck = true,                      -- Set to "false" if you do not want players to undergo a skillcheck to complete each task.
    -- if "Config.Skillcheck = true", then the following parameters apply:
    -- FOR OPENING UP ELECTRICAL COMPONENTS
    Skillparses = 4,                        -- Number of ps-ui:circle skillparses per skillcheck (2x skillcheck per task) 
    Skilltime = 10,                         -- Time player has to complete skillcheck.
    -- FOR FIXING WIRES:
    SkillparsesFix = 3,                     -- Number of ps-ui:circle skillparses per skillcheck (2x skillcheck per task) 
    SkilltimeFix = 9,                       -- Time player has to complete skillcheck.
    -- Skillcheck fail consequences:
    ElectrocutionChance = 10,               -- Chance (in percentage - maximum 100) for player to be electrocuted upon failing skillcheck. 
    HealthDecay = 10,                       -- Amount of health a player will lose if electrocuted in accordance with above trigger.

    -----------------
    --PROGRESS BARS--
    -----------------
    GetJob = 3500,                          -- Time (in seconds) where 1 second = 1000.             
    PrepareWorkStation = 5000,
    CleanUp = 4000,
    EnsureQuality = 3000,           
    Componentcase = 3500,
    FixWires = 4500, 

    ----------
    --OUTPUT--
    ----------
    PaymentType = "bank",                    -- Change to "cash" to make the job pay in cash rather than to a player's bank account.
    -------------
    --TIER PREP--
    -------------
    JobCompletePrepLow = 500,                -- Lowest amount of money received for completing a Prep Tier job. 
    JobCompletePrepHigh = 1500,              -- Highest amount of money received for completing a Prep Tier job. 
    TierPrepJobs = 3,                        -- Number of work preparation tasks which need to be completed (recommended: 3+)
    TierPrepMultiplier = 1,                  -- Number of item parses player receives for finishing a Prep Tier job and cashing in.
    ----------
    --TIER 1--
    ----------
    JobCompleteLow = 1500,                  -- Lowest amount of money received for completing a Tier 1 job. 
    JobCompleteHigh = 2500,                 -- Highest amount of money received for completing a Tier 1 job. 
    Tier1Jobs = 4,                          -- Number of generator components which need to be completed before job completes (recommended: 4+)
    Tier1Multiplier = 3,                    -- Number of item parses player receives for finishing a Tier 1 job and cashing in.
    ----------
    --TIER 2--
    ----------
    JobCompleteTier2Low = 2500,             -- Lowest amount of money received for completing a Tier 2 job.
    JobCompleteTier2High = 3500,            -- Highest amount of money received for completing a Tier 2 job.
    Tier2Jobs = 5,                          -- Number of generator components which need to be completed before job completes (recommended: 5+)
    Tier2Multiplier = 7,                    -- Number of item parses player receives for finishing a Tier 2 job and cashing in.
	----------
    --TIER 3--
    ----------
    JobCompleteTier3Low = 3500,             -- Lowest amount of money received for completing a Tier 3 job.
    JobCompleteTier3High = 4500,            -- Highest amount of money received for completing a Tier 3 job.
    Tier3Jobs = 6,                          -- Number of generator components which need to be completed before job completes (recommended: 6+)
    Tier3Multiplier = 10,                   -- Number of item parses player receives for finishing a Tier 3 job and cashing in.

    ---------------
    --ITEM OUTPUT--                         -- Loot table item, probability chance of receiving particular item and amount awarded. 
    ---------------                         
    -- PLEASE NOTE: If you want to make more than 6 items, you will need to adjust the probability chances.
    -- PLEASE ALSO NOTE: If you want a chance at receiving less items, just set the "chance" amount to 0 for those you do not want to turn up.
    -- Item 1
    Item1 = "rubber",                       -- Name of item 1 capable of being awarded for job completion.
    Item1chance = 25,                       -- Please ensure that the 6 numbers comprising Item1chance -> Item6chance add up to 100 in total. 
    Item1AmountLow = 1,                     -- Lowest amount of item 1 awarded for job completion.
    Item1AmountHigh = 3,                    -- Highest amount of item 1 awarded for job completion.
    -- Item 2
    Item2 = "plastic",
    Item2chance = 25,
    Item2AmountLow = 1,
    Item2AmountHigh = 3,
    -- Item 3
    Item3 = "metalscrap",
    Item3chance = 15,
    Item3AmountLow = 1,
    Item3AmountHigh = 3,
    -- Item 4
    Item4 = "glass",
    Item4chance = 15,
    Item4AmountLow = 1,
    Item4AmountHigh = 3,
    -- Item 5
    Item5 = "aluminum",
    Item5chance = 10,
    Item5AmountLow = 1,
    Item5AmountHigh = 3,
    -- Item 6
    Item6 = "electronicscrap",
    Item6chance = 10,
    Item6AmountLow = 1,
    Item6AmountHigh = 3,

    --------------
    --RARE ITEMS--
    --------------
    -- The following rare item awards follow in addition to the item output and payment.
    RareItems = true,                       -- Change to "false" to disable rare item drops.
    -- if "Config.RareItems = true", then the following parameters apply:
    -- Rare Item 1
    ItemRare = "blankusb",
    ItemRareChance = 2,
    ItemRareAmountLow = 1,
    ItemRareAmountHigh = 1,
    -- Rare Item 2
    ItemRare2 = "lockpick",
    ItemRare2Chance = 1,
    ItemRare2AmountLow = 1,
    ItemRare2AmountHigh = 1,

    ------------------
	--WORK LOCATIONS--
    ------------------
    BreakdownLocationsTierPrep = {
		[1] 	= vector4(680.29, 95.4, 80.75, 83.99),
		[2] 	= vector4(652.79, 101.19, 80.74, 176.75),
		[3] 	= vector4(650.22, 101.28, 80.74, 179.66),
		[4] 	= vector4(689.12, 174.82, 80.75, 251.66),
		[5] 	= vector4(705.98, 168.63, 80.75, 251.26),
		[6] 	= vector4(682.15, 152.96, 80.88, 159.12),
		[7] 	= vector4(693.96, 135.18, 80.86, 249.0),
        [8] 	= vector4(704.71, 132.68, 80.75, 245.69),
		[9] 	= vector4(714.41, 117.16, 80.88, 160.96),
		[10] 	= vector4(705.85, 95.0, 80.88, 158.2),
        [11]    = vector4(693.95, 98.72, 80.8, 70.7), 
        [12]    = vector4(701.03, 120.24, 80.75, 342.84), 
        [13]    = vector4(692.46, 127.07, 81.09, 88.53), 
        [14]    = vector4(675.6, 133.21, 81.08, 69.46), 
        [15]    = vector4(658.28, 127.88, 80.84, 168.8), 
        [16]    = vector4(674.19, 121.14, 81.09, 253.81), 
        [17]    = vector4(671.26, 110.46, 80.82, 159.99), 
        [18]    = vector4(683.11, 104.27, 80.82, 334.91), 
        [19]    = vector4(678.74, 140.68, 80.75, 74.23), 
	},
	BreakdownLocations = {
		[1] 	= vector4(712.64, 121.96, 80.9, 334.13),
		[2] 	= vector4(707.53, 108.44, 80.94, 158.42),
		[3] 	= vector4(699.44, 109.92, 80.94, 243.32),
		[4] 	= vector4(703.32, 102.12, 80.93, 166.12),
		[5] 	= vector4(697.56, 104.21, 80.93, 171.04),
		[6] 	= vector4(706.79, 105.05, 80.94, 162.23),
		[7] 	= vector4(703.19, 119.62, 80.96, 158.28),
        [8] 	= vector4(705.86, 124.54, 80.9, 327.07),
		[9] 	= vector4(701.44, 110.61, 80.94, 170.17),
		[10] 	= vector4(704.55, 109.43, 80.94, 152.79),
        [11]    = vector4(700.92, 107.32, 80.94, 159.05), 
        [12]    = vector4(697.54, 104.22, 80.93, 157.05), 
        [13]    = vector4(703.23, 102.17, 80.93, 182.52), 
        [14]    = vector4(708.52, 106.57, 80.94, 74.76), 
        [15]    = vector4(703.59, 107.13, 81.07, 339.34), 
        [16]    = vector4(701.18, 117.98, 80.75, 257.58), 
	},
    BreakdownLocationsTier2 = {
		[1] 	= vector4(675.1, 110.24, 80.91, 163.07),
		[2] 	= vector4(678.29, 109.16, 80.91, 160.26),
		[3] 	= vector4(681.29, 108.1, 80.91, 159.65),
		[4] 	= vector4(677.71, 115.01, 80.94, 166.49),
		[5] 	= vector4(683.65, 112.81, 80.94, 152.55),
		[6] 	= vector4(686.09, 121.83, 80.95, 341.98),
		[7] 	= vector4(684.78, 127.9, 80.95, 158.33),
        [8] 	= vector4(679.57, 124.13, 80.95, 338.31),
		[9] 	= vector4(670.22, 128.13, 80.95, 332.32),
		[10] 	= vector4(664.44, 130.23, 80.95, 8.84), 
        [11]    = vector4(659.14, 125.64, 80.92, 242.4),
        [12]    = vector4(666.36, 121.78, 80.92, 343.89),
        [13]    = vector4(666.61, 114.21, 80.75, 86.46), 
        [14]    = vector4(658.92, 114.82, 80.92, 3.43), 
        [15]    = vector4(664.56, 112.7, 80.92, 338.5), 
        [16]    = vector4(652.37, 101.19, 80.74, 192.88),
	},  
    BreakdownLocationsTier3 = {
		[1] 	= vector4(702.81, 163.23, 80.95, 70.89),
		[2] 	= vector4(703.75, 165.73, 80.95, 69.67),
		[3] 	= vector4(694.12, 166.22, 80.95, 248.0),
		[4] 	= vector4(685.62, 169.12, 80.95, 339.98),
		[5] 	= vector4(679.73, 171.13, 80.95, 343.64),
		[6] 	= vector4(676.32, 168.21, 80.93, 343.51),
		[7] 	= vector4(682.13, 166.02, 80.93, 342.45),
        [8] 	= vector4(674.55, 166.59, 80.93, 258.01),
		[9] 	= vector4(681.68, 162.66, 80.93, 340.52),
		[10] 	= vector4(680.07, 153.69, 80.94, 346.75), 
        [11]    = vector4(674.33, 155.66, 80.94, 337.99),
        [12]    = vector4(670.89, 151.13, 80.93, 157.08),
        [13]    = vector4(672.13, 145.1, 80.93, 2.77), 
        [14]    = vector4(676.27, 146.27, 80.93, 158.04), 
        [15]    = vector4(673.93, 150.18, 80.93, 160.83), 
        [16]    = vector4(686.77, 144.74, 80.94, 160.54),
        [17]    = vector4(692.56, 142.8, 80.94, 158.81),
        [18]    = vector4(690.03, 147.96, 80.96, 166.95), 
        [19]    = vector4(696.01, 145.69, 80.96, 167.19), 
        [20]    = vector4(693.59, 150.2, 80.96, 161.72), 
        [21]    = vector4(697.94, 158.27, 80.94, 149.71), 
        [22]    = vector4(692.15, 160.2, 80.94, 157.4), 
	},  
}
