ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Guncraft Material NPC (Material Mikey)"
ENT.Author = "Fillipuster"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end
