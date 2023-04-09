GUNCRAFT = GUNCRAFT or {}

GUNCRAFT.config = GUNCRAFT.config or {}

--[[-------------------------------------------------------------------------

GUNCRAFT CONFIG
Tutorial: https://www.youtube.com/watch?v=BtGmpI-kwd8

---------------------------------------------------------------------------]]

-- Set to "true" to enable development/debugging commands and options: (should be "false" for any active server)
GUNCRAFT.config.devmode = true
-- Default: false

-- The price of the weapon workbench:
GUNCRAFT.config.workbenchPrice = 500
-- Default: 500

-- The maximum amount of workbenches that one player can buy:
GUNCRAFT.config.workbenchAmount = 2
-- Default: 1

-- Whether players are allowed to sell their workbench from the workbench menu:
GUNCRAFT.config.allowBenchSelling = true
-- Set to "true" to allow selling and "false" to restrict selling.

-- Whether workbenches can or cannot be frozen using the workbench menu:
GUNCRAFT.config.allowBenchFreezing = true
-- Set to "true" to allow freezing and "false" to restrict freezing.

-- The cost of 1 material:
GUNCRAFT.config.materialPrice = 8
-- Default: 8

-- The amount of money you get for selling 1 material:
GUNCRAFT.config.materialResell = 5
-- Default: GUNCRAFT.config.materialPrice minus a few bucks.

-- The delay (in seconds) players have to wait between material purchasing:
GUNCRAFT.config.buyDelay = 600
GUNCRAFT.config.buyDelayDonator = 480

-- The minimum amount of materials a player can buy at a time:
GUNCRAFT.config.minBuy = 25

-- The maximim amount of materials a player can buy at a time:
GUNCRAFT.config.maxBuy = 5000
GUNCRAFT.config.maxBuyDonator = 7500

--[[The in-game names of the teams/jobs that are able to use guncraft (gundealers):
GUNCRAFT.config.gunTeams = {
    "Gun Dealer",
    "Arms Dealer",
    "Gundealer",
}
Default: "Gun Dealer" 
--]] 

-- If "true", all jobs can use Guncraft fully:
GUNCRAFT.config.allJobs = true
-- Default: false

-- The ULX usergroups who should be considered donators:
GUNCRAFT.donatorRanks = {
    "superadmin",
    "developer",
    "donator",
    "vip",
    "gold",
    "gold_member",
}

-- The minimum ULX rank that is required to perform fundamental changes to Guncraft (e.g. change the NPC position)
GUNCRAFT.config.superRank = "superadmin"
-- Default: Superadmin/Owner and above.

-- It takes the following number multiplied by the weapon's craft-time to craft a shipment of that weapon:
GUNCRAFT.config.shipmentTimeMultiplier = 9.5

-- It costs the following number multiplied by the weapon's material-price to craft a shipment of that weapon:
GUNCRAFT.config.shipmentPriceMultiplier = 9

-- Same idea as the two points above, just this time with the amount of experience points a player gets for crafting a shipment:
GUNCRAFT.config.shipmentXPMultiplier = 5

-- The level (not amount of experience points) that is required for players to be able to craft shipment versions of weapons:
GUNCRAFT.config.shipmentLevel = 5 --Level, not points

-- The chat command for checking how many materials you have:
GUNCRAFT.config.materialChatCommand = "/materials"
-- Default: "/materials"

-- The chat command for checking how much experience you have:
GUNCRAFT.config.expChatCommand = "/experience"
-- Default: "/experience"

-- The chat command for dropping a crate of materials:
GUNCRAFT.config.dropMatsChatCommand = "/dropmaterials"
-- Default: "/dropmaterials"

-- The different crafting-levels and the amount of experience points they require to reach: ( FORMAT: [<level>] = <experience> )
GUNCRAFT.config.levels = {
    [12] = 1500,
	[11] = 1200,
    [10] = 1000,
    [9] = 600,
    [8] = 400,
    [7] = 250,
    [6] = 180,
    [5] = 150,
    [4] = 80,
    [3] = 40,
    [2] = 20,
    [1] = 0
}

--[[----------------------------------------------------------------------------

    SQL CONFIGURATION
    Please note: MySQL support is currently unavailable. Do NOT enable MySQL. This will be fixed in a future version.

----------------------------------------------------------------------------]]--


GUNCRAFT.config.database = GUNCRAFT.config.database or {}

-- If you want to use MySQL with Guncraft, you need tmysql4: https://facepunch.com/showthread.php?t=1442438

-- Set to "true" to use MySQL for storing player data. (WARNING: Do NOT enable this unless you know what you are doing!)
GUNCRAFT.config.database.enabled = false
-- Default = "false"

-- The IP of the MySQL database.
GUNCRAFT.config.database.host = "127.0.0.1"

-- The port for the MySQL database.
GUNCRAFT.config.database.port = 3306
-- Default: 3306

-- The username for the MySQL database.
GUNCRAFT.config.database.user = "username"

-- The password for the MySQL database.
GUNCRAFT.config.database.password = "password"

-- The name of the MySQL database where the data should be stored.
GUNCRAFT.config.database.database = "database"

--[[-------------------------------------------------------------------------
END OF CONFIG
---------------------------------------------------------------------------]]
