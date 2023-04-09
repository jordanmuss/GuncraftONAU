AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("guncraft_initWorkbench")

function ENT:Initialize()

	self:SetModel( "models/props/cs_office/cardboard_box03.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	if not self:GetNWInt( "contents_materials" ) then self:SetNWInt( "contents_materials", 0 ) end
end

function ENT:AcceptInput(name, activator, caller)

	self:Remove()
	mats = self:GetNWInt( "contents_materials" ) or 0
	GUNCRAFT.AddMats( caller, mats )
	FPLib.Notify( caller, string.format( "You picked up %s materials.", mats ), 0 )

	if mats >= 1000 then -- Oh yeah!

		caller:EmitSound( "vo/npc/Barney/ba_ohyeah.wav" )


	end

    caller:EmitSound( "npc/combine_soldier/gear5.wav" )

end
