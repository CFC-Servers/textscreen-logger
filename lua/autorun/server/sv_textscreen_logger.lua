TextScreenManager = {}
TextScreenManager.prefix = "[TSM]"
TextScreenManager.loggers = {}
TextScreenManager.ranksToReceiveLog = {
    ["admin"] = true,
    ["moderator"] = true,
    ["operator"] = true,
    ["superadmin"] = true,
    ["Trial Staff"] = true
}

include( "textscreen_manager/sv_core.lua" )
