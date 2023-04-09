util.AddNetworkString( "guncraft_buyMaterials" )
util.AddNetworkString( "guncraft_sellMaterials" )
util.AddNetworkString( "guncraft_materialsVGUIUpdate" )

net.Receive("guncraft_buyMaterials", function(len, ply)
    if not ply:IsValid() or not ply:IsPlayer() then return end

    local closeEnoughToNPC = false
    for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 500)) do
        if ent:IsValid() and ent:GetClass() == "npc_material" then
            closeEnoughToNPC = true
            break
        end
    end

    if not closeEnoughToNPC then return end

    if ply:GetNWInt("guncraft_nextBuy") > CurTime() then
        local timeLeft = ply:GetNWInt("guncraft_nextBuy") - CurTime()
        FPLib.Notify(ply, string.format("You have to wait another %s seconds before you can buy more materials.", math.ceil(timeLeft)), 1)
        return
    end

    local money = ply:GetMoney()
    local curMats = GUNCRAFT.GetMats(ply)
    local mats = net.ReadFloat()

    if money < mats * GUNCRAFT.config.materialPrice then
        FPLib.Notify(ply, "You cannot afford this many materials.", 1)
        return
    end

    if mats < 0 then mats = 1 end

    ply:AddMoney(-(mats * GUNCRAFT.config.materialPrice))
    GUNCRAFT.AddMats(ply, mats)

    net.Start("guncraft_materialsVGUIUpdate")
        net.WriteFloat(curMats + mats)
    net.Send(ply)

    local msg = "You bought " .. mats .. " materials for $" .. mats * GUNCRAFT.config.materialPrice .. ". You now have " .. GUNCRAFT.GetMats(ply) .. " materials."
    ply:EmitSound("vo/npc/Barney/ba_ohyeah.wav")
    FPLib.Notify(ply, msg, 0, 8)

    if GUNCRAFT.IsDonator(ply) then
        ply:SetNWInt("guncraft_nextBuy", CurTime() + GUNCRAFT.config.buyDelayDonator)
    else
        ply:SetNWInt("guncraft_nextBuy", CurTime() + GUNCRAFT.config.buyDelay)
    end

    if GUNCRAFT.devmode then
        ply:SetNWInt("guncraft_nextBuy", CurTime() + 1)
    end
end)




net.Receive("guncraft_sellMaterials", function(len, ply)
    if not ply:IsValid() or not ply:IsPlayer() then return end

    if ply.canSellMaterials == false then
        FPLib.Notify(ply, "Please wait a moment before attempting to sell materials again.", 1)
        return
    end

    local closeEnoughToNPC = false
    for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 500)) do
        if ent:IsValid() and ent:GetClass() == "npc_material" then
            closeEnoughToNPC = true
            break
        end
    end

    if not closeEnoughToNPC then return end

    local curMats = tonumber(GUNCRAFT.GetMats(ply))
    local mats = tonumber(net.ReadFloat())

	if mats < 0 then mats = 1 end

	if mats > curMats then

		FPLib.Notify( ply, "You don't have this many materials to sell.", 1 )
		return

	end

	ply:AddMoney( mats * GUNCRAFT.config.materialResell )
	GUNCRAFT.SubMats( ply, mats )

	net.Start( "guncraft_materialsVGUIUpdate" )
		net.WriteFloat( curMats - mats )
	net.Send( ply )

	local msg = "You sold " .. mats .. " materials for $" .. mats * GUNCRAFT.config.materialPrice .. ". You now have " .. GUNCRAFT.GetMats( ply ) .. " materials."
	ply:EmitSound( "vo/Streetwar/nexus/ba_done.wav" )
	FPLib.Notify( ply, msg, 0, 8 )

	ply.canSellMaterials = false
	timer.Simple( 3, function()

		ply.canSellMaterials = true

	end )

end )
