
include("shared.lua")

function ENT:Initialize()
end

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

	surface.SetFont( "GUNCRAFT_NameplateFont" )
	local name = "Material Mikey"
	local wide = surface.GetTextSize( name )
	local ang = Angle( 0, ( LocalPlayer():GetPos() - self:GetPos()):Angle()["yaw"], (LocalPlayer():GetPos() - self:GetPos()):Angle()["pitch"]) + Angle(0, 90, 90)

	cam.Start3D2D( self:GetPos() + Vector( 0, 0, 80 ), ang, 0.1)

		draw.WordBox( 6, -wide/2, -25, name, "GUNCRAFT_NameplateFont", Color( 50, 50, 50, alpha - 35 ), Color( 255, 255, 255, alpha ) )

	cam.End3D2D()

end

function ENT:Think()
end
