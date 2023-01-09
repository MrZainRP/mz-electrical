## MZ-ELECTRICAL - A highly customisable legal job for qb-core including progression, tutorial and randomised locations to complete tasks.

By Mr_Zain#4139

- A highly customisable legal job for qb-core which includes the choice to lock the job behind a cityhall/job centre requirement;
- Configured to utilise mz-skills new "Electrical" XP - with certain parts of the job locked behind XP requirements (customisable by config);
- Configured with qb-core and okokNotify notifications (set via config);
- Job payout + loot tree + probabilities + amount dropped are easily customisable via config;
- Anti-exploit checks re: payment variables (can add log references + drop mechanic where "print" notation appears if you wish to);
- Utilises the efficiencies of qb-recyclejob (big thank you to the persons responsible for the conversion of that resource to a target based resource with blip references);
- Configured with ps-ui:circle skillcheck functionality (which can be enabled or disabled via config).

## DEPENDENCIES

NOTE: You should have each of the dependencies other than qb-lock and mz-skills as part of a conventional qb-core install.

**[progressbar](https://github.com/qbcore-framework/progressbar)**

**[qb-target](https://github.com/qbcore-framework/qb-target)**

**[ps-ui](https://github.com/Project-Sloth/ps-ui)**

OPTIONAL

**[mz-skills](https://github.com/MrZainRP/mz-skills)** - to track skill progress. All credit to Kings#4220 for the original qb-skillz now **[B1-skillz](https://github.com/Burn-One-Studios/B1-skillz)**

OPTIONAL: (Configured to work with okokNotify as well as base qb-core notifications).

## Installation Instruction

## A. MZ-SKILLS

1. Ensure that mz-skills forms part of your running scripts. If you have downloaded mz-skills before and are running it, please make sure you download the latest version of it. 

2. Run the "skills.sql" sql file and open the database. (This will add a data table to the existing "players" database which will hold the skill value for "Scraping" as well as other jobs)

## B. QB-CORE/SHARED/ITEMS.LUA

3. Add the following items to qb-core/shared/items.lua 

4. PLEASE NOTE: If you are using other mz- resources you will not need to re-add certain items. Also be sure not to have conflicting items with the same name in your qb-core/items.lua.

5. If your server is not using mz-hacks, please add the following to your qb-core/shared/items.lua. If your server is using mz-hacks you do not need to attend to this step.

```lua
	-- mz-electrical
	['blankusb'] 				 	= {['name'] = 'blankusb', 			  	  	['label'] = 'Blank USB', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'blankusb.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Non-descript USB, wonder if there is anything on it?'},
```

## C. IMAGES

6. Add the images which appear in the "images" folder to your inventory images folder. 

7. If using lj-inventory, add the images to: lj-inventory/html/images/ - if you are using qb-inventory, add the images to qb-inventory/html/images/

## D. CITYHALL/JOB CENTRE (QB-CORE/JOBS and QB-CITYHALL)

8. If you wish to lock a player's ability to attend to technician work behind a job, you will need to add the job to your server.

9. First, add the job to qb-core/shared/jobs.lua. You can add this job anywhere within the existing jobs or at the end of the config file before the last }, reference. I suggest the following:

```lua
	['technician'] = {
		label = 'Electrical Tech.',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Technician',
                payment = 50
            },
        },
    },
```

10. Secondly, within qb-cityhall/server/main.lua, you want to add a further "availableJobs" at the start of the resource (if you have not altered it, this variable will be defined stating on line 2. Remember to make sure all different vairables have a comma after them or the definition will fail. I suggest the following:

```lua
["technician"] = "Electrical Technician",
```

## E. FINALISATION

11. If you attend to all of the above steps you will need to restart the server in order for the new added items to be recognised by qb-core. 

12. Please restart your server ensuring that mz-electrical is ensured/starts after qb-core starts (ideally it should just form part of your [qb] folder).

