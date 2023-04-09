surface.CreateFont("gc_header1", {
	font = "Arial",
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

function craftWeapon( wepKey, bench )

	net.Start( "guncraft_craftSingle" )
		net.WriteFloat( wepKey )
		net.WriteEntity( bench )
	net.SendToServer()

	timer.Simple( GUNCRAFT.config.weapons[wepKey].time, function()

		hook.Remove( "HUDPaint", "DrawProgress:HUDPaint" )

	end )

	local prevTime = CurTime()

	local w, h = ScrW(), ScrH()

	hook.Add( "HUDPaint", "DrawProgress:HUDPaint", function()

		-- corner, x, y, width, height
		--draw.RoundedBox(number cornerRadius,number x,number y,number width,number height,table color)
		if ( CurTime() - prevTime ) / GUNCRAFT.config.weapons[wepKey].time < 1 then

			draw.SimpleTextOutlined( "Crafting: " .. GUNCRAFT.config.weapons[wepKey].name, "fp_header3", w * 0.5, h * 0.5 - 50, Color( 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0 ) )
			draw.RoundedBox( 2, w * 0.5 - 200, h * 0.5 - 25, 400, 50, Color( 0, 0, 0, 200 ) )
			draw.RoundedBox( 2, w * 0.5 - 195, h * 0.5 - 20, ( ( CurTime() - prevTime ) / GUNCRAFT.config.weapons[wepKey].time ) * 390, 40, Color( 20, 180, 250, 255 ) )
			draw.SimpleTextOutlined( math.floor( ( ( CurTime() - prevTime ) / GUNCRAFT.config.weapons[wepKey].time ) * 100 ) .. "%", "gc_header1", w * 0.5, h * 0.5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 150 ) )

		end

	end )

end

function craftShipment( wepKey, bench )

	net.Start( "guncraft_craftShipment" )
		net.WriteFloat( wepKey )
		net.WriteEntity( bench )
	net.SendToServer()

end

function confirmCraft( wepKey, wep, ship, workbench )

	local msg = "Are you sure you want to craft a " .. wep.name .. "?"
	if ship then msg = "Are you sure you want to craft a shipment of " .. wep.name .. "s?" end

	local frame = vgui.Create( "fp_frame" )
	frame:SetSize( 350, 85 )
	frame:Center()
	frame.title = "Confirm Crafting"
	frame:MakePopup()

	local lbl = vgui.Create( "fp_label", frame )
	lbl:SetText( msg )
	lbl:SetPos( 10, 30 )

	local confirm = vgui.Create( "fp_button", frame )
	confirm:SetText( "Yes" )
	confirm:SetSize( 50, 25 )
	confirm:SetPos( 350 / 2 - 60, 50 )
	confirm.DoClick = function()
		frame:Remove()
		if ship then craftShipment( wepKey, workbench ) else craftWeapon( wepKey, workbench ) end
	end

	local deny = vgui.Create( "fp_button", frame )
	deny:SetText( "No" )
	deny:SetSize( 50, 25 )
	deny:SetPos( 350 / 2, 50 )
	deny.paintColor = Color( 200, 20, 20 )
	deny.DoClick = function()
		frame:Remove()
	end

end

net.Receive( "guncraft_initWorkbench", function()
	--[[
	ASSIGNING MODELS TO CLIENT-SIDE WEAPON CONFIG
	

	for _, globalWep in pairs( weapons.GetList() ) do
		for k, localWep in pairs( GUNCRAFT.config.weapons ) do
			if globalWep.ClassName == localWep.class then
				if globalWep.WorldModel == nil then
					GUNCRAFT.config.weapons[k].model = "models/weapons/w_pist_fiveseven.mdl"
				else
					GUNCRAFT.config.weapons[k].model = tostring( globalWep.WorldModel )
				end
				print("Assigned model:", GUNCRAFT.config.weapons[k].model) -- Add this line
			end
		end
	end	
    
	]]--

	-- LEVEL PROGRESS BAR --

	local plyExp = GUNCRAFT.GetExp( LocalPlayer() )
	local plyLevel = GUNCRAFT.GetLevel( LocalPlayer() )

	local curLvlExp = GUNCRAFT.config.levels[plyLevel]
	local nextLvlExp = curLvlExp

	if plyLevel < #GUNCRAFT.config.levels then
		nextLvlExp = GUNCRAFT.config.levels[plyLevel + 1]
	end

	local rel = ( plyExp-curLvlExp ) / ( nextLvlExp-curLvlExp )

	local lvlFrame = vgui.Create( "fp_frame" )
	lvlFrame:SetSize( 200, 500 )
	lvlFrame:SetPos( ScrW() / 2 + 260, ScrH() / 2 - 250 )
	lvlFrame.title = "Crafting Level Progress"
	lvlFrame:MakePopup()

	local levelProgressBar = vgui.Create( "DPanel", lvlFrame )
	levelProgressBar:SetPos( 5, 30 )
	levelProgressBar:SetSize( 90, 465 )
	function levelProgressBar:Paint( w, h )

		draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 0, 0, 150 ) ) -- Base

		if rel > 0.06 then

			draw.RoundedBox( 2, 5, h - ( rel * h ) + 5, w-10, rel * h - 10, Color( 20, 180, 250, 255 ) ) -- Bar

			draw.SimpleTextOutlined( plyExp, "fp_bread", 45, h - ( rel * h ) + 13, Color( 255, 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 100 ) )

		end

	end

	local nextLvlLbl = vgui.Create( "fp_label", lvlFrame )
	nextLvlLbl:SetText( nextLvlExp )
	nextLvlLbl:SetPos( 100, 30 )
	nextLvlLbl:Header( 3 )

	local curLvlLbl = vgui.Create( "fp_label", lvlFrame )
	curLvlLbl:SetText( curLvlExp )
	curLvlLbl:SetPos( 100, 470 )
	curLvlLbl:Header( 3 )

	local lvlLbl = vgui.Create( "fp_label", lvlFrame )
	lvlLbl:SetText( "CURRENT LEVEL" )
	lvlLbl:SetPos( 140 - 35, 30 + 170 )

	local xpLAmtbl = vgui.Create( "fp_label", lvlFrame )
	xpLAmtbl:SetText( plyLevel )
	xpLAmtbl:Header( 2 )
	local pos = 135
	if plyLevel >= 10  then pos = 125 end
	xpLAmtbl:SetPos( pos, 210 )

	-- MAIN MENU --

	local data = net.ReadTable()

	local mats = tonumber( data.materials )
	local exp = data.level
	local workbench = data.bench

	local frame = vgui.Create( "fp_frame")
	frame:SetSize( 500, 500 )
	frame:Center()
	frame:SetRubrik( " Weapon Workbench" )
	frame:MakePopup()
	frame.OnRemove = function()

		lvlFrame:Remove()

	end
	frame.OnKeyCodePressed = function( panel, key )

		if key == KEY_E then

			panel:Remove()

		end

	end

	if GUNCRAFT.config.allowBenchFreezing then

		local freezeBtn = vgui.Create( "fp_button", frame )
		freezeBtn:SetText( "Freeze Bench" )
		freezeBtn:SetSize( 100, 25 )
		freezeBtn:SetPos( 290, 40 )
		freezeBtn.paintColor = Color( 0, 0, 0 )
		freezeBtn.DoClick = function()

			net.Start( "guncraft_freezeWorkbench" )
				net.WriteEntity( workbench )
			net.SendToServer()

		end

	end

	if GUNCRAFT.config.allowBenchSelling then

		local removeBtn = vgui.Create( "fp_button", frame )
		removeBtn:SetText( "Sell Bench" )
		removeBtn:SetSize( 75, 25 )
		removeBtn:SetPos( 400, 40 )
		removeBtn.paintColor = Color( 0, 0, 0 )
		removeBtn.DoClick = function()

			removeBtn:SetText( "Confirm?" )
			removeBtn.paintColor = Color( 200, 0, 0 )
			removeBtn.DoClick = function()

				local isInUse = false

				for _,pl in pairs( player.GetAll() ) do

					if pl:Name() == workbench:GetNWString( "guncraft_ownerNick" ) and pl:GetNWBool( "guncraft_isCrafting" ) == true then

						isInUse = true

					end

				end

				if isInUse or workbench:GetNWBool( "guncraft_isWorking" ) then

					FPLib.Notify( "You cannot sell a workbench while in use!", 1 )
					frame:Remove()
					lvlFrame:Remove()
					return

				end

				if LocalPlayer():Name() ~= workbench:GetNWString( "guncraft_ownerNick" ) then

					FPLib.Notify( "Only the owner of a bench can sell it.", 1 )
					frame:Remove()
					lvlFrame:Remove()
					return

				end

				net.Start( "guncraft_removeWorkbench" )
					net.WriteEntity( workbench )
				net.SendToServer()

				frame:Remove()

			end

		end

	end

	local matLbl = vgui.Create( "fp_label" , frame )
	matLbl:SetText( "MATERIALS" )
	matLbl:SetPos( 10, 30 )

	local matAmtLbl = vgui.Create( "fp_label" , frame )
	matAmtLbl:SetText( mats )
	matAmtLbl:Header( 2 )
	matAmtLbl:SetPos( 10, 40 )

	local wepList = vgui.Create( "fp_scrollPanel", frame )
	wepList:SetPos( 5, 80 )
	wepList:SetSize( 490, 415 )

	local wepItems = vgui.Create( "DIconLayout", wepList )
	wepItems:SetSize( 500, 500 )
	wepItems:SetSpaceY( 5 )

	for wepKey, wep in ipairs( GUNCRAFT.config.weapons ) do

		PrintTable(wep)

		if wep.job and wep.job ~= team.GetName(LocalPlayer():Team()) then
			continue
		end

		local item = wepItems:Add( "fp_panel" )
		item:SetSize( 470, 95 )

			local icon = vgui.Create( "DModelPanel", item )
			icon:SetPos( 0, 0 )
			icon:SetModel(GUNCRAFT.FetchWorldModel(wep.classname))
			icon:SetSize( 95, 95 )

			local mn, mx = icon.Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
			size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
			size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

			icon:SetFOV( 40 )
			icon:SetCamPos( Vector( size, size, size ) )
			icon:SetLookAt( (mn + mx) * 0.2 )

		local nameLbl = vgui.Create( "fp_label", item )
		nameLbl:SetText( "Weapon: " .. wep.name )
		nameLbl:SetPos( 100, 10 )

		local priceLbl = vgui.Create( "fp_label", item )
		priceLbl:SetText( "Materials: " .. wep.materials )
		priceLbl:SetPos( 100, 25 )
		if mats < wep.materials  then priceLbl:SetTextColor( Color( 153, 16, 16 ) ) end

		local priceSLbl = vgui.Create( "fp_label", item )
		priceSLbl:SetText( "Materials (Shipment): " .. ( wep.materials * GUNCRAFT.config.shipmentPriceMultiplier ) )
		priceSLbl:SetPos( 100, 40 )
		if mats < wep.materials * GUNCRAFT.config.shipmentPriceMultiplier  then priceSLbl:SetTextColor( Color( 153, 16, 16 ) ) end

		local xpLbl = vgui.Create( "fp_label", item )
		xpLbl:SetText( "Required Level: " .. wep.requiredLevel )
		if exp < wep.requiredLevel  then xpLbl:SetTextColor( Color( 153, 16, 16 ) ) end
		xpLbl:SetPos( 100, 55 )

		local retainPriceLbl = vgui.Create( "fp_label", item )
		retailPrice = ( wep.materials * 10 ) + ( wep.time * 5 )
		retainPriceLbl:SetText( "Recommended Price: " .. tostring( retailPrice ) )
		retainPriceLbl:SetPos( 100, 70 )

		local craftSingle = vgui.Create( "fp_button", item )
		craftSingle:SetText( "Craft Single" )
		craftSingle:SetPos( 250, 35 )
		craftSingle:SetSize( 85, 25 )
		craftSingle:Bold( false )
		if mats < wep.materials or exp < wep.requiredLevel  then craftSingle:SetEnabled( false ) end
		craftSingle.DoClick = function()
			confirmCraft( wepKey, wep, false, workbench )
			frame:Remove()
		end
--
		if not wep.disableShipment then

			local craftShipmentBtn = vgui.Create( "fp_button", item )
			craftShipmentBtn:SetText( "Craft Shipment" )
			craftShipmentBtn:SetPos( 345, 35 )
			craftShipmentBtn:SetSize( 85, 25 )
			craftShipmentBtn:Bold( false )
			if mats < ( wep.materials * GUNCRAFT.config.shipmentPriceMultiplier ) or exp < wep.requiredLevel or workbench:GetNWBool( "guncraft_isWorking" ) then craftShipmentBtn:SetEnabled( false ) end
			if exp < GUNCRAFT.config.shipmentLevel then craftShipmentBtn:SetEnabled( false ) craftShipmentBtn:SetText( "LVL " .. GUNCRAFT.config.shipmentLevel ) end
			craftShipmentBtn.DoClick = function()
				confirmCraft( wepKey, wep, true, workbench )
				frame:Remove()
			end

		end

	end

end )
