include("shared.lua")

local weaponModel = nil

function ENT:Draw()
  self:DrawModel()

  local ang = self:GetAngles()
  local pos = self:GetPos() + ang:Up() * 10.5

  ang:RotateAroundAxis(ang:Forward(), 90)
  ang:RotateAroundAxis(ang:Right(), 90)

  cam.Start3D2D(pos, ang, 0.1)
  draw.SimpleText("Weapons: " .. tostring(self:GetWeaponsLeft()), "DermaLarge", 0, 0, Color(0, 0, 0, 255),
    TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  cam.End3D2D()

  local pos2 = self:GetPos() + ang:Up() * 0.5 + ang:Right() * -20
  cam.Start3D2D(pos2, ang, 0.1)
  draw.SimpleText(self:GetWeaponClass(), "DermaLarge", 0, 0, Color(228, 58, 58), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

  if not weaponModel then
    weaponModel = ClientsideModel(GUNCRAFT.GetWorldModel(self:GetWeaponClass()), RENDERGROUP_TRANSLUCENT)
    print(GUNCRAFT.GetWorldModel(self:GetWeaponClass()))
  end

  if (IsValid(weaponModel)) then
    local pos3 = Vector(pos2.x, pos2.y, pos2.z + 10)
    local ang3 = Angle(0, ang.y - 90, -90)
    weaponModel:SetPos(pos3)
    weaponModel:SetAngles(ang3)
    weaponModel:SetNoDraw(false)
    weaponModel:SetupBones()
    weaponModel:DrawModel()
  end
  cam.End3D2D()
end

function ENT:OnRemove()
  if IsValid(weaponModel) then
    weaponModel:Remove()
  end
end