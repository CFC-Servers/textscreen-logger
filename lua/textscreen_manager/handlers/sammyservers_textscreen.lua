local meta = scripted_ents.GetStored( "sammyservers_textscreen" )
if not meta then return false end

meta = meta.t
-- FIXME: Requires this PR to be merged: https://github.com/Cherry/3D2D-Textscreens/pull/86
local og_SendLines = meta.SendLines
local string_sub = string.sub

local RunHook = TextScreenManager.RunHook
local GetOwner = TextScreenManager.GetOwner


local getter
do
    local lines, text
    getter = function( ent )
        lines = ent.lines
        if not lines then return "" end

        local str = ""
        for _, lineTbl in pairs( lines ) do
            text = lineTbl.text

            if text ~= "" then
                str = str .. text .. ", "
            end
        end

        return string_sub( str, 1, #str - 2 )
    end
end


local shouldRun
meta.SendLines = function( self, ply )
    shouldRun = RunHook( self, getter( self ) )
    if shouldRun ~= false then
        og_SendLines( self, ply )
        return
    end

    -- If it's a broadcast, send it just to the owner
    -- If it's already a self-send, then allow it
    owner = GetOwner( self )
    if ply == nil or ply == owner then
        og_SendLines( self, owner )
    end

    -- Do not send text update
    return nil
end
