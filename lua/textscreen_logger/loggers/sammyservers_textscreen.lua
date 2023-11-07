local class = "sammyservers_textscreen"

TEXTSCREENLOGGER.loggers[class] = function( ent )
    if not ent.lines then return end

    local str = ""
    for _, lineTbl in pairs( ent.lines ) do
        if lineTbl.text ~= "" then
            str = str .. lineTbl.text .. ", "
        end
    end

    local text = string.sub( str, 1, #str - 2 )

    return text
end

hook.Add( "InitPostEntity", "TSL_WrapSammysScreen", function()
    local ts = scripted_ents.GetStored( class ).t
    ts._SetLine = ts._SetLine or ts.SetLine

    ts.SetLine = function( self, line, text, ... )
        local owner = self:CPPIGetOwner()
        TEXTSCREENLOGGER.log( owner, class, text )
        hook.Run( "TSLScreenSpawned", self, owner, class, text )
        return ts._SetLine( self, line, text, ... )
    end
end )
