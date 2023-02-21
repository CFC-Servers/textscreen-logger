local ranksToGetLog = TextScreenManager.ranksToReceiveLog
util.AddNetworkString( "TextScreenManagerLog" )

local name, steamID
local function log( ply, class, text )
    name = ply and ply:GetName() or "Unknown"
    steamID = ply and ply:SteamID() or "Unknown"
    local logString = TextScreenManager.prefix .. " " .. name .. "<" .. steamID .. "> spawned/updated " .. class .. " containing: \"" .. text .. "\""

    print( logString )
    ServerLog( logString .. "\n" )

    TextScreenManager.sendToAdmins( logString )
end
TextScreenManager.log = log

local function GetOwner( ent )
    if CPPI then return ent:CPPIGetOwner() end
    return ent.Owner or ent:GetPlayer() or ent:GetOwner()
end
TextScreenManager.GetOwner = GetOwner

do
    local owner, entClass
    function TextScreenManager.RunHook( ent, text )
        owner = GetOwner( ent )
        if ( not owner ) or ( not IsValid( owner ) ) then
            owner = nil
            ErrorNoHalt( "Unable to determine screen owner! (" .. entClass .. ")" )
        end

        log( owner, entClass, text )
        return hook.Run( "TSLScreenSpawned", ent, owner, entClass, text )
    end
end

function TextScreenManager.sendToAdmins( text )
    for _, ply in ipairs( player.GetHumans() ) do
        if ranksToGetLog[ply:GetUserGroup()] then
            net.Start( "TextScreenManagerLog" )
            net.WriteString( text )
            net.Send( ply )
        end
    end
end


local handlers = file.Find( "textscreen_manager/handlers/*.lua", "lsv" )
do
    local success, out, verb
    for _, handler in ipairs( handlers ) do
        success, out = pcall( include, "textscreen_manager/handlers/" .. handler )

        if success then
            verb = out == false and "skipped (relevant addon not present)" or "loaded"
            print( TextScreenManager.prefix .. " " .. verb .. ": " .. handler )
        else
            ErrorNoHaltWithStack( "Error loading handler: '" .. handler .. "' ( " .. out .. " )" )
        end
    end
end

print( TextScreenManager.prefix .. " Initialized" )
