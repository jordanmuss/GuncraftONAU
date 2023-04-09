include("shared.lua")

surface.CreateFont("wb_header0", {
	font = "Arial",
	size = 80,
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
surface.CreateFont("wb_header1", {
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

function ENT:Draw()

	self:DrawModel()

	local distance = self:GetPos():Distance( LocalPlayer():GetPos() )

	if distance > 600 then return end

	local alpha = 0

	if distance <= 600 then
		percent = ( ( distance - 500 ) / 100 )
		percent = 1 - percent
		alpha = percent * 255
		if distance <= 500 then
			alpha = 255
		end
	end

	local owner = self:GetNWString( "guncraft_ownerNick" ) or "UNKNOWN"

    local ang = self:GetAngles()

    ang:RotateAroundAxis( self:GetAngles():Up() , 90 )

	cam.Start3D2D( self:GetPos() + ang:Up() * 31, ang, 0.1 )

	   	draw.RoundedBox( 2, -290, -150, 580, 60, Color( 0, 0, 0, alpha - 25 ) ) -- Name Box
	   	draw.SimpleTextOutlined( owner.."'s Weapon Workbench" , "wb_header1" , 0, -120, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, alpha ) ) -- Name Text

	   	draw.RoundedBox( 2, -290, -80, 580, 230, Color( 0, 0, 0, alpha - 25 ) ) -- Status Box
	   	draw.RoundedBox( 2, -280, -10, 560, 150, Color( 0, 0, 0, alpha - 55 ) ) -- Progress Bar Box

	cam.End3D2D()

	if ( self:GetNWBool( "guncraft_isWorking" ) ) then self:DrawProgress() end

end

local maxBoxWidth = 550

function ENT:DrawProgress()

	local startTime = self:GetNWInt( "guncraft_craftStartTime")
	local mulTime = self:GetNWInt( "guncraft_weaponCraftTime" ) * GUNCRAFT.config.shipmentTimeMultiplier
	local wepName = self:GetNWString( "guncraft_weaponCraftName" )

	local ang = self:GetAngles()

	ang:RotateAroundAxis( self:GetAngles():Up() , 90 )

	cam.Start3D2D( self:GetPos() - Vector( 0, 0, -31 ), ang, 0.1 )

		local boxWidth = ( ( CurTime() - startTime ) / mulTime ) * 550
		if boxWidth >= maxBoxWidth then boxWidth = maxBoxWidth end

		draw.SimpleTextOutlined( wepName.." Shipment" , "wb_header1" , 0, -45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) ) -- Crafting Text
		draw.RoundedBox( 2, -275, -5, boxWidth, 140, Color( 85, 153, 16 ) ) -- Progress Bar
		draw.SimpleTextOutlined( math.floor( ( ( CurTime() - startTime ) / mulTime ) * 100 ).."%", "wb_header0", 0, 60, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 150 ) ) -- Percent Indicator

	cam.End3D2D()

end
