AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("autorun/sh_guncraft_functions.lua")
include("shared.lua")

function ENT:Initialize()
    local weaponClass = self:GetWeaponClass()
    local weaponModel = GUNCRAFT.FetchWorldModel(weaponClass)

    self:SetModel(weaponModel)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

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
    activator:Give(self:GetWeaponClass())
    self:Remove()
end
