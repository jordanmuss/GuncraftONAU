
if GUNCRAFT.config.database.enabled then

require( "tmysql4" )

local function fp_sqlError( err )

	local errMsg = tostring( err )
	print( "[GC_SQL]: ERROR: " .. errMsg )

end

local database, dError = tmysql.Create( GUNCRAFT.config.database.host, GUNCRAFT.config.database.user, GUNCRAFT.config.database.password, GUNCRAFT.config.database.database, GUNCRAFT.config.database.port, nil, CLIENT_MULTI_STATEMENTS )

if not database then

	fp_sqlError( dError )
	return

end

local status, cError = database:Connect()

if not status then

	fp_sqlError( cError )
	return

end

local function TableCheckQuery( results )

	if results[1].error then fp_sqlError( results[1].error ) end

end
database:Query( "CREATE TABLE IF NOT EXISTS guncraft_player (steamid varchar(255), name varchar(255), experience decimal(255,55), materials decimal(255,55), weapons_crafted int(255), shipments_crafted int(255))", TableCheckQuery )

function GUNCRAFT.LoadPlayerData( ply )

	if not ply:IsValid() or not ply:IsPlayer() then return end

	local function entryCheckQuery( results )

		if results[1].error then fp_sqlError( results[1].error ) return end

		if results[1].affected > 0 then

			ply:SetNWInt( "guncraft_materials", results[1].data[1].materials )
			ply:SetNWInt( "guncraft_experience", results[1].data[1].experience )
			ply:SetNWInt( "guncraft_weapons_crafted", results[1].data[1].weapons_crafted )
			ply:SetNWInt( "guncraft_shipments_crafted", results[1].data[1].shipments_crafted )

			if results[1].data[1].name ~= ply:Name() then

				local function nameUpdateQuery( results )

					if results[1].error then fp_sqlError( results[1].error )

						return

					end

				end
				database:Query( string.format( "UPDATE guncraft_player SET name = '%s' WHERE steamid = '%s'", database:Escape( ply:Name() ), ply:SteamID() ), nameUpdateQuery )

			end

		else

			local function newEntryQuery( results )

				if results[1].error then fp_sqlError( results[1].error ) return end

			end
			database:Query( string.format( "INSERT INTO guncraft_player VALUES ('%s', '%s', 0, 0, 0, 0)", ply:SteamID(), database:Escape( ply:Name() ) ), newEntryQuery )

		end

	end
	database:Query( string.format( "SELECT name, experience, materials, weapons_crafted, shipments_crafted FROM guncraft_player WHERE steamid = '%s'", ply:SteamID() ), entryCheckQuery )

end -- END OF SQL DATABASE CHECK

function GUNCRAFT.SavePlayerData( ply )

	if not ply:IsValid() or not ply:IsPlayer() then return end

	local mats = ply:GetNWInt( "guncraft_materials" )
	local exp = ply:GetNWInt( "guncraft_experience" )
	local weps = ply:GetNWInt( "guncraft_weapons_crafted" )
	local ships = ply:GetNWInt( "guncraft_shipments_crafted" )

	local function dataUpdateQuery( results )

		if results[1].error then fp_sqlError( results[1].error ) return end

	end
	database:Query( string.format( "UPDATE guncraft_player SET experience = %s, materials = %s, weapons_crafted = %s, shipments_crafted = %s WHERE steamid = '%s'", exp, mats, weps, ships, ply:SteamID() ), dataUpdateQuery )

end

else

function GUNCRAFT.LoadPlayerData( ply )

	if not ply:IsValid() or not ply:IsPlayer() then return end

	ply:SetNWInt( "guncraft_materials", ply:GetPData( "guncraft_materials", 0 ) )
	ply:SetNWInt( "guncraft_experience", ply:GetPData( "guncraft_experience", 0 ) )
	ply:SetNWInt( "guncraft_weapons_crafted", ply:GetPData( "guncraft_weapons_crafted", 0 ) )
	ply:SetNWInt( "guncraft_shipments_crafted", ply:GetPData( "guncraft_shipments_crafted", 0 ) )

end

function GUNCRAFT.SavePlayerData( ply )

	if not ply:IsValid() or not ply:IsPlayer() then return end

	ply:SetPData( "guncraft_materials", ply:GetNWInt( "guncraft_materials" ) )
	ply:SetPData( "guncraft_experience", ply:GetNWInt( "guncraft_experience" ) )
	ply:SetPData( "guncraft_weapons_crafted", ply:GetNWInt( "guncraft_weapons_crafted" ) )
	ply:SetPData( "guncraft_shipments_crafted", ply:GetNWInt( "guncraft_shipments_crafted" ) )

end

end

hook.Add( "PlayerInitialSpawn", "GetGuncraftPlayerData:PlayerInitialSpawn", function( ply )

	GUNCRAFT.LoadPlayerData( ply )

end )

hook.Add( "PlayerDisconnected", "SaveGuncraftPlayerData:PlayerDisconnected", function( ply )

	GUNCRAFT.SavePlayerData( ply )

end )

hook.Add( "ShutDown", "CloseConnection:ShutDown", function()

	for _,ply in pairs( player.GetAll() ) do

		GUNCRAFT.SavePlayerData( ply )

	end

	if GUNCRAFT.config.database.enabled then database:Disconnect() end

end )

--[[
MATERIAL NPC HANDLING
]]

function GUNCRAFT.SpawnNPC()

    for _,ent in pairs( ents.GetAll() ) do

        if ent:GetClass() == "npc_material" then

            ent:Remove()

        end

    end

    local npcData = file.Read("gc_json/material_npcpos.txt")
    if not npcData or npcData == "" then
        print("[GC_SQL]: No NPC position data found.")
        return
    end

    local plain = util.JSONToTable(npcData)

    local npc = ents.Create("npc_material")
    npc:SetPos(plain.pos)
    npc:SetAngles(plain.ang)
    npc:DropToFloor()
    npc:Spawn()

end


hook.Add( "InitPostEntity", "SpawnGuncraftNPCs:InitPostEntity", function()

	timer.Simple( 5, function()

		GUNCRAFT.SpawnNPC()

	end )

end )

function GUNCRAFT.SetNPCPos( pos, ang )

	local tab = {
		pos = pos,
		ang = ang,
	}

	local data = util.TableToJSON( tab, true )

	file.CreateDir( "gc_json" )
	file.Write( "gc_json/material_npcpos.txt", data )

	GUNCRAFT.SpawnNPC()

end

concommand.Add( "guncraft_setnpcpos", function( ply, argStr, args )

	if ply:CheckGroup( GUNCRAFT.config.superRank ) then

		GUNCRAFT.SetNPCPos( ply:GetPos(), ply:GetAngles() )
		FPLib.Notify( ply, "NPC location successfully set!", 0 )

	else

		FPLib.Notify( ply, "Insufficient ULX rank.", 1 )

	end

end )
