module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    panelView = widget.PanelView {
        size = {200, 300},
        pos = {50, 50},
        scene = scene,
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