local meta = scripted_ents.GetStored( "gb_rp_sign" )
if not meta then return false end

meta = meta.t
local og_SetupDataTables = meta.SetupDataTables
local RunHook = TextScreenManager.RunHook


local SetText
do
    local shouldRun
    SetText = function( self, text )
        shouldRun = RunHook( self, text )
        if shouldRun ~= false then
            self.og_SetText( self, text )
        end
    end
end

meta.SetupDataTables = function( self )
    og_SetupDataTables( self )

    self.og_SetText = self.og_SetText or self.SetText
    self.SetText = SetText
end
