surface.CreateFont("GUNCRAFT_NameplateFont", {
	font = "Trebuchet MS",
	size = 50,
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

function buyMaterials( amount )

	net.Start( "guncraft_buyMaterials" )
		net.WriteFloat( amount )
	net.SendToServer()

end

function sellMaterials( amount )

	net.Start( "guncraft_sellMaterials" )
		net.WriteFloat( amount )
	net.SendToServer()

end

net.Receive( "npc_material", function()

	local mats = tonumber( GUNCRAFT.GetMats( LocalPlayer() ) )

	--local isGundealer = false
	--for _,gunTeam in pairs( GUNCRAFT.config.gunTeams ) do
	--	if team.GetName( LocalPlayer():Team() ) == gunTeam then
	--		isGundealer = true
	--		break
	--	end
	--end
	if GUNCRAFT.config.allJobs then isGundealer = true end

	local frame = vgui.Create( "fp_frame" )
	frame:SetSize( 300, 300 )
	frame:Center()
	frame:SetRubrik( "Material Mikey" )
	frame:MakePopup()


	local sayLbl = vgui.Create( "fp_label", frame )
	if isGundealer then
		sayLbl:SetText( [[Hi there, I'm Mikey Daniels aka. Material Mikey.
			If you need materials for crafting, I'm you guy!
			Just let me know how many materials you need.]] )
	else
		sayLbl:SetText( [[Oh, hi. I'm Material Mikey.
			I sell materials for gun manifacturing.
			You don't look like a gundealer...]] )
	end
	sayLbl:SetPos( 10, 30 )

	amountLbl = vgui.Create( "fp_label", frame )
	amountLbl:SetText( "Your current materials: " .. LocalPlayer():GetNWInt( "guncraft_materials" ) )
	amountLbl:SetPos( 10, 75 )

	local priceLbl = vgui.Create( "fp_label", frame )
	priceLbl:SetText( "Price per material: " .. GUNCRAFT.config.materialPrice )
	priceLbl:SetPos( 10, 90 )

	local resellLbl = vgui.Create( "fp_label", frame )
	resellLbl:SetText( "Material re-sell value: " .. GUNCRAFT.config.materialResell )
	resellLbl:SetPos( 10, 105 )

	local selector = vgui.Create( "DNumSlider", frame )
	selector:SetPos( 10, 85 ) --130
	selector:SetSize( 275, 100 ) --20
	selector:SetText( "Materials to buy/sell: " )
	selector:SetMin( GUNCRAFT.config.minBuy )
	if GUNCRAFT.IsDonator( LocalPlayer() ) then
		selector:SetMax( GUNCRAFT.config.maxBuyDonator )
		selector:SetValue( GUNCRAFT.config.maxBuyDonator )
	else
		selector:SetMax( GUNCRAFT.config.maxBuy )
		selector:SetValue( GUNCRAFT.config.maxBuy )
	end
	selector:SetDecimals( 0 )
	function selector:Paint()

		draw.SimpleText( math.floor( self:GetValue() ), "fp_header3", 130, 80, Color( 255, 255, 255, 255 ), 1, 1 )
		draw.SimpleText( "($" .. math.floor( self:GetValue() ) * GUNCRAFT.config.materialPrice .. ")  BUY", "fp_bread", 220, 70, Color( 255, 255, 255, 255 ), 1, 1 )
		draw.SimpleText( "($" .. math.floor( self:GetValue() ) * GUNCRAFT.config.materialResell .. ") SELL", "fp_bread", 220, 90, Color( 255, 255, 255, 255 ), 1, 1 )

	end

	local buyBtn = vgui.Create( "fp_button", frame )
	buyBtn:SetText( "Purchase Materials" )
	buyBtn:SetSize( 110, 40 )
	buyBtn:SetPos( 165, 200 )
	buyBtn:Bold( false )
	-- if not isGundealer then buyBtn:SetEnabled( false ) buyBtn:SetText( "Gundealers Only" ) end
	buyBtn.DoClick = function()
		local amt = math.floor( selector:GetValue() )
		buyMaterials( amt )
	end

	local sellBtn = vgui.Create( "fp_button", frame )
	sellBtn:SetText( "Sell Materials" )
	sellBtn:SetSize( 110, 40 )
	sellBtn:SetPos( 150-50-75, 200 )
	sellBtn:Bold( false )
	if mats <= 0  then sellBtn:SetEnabled( false ) end
	sellBtn.DoClick = function()
		local amt = math.floor( selector:GetValue() )
		sellMaterials( amt )
	end

	local sellAllBtn = vgui.Create( "fp_button", frame )
	sellAllBtn:SetText( "Sell All Materials" )
	sellAllBtn:SetSize( 110, 25 )
	sellAllBtn:SetPos( 150-50-75, 255 )
	sellAllBtn:Bold( false )
	if mats <= 0  then sellAllBtn:SetEnabled( false ) end
	sellAllBtn.DoClick = function()
		sellMaterials( GUNCRAFT.GetMats( LocalPlayer() ) )
	end

end )

net.Receive( "guncraft_materialsVGUIUpdate", function()

	amountLbl:SetText( "Your current materials: " .. net.ReadFloat() )
	amountLbl:SizeToContents()

end )

concommand.Add( "fp_qd", function()

	frame:Remove()

end )
