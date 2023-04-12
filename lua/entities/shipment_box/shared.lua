ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Shipment Box"
ENT.Author = "Jordan"
ENT.Spawnable = false
ENT.AdminSpawnable = false



function ENT:Initialize()
    self:SetupDataTables()
  end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "WeaponsLeft")
    self:NetworkVar("String", 0, "WeaponClass")
end

function ENT:GetWeaponClass()
    return self:GetNWString("WeaponClass", classname)
  end