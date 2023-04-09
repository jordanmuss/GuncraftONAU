ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spawned Weapon"
ENT.Author = "Jordan"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "WeaponClass")
    self:NetworkVar("String", 1, "Model")
end
