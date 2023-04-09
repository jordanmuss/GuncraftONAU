if SERVER then
    AddCSLuaFile()
end

if SERVER then
    --[[
    CREATING WORKBENCH ENTITY
 

    BaseWars.AddEnt("Weapon Workbench", {
        ent = "guncraft_workbench",
        model = "models/props/cs_italy/it_mkt_table3.mdl",
        price = GUNCRAFT.config.workbenchPrice,
        max = GUNCRAFT.config.workbenchAmount,
        cmd = "weaponworkbench",
    })
   
   ]]

    --[[
    ASSIGNING MODELS TO SERVER-SIDE WEAPON CONFIG
    ]]

    for _, globalWep in pairs(weapons.GetList()) do
        for k, localWep in pairs(GUNCRAFT.config.weapons) do
            if globalWep.ClassName == localWep.classname then
                GUNCRAFT.config.weapons[k].model = globalWep.WorldModel or "models/weapons/w_pist_fiveseven.mdl"
            end
        end
    end
end
