--[[----------------------------------------------------------------------------

    GUNCRAFT WEAPONS (M9k Preset)
    Tutorial: https://youtu.be/jtfFaPSDSQw

----------------------------------------------------------------------------]]--

function GUNCRAFT.GetWorldModel(classname)
    local wep = weapons.Get(classname)
    if wep and wep.WorldModel then
        return wep.WorldModel
    else
        return "models/weapons/w_pist_fiveseven.mdl" -- Fallback model
    end
end


-- Pistols

GUNCRAFT.AddWeapon( {
    name = "Colt 1911",
    materials = 30,
    classname = "m9k_colt1911",
    craftTime = 1,
    requiredLevel = 1,
    experience = 3,
} )

GUNCRAFT.AddWeapon( {
    name = "HK USP",
    materials = 50,
    classname = "m9k_usp",
    craftTime = 3,
    requiredLevel = 1,
    experience = 5,
} )

GUNCRAFT.AddWeapon( {
    name = "S & W Model 3 Russian",
    materials = 130,
    classname = "m9k_model3russian",
    craftTime = 5,
    requiredLevel = 2,
    experience = 13,
} )

GUNCRAFT.AddWeapon( {
    name = "Desert Eagle",
    materials = 150,
    classname = "m9k_deagle",
    craftTime = 5,
    requiredLevel = 3,
    experience = 15,
} )

--SMGs

GUNCRAFT.AddWeapon( {
    name = "UZI",
    materials = 200,
    classname = "m9k_uzi",
    craftTime = 8,
    requiredLevel = 4,
    experience = 20,
} )

GUNCRAFT.AddWeapon( {
    name = "HK MP5",
    materials = 230,
    classname = "m9k_mp5",
    craftTime = 10,
    requiredLevel = 4,
    experience = 23,
} )

GUNCRAFT.AddWeapon( {
    name = "Tommy Gun",
    materials = 250,
    classname = "m9k_thompson",
    craftTime = 13,
    requiredLevel = 5,
    experience = 25,
} )

GUNCRAFT.AddWeapon( {
    name = "KRISS Vector",
    materials = 260,
    classname = "m9k_vector",
    craftTime = 15,
    requiredLevel = 5,
    experience = 26,
} )

GUNCRAFT.AddWeapon( {
    name = "AAC Honey Badger",
    materials = 300,
    classname = "m9k_honeybadger",
    craftTime = 20,
    requiredLevel = 6,
    experience = 30,
} )

-- Assault Rifles

GUNCRAFT.AddWeapon( {
    name = "AK47",
    materials = 400,
    classname = "m9k_ak47",
    craftTime = 20,
    requiredLevel = 5,
    experience = 40,
} )

GUNCRAFT.AddWeapon( {
    name = "FN FAL",
    materials = 450,
    classname = "m9k_fal",
    craftTime = 20,
    requiredLevel = 6,
    experience = 45,
} )

GUNCRAFT.AddWeapon( {
    name = "FAMAS",
    materials = 500,
    classname = "m9k_famas",
    craftTime = 23,
    requiredLevel = 7,
    experience = 50,
} )

GUNCRAFT.AddWeapon( {
    name = "SCAR",
    materials = 530,
    classname = "m9k_scar",
    craftTime = 25,
    requiredLevel = 8,
    experience = 53,
} )

GUNCRAFT.AddWeapon( {
    name = "F2000",
    materials = 600,
    classname = "m9k_f2000",
    craftTime = 35,
    requiredLevel = 10,
    experience = 60,
} )

-- Shotguns

GUNCRAFT.AddWeapon( {
    name = "Winchester 87",
    materials = 250,
    classname = "m9k_1887winchester",
    craftTime = 15,
    requiredLevel = 6,
    experience = 25,
} )

GUNCRAFT.AddWeapon( {
    name = "Winchester 87",
    materials = 300,
    classname = "m9k_1887winchester",
    craftTime = 18,
    requiredLevel = 6,
    experience = 30,
} )

GUNCRAFT.AddWeapon( {
    name = "Winchester Carbine",
    materials = 330,
    classname = "m9k_winchester73",
    craftTime = 20,
    requiredLevel = 7,
    experience = 33,
} )

GUNCRAFT.AddWeapon( {
    name = "Mossberg 590",
    materials = 350,
    classname = "m9k_mossberg590",
    craftTime = 25,
    requiredLevel = 8,
    experience = 35,
} )

GUNCRAFT.AddWeapon( {
    name = "Double Barrel",
    materials = 180,
    classname = "m9k_dbarrel",
    craftTime = 40,
    requiredLevel = 12,
    experience = 18,
} )

-- Sniper Rifles

GUNCRAFT.AddWeapon( {
    name = "SVD Dragunov",
    materials = 600,
    classname = "m9k_dragunov",
    craftTime = 30,
    requiredLevel = 10,
    experience = 60,
} )

GUNCRAFT.AddWeapon( {
    name = "SVT 40",
    materials = 700,
    classname = "m9k_svt40",
    craftTime = 40,
    requiredLevel = 11,
    experience = 70,
} )

-- Other

GUNCRAFT.AddWeapon( {
    name = "M249 LMG",
    materials = 900,
    classname = "m9k_m249lmg",
    craftTime = 50,
    requiredLevel = 11,
    experience = 90,
} )
