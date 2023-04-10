AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box001a.mdl")
    self.Destructed = false
    self:SetModel("models/Items/item_item_crate.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
    self.damage = 100
    
    self.WeaponsLeft = self.WeaponsLeft or 10

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

function ENT:OnTouch(ent)
    if IsValid(ent) and ent:GetClass() == "shipment_box" and ent:GetWeaponClass() == self:GetWeaponClass() then
        self.WeaponsLeft = self.WeaponsLeft + ent.WeaponsLeft
        ent:Remove()
    end
end

function ENT:SetWeaponClass(classname)
    self.WeaponClass = classname
end

function ENT:GetWeaponClass()
    return self.WeaponClass
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if self.WeaponsLeft > 0 then
        self.WeaponsLeft = self.WeaponsLeft - 1
        local weapon = ents.Create("spawned_weapon")
        weapon:SetWeaponClass(self:GetWeaponClass())
        weapon:SetPos(self:GetPos() + self:GetAngles():Up() * 40)
        weapon:Spawn()
        weapon:Activate()
    end
    if self.WeaponsLeft <= 0 then
        self:Remove()
    end
end

function ENT:Draw()
    self:DrawModel()

    local ang = self:GetAngles()
    local pos = self:GetPos() + ang:Up() * 10.5

    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)

    cam.Start3D2D(pos, ang, 0.1)
        draw.SimpleText("Weapons: " .. tostring(self.WeaponsLeft), "DermaLarge", 0, 0, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()

    local pos2 = self:GetPos() + ang:Up() * 0.5 + ang:Right() * -20
    cam.Start3D2D(pos2, ang, 0.1)
        draw.SimpleText(self:GetWeaponClass(), "DermaLarge", 0, 0, Color(228, 58, 58), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end