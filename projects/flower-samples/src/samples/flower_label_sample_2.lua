module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)

    view = widget.ScrollView {
        scene = scene,
        layout = widget.BoxLayout {},
    }

    for i = 0, 20 do
        local label = flower.Label("ABCDlg あいうえお")
        --label:setTextSize(math.floor((8 + i) / 0.75))
        label:setTextSize((8 + i))
        label:fitSize()
        view:addContent(label)
    end
end
