local meta = scripted_ents.GetStored( "gmod_wire_textscreen" )
if not meta then return false end

meta = meta.t
local og_SendText = meta.SendText

local RunHook = TextScreenManager.RunHook
local GetOwner = TextScreenManager.GetOwner


local shouldRun, owner
meta.SendText = function( self, ply )
    self.doSendText = false

    shouldRun = RunHook( self, self.text )
    if shouldRun ~= false then
        og_SendText( self, ply )
        return
    end

    -- If it's a broadcast, send it just to the owner
    -- If it's already a self-send, then allow it
    owner = GetOwner( self )
    if ply == nil or ply == owner then
        og_SendText( self, owner )
    end

    -- Do not send text update
    return nil
end
