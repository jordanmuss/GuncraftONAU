AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("UpdateCrateWeaponsLeft") 

function ENT:Initialize()
    self.Destructed = false
    self:SetModel("models/Items/item_item_crate.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
    self.damage = 100

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:Wake()
    end

end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
    if not self.locked then
        self.damage = self.damage - dmg:GetDamage()
        if self.damage <= 0 then
            self:Destruct()
        end
    end
end

function ENT:StartTouch(ent)
    if not ent:IsPlayer() and ent:GetClass() == "shipment_box" then
      -- Get the ent index of the other crate
      local otherIndex = ent:EntIndex()
      -- Get the current WeaponsLeft value for the other crate
      local otherWeaponsLeft = ent:GetWeaponsLeft()
      -- Set our own WeaponsLeft to whatever the other crate had
      self:SetWeaponsLeft(otherWeaponsLeft)
      -- Set the WeaponsLeft for the other crate to zero
      -- This is to ensure each crate has its own separate count
      ent:SetWeaponsLeft(0)
      print("Other crate had " .. otherWeaponsLeft .. " weapons left.")
    end
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if self:GetWeaponsLeft() > 0 then
        self:SetWeaponsLeft(self:GetWeaponsLeft() - 1)
        local weapon = ents.Create("spawned_weapon")
        weapon:SetWeaponClass(self:GetWeaponClass())
        weapon:SetPos(self:GetPos() + self:GetAngles():Up() * 40)
        weapon:Spawn()
        weapon:Activate()
    end
    if self:GetWeaponsLeft() <= 0 then
        self:Remove()
    end

end