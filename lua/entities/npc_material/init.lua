/*---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------*/
local classname = "npc_material"
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("npc_material")

function ENT:Initialize()

	self:SetModel( "models/Humans/Group03/male_08.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()

	self:SetMaxYawSpeed( 90 )

end


function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end


function ENT:Draw()
	self:DrawModel()
end


function ENT:AcceptInput(name, activator, caller)

	net.Start("npc_material")
	net.Send(caller)

end
