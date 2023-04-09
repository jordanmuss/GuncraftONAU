AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self.WeaponsLeft = self.WeaponsLeft or 10

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:Wake()
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
end
