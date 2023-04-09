
--[[----------------------------------------------------------------------------

    SHARED

----------------------------------------------------------------------------]]--
local Player = FindMetaTable("Player")


function Player:GetGuncraftWeapons()
    local guncraftWeapons = {}

    for _, weapon in ipairs(self:GetWeapons()) do
        local weaponClass = weapon:GetClass()
        for _, guncraftWeapon in pairs(GUNCRAFT.config.weapons) do
            if weaponClass == guncraftWeapon.classname then
                table.insert(guncraftWeapons, weaponClass)
                break
            end
        end
    end

    return guncraftWeapons
end


function GUNCRAFT.GetExp( ply )

	return tonumber( ply:GetNWInt( "guncraft_experience", 0 ) )

end

function GUNCRAFT.GetLevel( ply )

    local exp = GUNCRAFT.GetExp( ply )

    local bestMatch = 0

    for lvl, reqExp in pairs( GUNCRAFT.config.levels ) do

        if exp >= reqExp and lvl > bestMatch then

            bestMatch = lvl

        end

    end

    return bestMatch

end

function GUNCRAFT.GetMats( ply )

	return ply:GetNWInt( "guncraft_materials", 0 )

end

function GUNCRAFT.IsDonator( ply )

	if not ply:IsValid() or not ply:IsPlayer() then return end

	local plyRank = ply:GetUserGroup()

	for _,rank in pairs( GUNCRAFT.donatorRanks ) do
		if plyRank == rank then
			return true
		end
	end

	return false

end

function GUNCRAFT.CalcLevel( amount )

    local exp = tonumber( amount ) or 0

    local levels = GUNCRAFT.config.levels

    local bestMatch = 0

    for lvl, reqExp in pairs( levels ) do

        if exp >= reqExp and lvl > bestMatch then

            bestMatch = lvl

        end

    end

    return bestMatch

end

--[[----------------------------------------------------------------------------

    CLIENT

----------------------------------------------------------------------------]]--

if SERVER then

function GUNCRAFT.AddExp( ply, amt )

	local amount = tonumber( amt ) or 0

	local curExp = ply:GetNWInt( "guncraft_experience", 0 )

	ply:SetNWInt( "guncraft_experience", curExp + amount )

	GUNCRAFT.SavePlayerData( ply )

	return curExp + amount

end

function GUNCRAFT.AddMats( ply, amt )

	local amount = tonumber( amt ) or 0

	local curMats = ply:GetNWInt( "guncraft_materials", 0 )

	ply:SetNWInt( "guncraft_materials", curMats + amount )

	GUNCRAFT.SavePlayerData( ply )

	return curMats + amount

end

function GUNCRAFT.SubMats( ply, amt )

	local amount = tonumber( amt ) or 0

	local curMats = ply:GetNWInt( "guncraft_materials", 0 )

	ply:SetNWInt( "guncraft_materials", curMats - amount )

	GUNCRAFT.SavePlayerData( ply )

	return curMats - amount

end

function GUNCRAFT.WeaponCrafted( ply, amount )

    local amt = amount or 1

    local cur = ply:GetNWInt( "guncraft_weapons_crafted" )

    ply:SetNWInt( "guncraft_weapons_crafted", cur + amt )

	GUNCRAFT.SavePlayerData( ply )

end

function GUNCRAFT.ShipmentCrafted( ply, amount )

    local amt = amount or 1

    local cur = ply:GetNWInt( "guncraft_shipments_crafted" )

    ply:SetNWInt( "guncraft_shipments_crafted", cur + amt )

	GUNCRAFT.SavePlayerData( ply )

end

end -- END OF CLIENT CHECK
