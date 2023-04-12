if not GUNCRAFT.CustomShipments then
    GUNCRAFT.CustomShipments = {}
end

resource.AddWorkshop( "907056173" )

	util.AddNetworkString( "guncraft_removeWorkbench" )
	util.AddNetworkString( "guncraft_craftSingle" )
	util.AddNetworkString( "guncraft_craftShipment" )
	util.AddNetworkString( "guncraft_freezeWorkbench" )

	util.PrecacheSound( "toolbox.wav" )

	sound.Add( {
		name = "toolbox",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 95, 110 },
		sound = "toolbox.wav"
	} )
	-- To be replaced with remotelua:

	net.Receive( "guncraft_freezeWorkbench", function( len, ply )

		local bench = net.ReadEntity()

		if not ply:IsValid() or not ply:IsPlayer() or not bench:IsValid() or ply:GetPos():Distance( bench:GetPos() ) > 500 then
			return
		end

		if ply.canFreezeBench == false then
			FPLib.Notify( ply, "Please wait a moment before attempting to freeze a workbench again.", 1 )
			return
		end

		local phys = bench:GetPhysicsObject()

		if IsValid( phys ) then

			if phys:IsMotionEnabled() then

				phys:EnableMotion( false )
				FPLib.Notify( ply, "Weapon Workbench Frozen.", 0 )

			else

				phys:EnableMotion( true )
				FPLib.Notify( ply, "Weapon Workbench Un-frozen.", 0 )

			end

		end

		ply.canFreezeBench = false

		timer.Simple( 3, function()

			ply.canFreezeBench = true

		end )

	end )

	local function createShipmentBox(ply, weaponClass, amount, pos) -- Function to create shipment box 
		local shipmentBox = ents.Create("shipment_box")
		-- shipmentBox:Setowning_ent(ply)
		shipmentBox:SetWeaponClass(weaponClass)
		shipmentBox:SetPos(pos)
		shipmentBox:Spawn()
		shipmentBox:SetPlayer(ply)
	
		local phys = shipmentBox:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
		end
	
		return shipmentBox
	end	

	hook.Add( "playerBoughtCustomEntity", "SetOwnership:playerBoughtCustomEntity", function( ply, entT, ent, price )

		if not ply:IsValid() then return end

		ent:SetNWString( "guncraft_ownerNick", ply:Nick() )
		ent:SetNWEntity( "guncraft_ownerEnt", ply )

	end )

	net.Receive( "guncraft_removeWorkbench", function( len, ply )

		local bench = net.ReadEntity()

		if not ply:IsValid() or not ply:IsPlayer() or not bench:IsValid() or not bench:GetClass() == "guncraft_workbench" or not bench:GetNWEntity( "guncraft_ownerEnt" ) == ply or ply:GetPos():Distance( bench:GetPos() ) > 500 then
			return
		else

			local returnValue = GUNCRAFT.config.workbenchPrice / 2

			bench:Remove()
			ply:AddMoney( returnValue )
			FPLib.Notify( ply, "You sold your weapons workbench for $" .. returnValue, 0 )

		end

	end )

	net.Receive( "guncraft_craftSingle", function( len, ply )

		if not ply:IsValid() or not ply:IsPlayer() then return end

		-- local isGundealer = true

		-- if GUNCRAFT.config.allJobs then isGundealer = true end

		-- if not isGundealer then
		--	FPLib.Notify( ply, "You do not have the correct job to craft weapons.", 1 )
		--	return
		-- end

		local wepKey = net.ReadFloat()
		local bench = net.ReadEntity()

		if not bench:IsValid() or bench:GetClass() ~= "guncraft_workbench" then return end

		if ply:GetPos():Distance( bench:GetPos() ) > 500 then
			FPLib.Notify( ply, "Please stand closer to the workbench when attempting to craft weapons.", 1 )
			return
		end

		if not GUNCRAFT.config.weapons[wepKey] then
			FPLib.Notify( ply, "Invalid weapon.", 1 )
			return
		end

		GUNCRAFT.config.weapons[wepKey].materials = tonumber( GUNCRAFT.config.weapons[wepKey].materials )

		local curMats = tonumber( GUNCRAFT.GetMats( ply ) )
		local curXP = tonumber( GUNCRAFT.GetExp( ply ) )

		if curMats < GUNCRAFT.config.weapons[wepKey].materials then

			FPLib.Notify( ply, "You don't have enough materials to craft a " .. GUNCRAFT.config.weapons[wepKey].name .. "." )
			return

		end

		if ply:GetNWBool( "guncraft_isCrafting" ) then

			FPLib.Notify( ply, "You cannot craft two items at at a time." )
			return

		end

		ply:SetNWBool( "guncraft_isCrafting", true )
		ply:Freeze( true )
		ply:EmitSound( "toolbox" )

		if GUNCRAFT.config.weapons[wepKey].time > 36 then

			timer.Simple( 35, function()

				ply:EmitSound( "toolbox" )

			end )

		end

		timer.Simple( GUNCRAFT.config.weapons[wepKey].time, function()

			if GUNCRAFT.config.weapons[wepKey].bypassFunc then

				GUNCRAFT.config.weapons[wepKey].bypassFunc( ply, GUNCRAFT.config.weapons[wepKey] )

			else

				local weapon = ents.Create( "spawned_weapon" )
				weapon:SetModel( GUNCRAFT.config.weapons[wepKey].model )
				weapon:SetWeaponClass( GUNCRAFT.config.weapons[wepKey].classname )
				weapon:SetPos( bench:GetPos() + Vector( 0, 0, 50 ) )
				if not GUNCRAFT.config.weapons[wepKey].disableAmmo then weapon.ammoadd = weapons.Get( GUNCRAFT.config.weapons[wepKey].classname ).Primary.DefaultClip end
				weapon.nodupe = true
				weapon:Spawn()

			end

			if GUNCRAFT.CalcLevel( curXP ) < GUNCRAFT.CalcLevel( curXP + GUNCRAFT.config.weapons[wepKey].experience ) then

				FPLib.Notify( ply, "You have reached level "..GUNCRAFT.CalcLevel( curXP + GUNCRAFT.config.weapons[wepKey].experience ).." in wepaon-crafting!", 0 )
				ply:EmitSound( "garrysmod/save_load1.wav" )

			end

			GUNCRAFT.SubMats( ply, GUNCRAFT.config.weapons[wepKey].materials )
			GUNCRAFT.AddExp( ply, GUNCRAFT.config.weapons[wepKey].experience )
			GUNCRAFT.WeaponCrafted( ply )

			ply:SetNWBool( "guncraft_isCrafting", false )

			ply:Freeze( false )
			ply:EmitSound( "items/ammocrate_open.wav" )
			ply:StopSound( "toolbox" )

		end )

	end )

	net.Receive( "guncraft_craftShipment", function( len, ply )

		local wepKey = net.ReadFloat()
		local bench = net.ReadEntity()

		if GUNCRAFT.config.weapons[wepKey].disableShipment then return end

		if not bench:IsValid() or bench:GetClass() ~= "guncraft_workbench" then return end

		if ply:GetPos():Distance( bench:GetPos() ) > 500 then
			FPLib.Notify( ply, "Please stand closer to the workbench when attempting to craft weapons.", 1 )
			return
		end

		if not GUNCRAFT.config.weapons[wepKey] then
			FPLib.Notify( ply, "Invalid weapon.", 1 )
			return
		end

		GUNCRAFT.config.weapons[wepKey].mats = tonumber( GUNCRAFT.config.weapons[wepKey].materials )

		bench:SetNWInt( "guncraft_craftStartTime", CurTime() )
		bench:SetNWInt( "guncraft_weaponCraftTime", GUNCRAFT.config.weapons[wepKey].time )
		bench:SetNWString( "guncraft_weaponCraftName", GUNCRAFT.config.weapons[wepKey].name )

		local curMats = tonumber( GUNCRAFT.GetMats( ply ) )
		local curXP = tonumber( GUNCRAFT.GetExp( ply ) )

		local mulTime = GUNCRAFT.config.weapons[wepKey].time * GUNCRAFT.config.shipmentTimeMultiplier

		if curMats < ( GUNCRAFT.config.weapons[wepKey].materials * GUNCRAFT.config.shipmentTimeMultiplier ) then

			FPLib.Notify( ply, "You don't have enough materials to craft a shipment of " .. GUNCRAFT.config.weapons[wepKey].name .. "s.", 1 )
			return

		end

		if bench:GetNWBool( "guncraft_isWorking" ) or ply:GetNWBool( "guncraft_isCrafting" ) then

			FPLib.Notify( ply, "You cannot craft two shipments at a time.", 1 )
			return

		end

		bench:SetNWBool( "guncraft_isWorking", true )
		bench:EmitSound( "toolbox" )

		if mulTime > 36 then

			timer.Simple( 35, function()

				bench:EmitSound( "toolbox" )

			end )

		end

		timer.Simple( mulTime, function()

			local foundShip, foundShipKey
	
			for key, ship in pairs(GUNCRAFT.CustomShipments) do
				if ship.entity == GUNCRAFT.config.weapons[wepKey].classname then
					foundShip = ship
					foundShipKey = key
				end
			end

			if not foundShip then
				FPLib.Notify(ply, "Shipment not found for the weapon: " .. GUNCRAFT.config.weapons[wepKey].name, 1)
				return
			end

			bench:SetNWBool( "guncraft_isWorking", false )

			if not foundShip then

				FPLib.Notify( ply, "There was an error getting the shipment. See chat.", 1 )
				ply:PrintMessage( HUD_PRINTTALK, "MESSAGE FOR SERVER OWNER:" )
				ply:PrintMessage( HUD_PRINTTALK, string.format( [["The shipment for the weapon '%s' could not be found. Please ensure Guncraft's weapons are properly set up."]], GUNCRAFT.config.weapons[wepKey].name ) )

			end

			local crate = createShipmentBox(ply, GUNCRAFT.config.weapons[wepKey].classname, foundShip.amount, bench:GetPos() + Vector(0, 0, 70))
			crate:SetWeaponClass(GUNCRAFT.config.weapons[wepKey].classname)
			crate:SetWeaponsLeft(10)
			crate.SID = ply.SID
			-- crate:SetContents(foundShipKey, foundShip.amount)
			crate:SetPos(bench:GetPos() + Vector(0, 0, 70))
			crate.nodupe = true
			if not GUNCRAFT.config.weapons[wepKey].disableAmmo then
				crate.ammoadd = weapons.Get(GUNCRAFT.config.weapons[wepKey].classname).Primary.DefaultClip
			end
			-- crate.clip1 = foundShip.clip1
			-- crate.clip2 = foundShip.clip2
			crate:Spawn()
			crate:SetPlayer(ply)

			local phys = crate:GetPhysicsObject()
			phys:Wake()
			if foundShip.weight then
				phys:SetMass(foundShip.weight)
			end

			if( GUNCRAFT.CalcLevel( curXP ) < GUNCRAFT.CalcLevel( curXP + ( GUNCRAFT.config.weapons[wepKey].experience * GUNCRAFT.config.shipmentXPMultiplier ) ) ) then

				FPLib.Notify( ply, "You have reached level " .. GUNCRAFT.CalcLevel( curXP + ( GUNCRAFT.config.weapons[wepKey].experience * GUNCRAFT.config.shipmentXPMultiplier ) ) .. " in wepaon-crafting!", 0 )
				ply:EmitSound( "garrysmod/save_load1.wav" )

			end

			GUNCRAFT.SubMats( ply, GUNCRAFT.config.weapons[wepKey].materials * GUNCRAFT.config.shipmentPriceMultiplier )
			GUNCRAFT.AddExp( ply, GUNCRAFT.config.weapons[wepKey].experience * GUNCRAFT.config.shipmentXPMultiplier )
			GUNCRAFT.ShipmentCrafted( ply )

			bench:EmitSound( "items/ammocrate_open.wav" )
			bench:StopSound( "toolbox" )

		end )

	end )

	-- end of remotelua replacement.
