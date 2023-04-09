local FILES = FILES or {}

FILES.server = {
	"guncraft_config.lua",
	"guncraft/sh_weaponincluder.lua",
	"guncraft_weapons.lua",
	"guncraft/database.lua",
	"guncraft/sh_base.lua",
	"guncraft/workbench.lua",
	"guncraft/npc.lua",
	"guncraft/dev.lua",
	"guncraft/chat.lua",
	"guncraft/sh_basewars.lua",
}

FILES.client = {
	"guncraft_config.lua",
	"guncraft/sh_weaponincluder.lua",
	"guncraft_weapons.lua",
	"guncraft/sh_base.lua",
	"guncraft/cl_workbench.lua",
	"guncraft/cl_npc.lua",
	"guncraft/sh_basewars.lua",
}

local function lib_print( msg, breaker )

	local prefix = "[GC_"

	local breaker = breaker or false
	local msg = msg or "#ERROR IN PRINT FUNCTION!"

	if breaker then print( "|----------|" ) end

	if SERVER then

		print( prefix .. "SV]: " .. msg )

	end

	if CLIENT then

		print( prefix .. "CL]: " .. msg )

	end

	if breaker then print( "|----------|" ) end

end

if SERVER then

	lib_print( "Intializing serverside:", true )

	lib_print( "Adding clientside files..." )

	for k,file in pairs( FILES.client ) do

		lib_print( file .. " added." )
		AddCSLuaFile( file )

	end

	lib_print( "Adding serverside files..." )

	for k,file in pairs( FILES.server ) do

		lib_print( file .. " added." )
		include( file )

	end

	lib_print( "Serverside intialization complete!", true )

end

if CLIENT then

	lib_print( "Intializing clientside:", true )

	lib_print( "Including clientside files from server..." )

	for k,file in pairs( FILES.client ) do

		lib_print( file.." included." )
		include( file )

	end

	lib_print( "Clientside intialization complete!", true )

end

lib_print( "Initalizing FPVGUI:", true )

include( "fpvgui/fpvgui_init.lua" )

lib_print( "Initialization complete!", true )
