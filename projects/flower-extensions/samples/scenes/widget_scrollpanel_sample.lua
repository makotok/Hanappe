module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene,
    }
    
    panel1 = widget.ScrollPanel {
        size = {200, 300},
        pos = {50, 50},
        parent = view,
        scrollPolicy = {false, true},
        layout = widget.BoxLayout {
            gap = {5, 5},
            align = {"center", "top"},
        },
        contents = {
            createContents(100)
        },
    }
end

function createContents(size)
    local contents = {}

    for i = 1, size do
        local button = widget.Button {
            size = {100, 50},
            text = "Test" .. i,
        }
        table.insert(contents, button)
    end

    return contents
end