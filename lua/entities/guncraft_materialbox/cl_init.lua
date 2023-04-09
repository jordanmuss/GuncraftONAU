include("shared.lua")

function ENT:Draw()

	self:DrawModel()

	if self:GetPos():Distance( LocalPlayer():GetPos() ) > 500 then return end

	local ang = Angle( ( LocalPlayer():GetPos() - self:GetPos() ):Angle()["roll"], ( LocalPlayer():GetPos() - self:GetPos() ):Angle()["yaw"], ( LocalPlayer():GetPos() - self:GetPos() ):Angle()["pitch"] ) + Angle( 0, 90, 90 )

	cam.Start3D2D( self:GetPos() + Vector( 0, 0, 17 ), ang, 0.1)

		draw.SimpleTextOutlined( self:GetNWInt( "contents_materials" ).." Materials", "fp_header2", 0, 0, Color( 255, 255, 255 ), 1, 1, 1, Color( 0, 0, 0, 200 ) )

	cam.End3D2D()

end
