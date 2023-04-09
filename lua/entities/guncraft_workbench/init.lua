AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("guncraft_initWorkbench")

function ENT:Initialize()

	self:SetModel( "models/props/cs_italy/it_mkt_table3.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:AcceptInput(name, activator, caller)

	net.Start( "guncraft_initWorkbench" )
		net.WriteTable( {
			bench = self,
			level = GUNCRAFT.GetLevel( caller ),
			materials = GUNCRAFT.GetMats( caller )
			} )
	net.Send( caller )

end
