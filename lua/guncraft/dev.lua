if GUNCRAFT.config.devmode then

concommand.Add( "gc_dev_addmats", function( ply, argS, args )

	GUNCRAFT.AddMats( ply, tonumber( args[1] ) )

	ply:PrintMessage( HUD_PRINTTALK, "Added " .. args[1] .. " materials." )

end )

concommand.Add( "gc_dev_submats", function( ply, argS, args )

	GUNCRAFT.SubMats( ply, tonumber( args[1] ) )

	ply:PrintMessage( HUD_PRINTTALK, "Subtracted " .. args[1] .. " materials." )

end )

concommand.Add( "gc_dev_setexp", function( ply, argS, args )

	local amount = tonumber( args[1] )

	ply:SetNWInt( "guncraft_experience", amount )

	GUNCRAFT.SavePlayerData( ply )

	ply:PrintMessage( HUD_PRINTTALK, "Set experience to " .. amount .. "." )

end )

concommand.Add( "gc_dev_unfreeze", function( ply )

	ply:Freeze( false )

end )

end -- Devmode check end.
