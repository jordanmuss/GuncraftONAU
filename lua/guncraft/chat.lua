hook.Add( "PlayerSay", "CheckMaterialsCommand:PlayerSay", function( ply, text, team )

	if string.sub( text, 1, string.len( GUNCRAFT.config.materialChatCommand ) ) == GUNCRAFT.config.materialChatCommand then

		ply:PrintMessage( HUD_PRINTTALK, string.format( "You currently have %s materials.", GUNCRAFT.GetMats( ply ) ) )

		return ""

	end

end )

hook.Add( "PlayerSay", "CheckExpCommand:PlayerSay", function( ply, text, team )

	if string.sub( text, 1, string.len( GUNCRAFT.config.expChatCommand ) ) == GUNCRAFT.config.expChatCommand then

		ply:PrintMessage( HUD_PRINTTALK, string.format( "You currently have %s experience in weapon crafting. You are level %s.", GUNCRAFT.GetExp( ply ), GUNCRAFT.GetLevel( ply ) ) )

		return ""

	end

end )

hook.Add( "PlayerSay", "DropMaterialsCommand:PlayerSay", function( ply, text, team )

	if string.sub( text, 1, string.len( GUNCRAFT.config.dropMatsChatCommand ) ) == GUNCRAFT.config.dropMatsChatCommand then

		local userInput = string.Explode( " ", text )

		if userInput[2] then

			if tonumber( userInput[2] ) > tonumber( GUNCRAFT.GetMats( ply ) ) then

				FPLib.Notify( ply, string.format( "You don't have %s materials to drop.", userInput[2] ), 1 )
				return ""

			end

			if tonumber( userInput[2] ) <= 0 then

				FPLib.Notify( ply, "You cannot drop 0 materials, you dummy!", 1 )
				return ""

			end

			local tr = ply:GetEyeTrace()

			local box = ents.Create( "guncraft_materialbox" )
			box:SetPos( tr.HitPos )
			box:SetNWInt( "contents_materials", tonumber( userInput[2] ) )
			box:Spawn()

			GUNCRAFT.SubMats( ply, tonumber( userInput[2] ) )

			FPLib.Notify( ply, string.format( "You dropped a box of %s materials. Press 'E' to pick it up.", userInput[2] ), 0 )

		else

			ply:PrintMessage( HUD_PRINTTALK, "Usage: '" .. GUNCRAFT.config.dropMatsChatCommand .. " <amount>' - Drops a box of your materials on the floor." )

		end

		return ""

	end

end )
