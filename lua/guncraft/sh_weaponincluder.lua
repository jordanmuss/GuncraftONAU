CustomShipments = CustomShipments or {}
include("autorun/sh_guncraft_functions.lua")


GUNCRAFT.config.weapons = GUNCRAFT.config.weapons or {}


function GUNCRAFT.AddWeapon( data )

    if !data.name or !data.materials or !data.classname or !data.craftTime or !data.requiredLevel or !data.experience then
        error( "Incorrect weapon formatting. Please check your config." )
    end

    local name = type(data.name) == "string" and data.name or "ERROR"
    local mats = type(data.materials) == "number" and data.materials or 404
    local class = type(data.classname) == "string" and data.classname or "gmod_tool"
    local time = type(data.craftTime) == "number" and data.craftTime or 1
    local reqLvl = type(data.requiredLevel) == "number" and data.requiredLevel or 1
    local exp = type(data.experience) == "number" and data.experience or 404

    local job = type(data.job) == "string" and data.job or nil
    local disableAmmo = data.disableAmmo or false
    local disableShipment = data.disableShipment or false
    local bypassFunc = data.bypassFunc or nil
    if type(bypassFunc) ~= "function" then bypassFunc = nil end
    if bypassFunc ~= nil then disableShipment = true end

    local tab = {
        name = name,
        materials = mats,
        classname = class,
        time = time,
        requiredLevel = reqLvl,
        experience = exp,
        disableAmmo = disableAmmo,
        disableShipment = disableShipment,
        bypassFunc = bypassFunc,
        job = job;
    }

    if not data.disableShipment then
        table.insert(CustomShipments, {
            name = tab.name,
            entity = tab.classname,
            amount = 10 -- Change this value if you want a different amount in the shipment
        })
    end


    tab.model = GUNCRAFT.FetchWorldModel(tab.classname)
    table.insert( GUNCRAFT.config.weapons, #GUNCRAFT.config.weapons + 1, tab )


end