module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene
    }
    
    panel1 = widget.Panel {
        size = {200, 100},
        pos = {50, 50},
        parent = view,
    }
    
    panel2 = widget.Panel {
        size = {200, 200},
        pos = {50, 160},
        parent = view,
    }
    
end
