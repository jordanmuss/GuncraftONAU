GUNCRAFT = GUNCRAFT or {}

function GUNCRAFT.FetchWorldModel(classname)
    local wep = weapons.Get(classname)
    if wep ~= nil and wep.WorldModel ~= nil then
        print("World model for", classname, "is", wep.WorldModel) -- Debug information
        return wep.WorldModel
    else
        print("Fallback model for", classname) -- Debug information
        return "models/weapons/w_pist_fiveseven.mdl" -- Fallback model
    end
end
