module(..., package.seeall)

local map_editor = require "libs/map_editor"

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    tileMap = map_editor.TileEditorMap()
    tileMap:loadLueFile("map_town.lue")
    tileMap:setScene(scene)
    
    view = widget.UIView {
        scene = scene,
    }
    
    modeChangeButton = widget.Button {
        size = {100, 50},
        pos = {5, flower.viewHeight - 55},
        text = "Edit",
        textSize = 16,
        parent = view,
        onClick = function(e)
            local text = modeChangeButton:getText()
            if text == "Edit" then
                tileMap:setMode("edit")
                modeChangeButton:setText("Move")
            else
                tileMap:setMode("move")
                modeChangeButton:setText("Edit")
            end
        end,
    }
end
