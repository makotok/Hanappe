module(..., package.seeall)

Logger = flower.Logger

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)

    view = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {
            gap = {5, 5},
            align = {"center", "center"},
        },
        children = {{
            widget.Button {
                size = {200, 50},
                text = "Info",
                parent = view,
                onClick = function(e)
                    Logger.info("Output info log.", 1, "b")
                end,
            },
            widget.Button {
                size = {200, 50},
                text = "Warn",
                parent = view,
                onClick = function(e)
                    Logger.warn("Output warn log.", 1, "b")
                end,
            },
            widget.Button {
                size = {200, 50},
                text = "Error",
                parent = view,
                onClick = function(e)
                    Logger.error("Output error log.", 1, "b")
                end,
            },
            widget.Button {
                size = {200, 50},
                text = "Debug",
                parent = view,
                onClick = function(e)
                    Logger.debug("Output debug log.", 1, "b")
                end,
            },
            widget.Button {
                size = {200, 50},
                text = "Trace",
                parent = view,
                onClick = function(e)
                    Logger.trace("Output trace log.")
                end,
            },
        }},
    }
    
end
