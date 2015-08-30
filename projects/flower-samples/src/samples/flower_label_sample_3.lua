module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)

    view = widget.ScrollView {
        scene = scene,
    }

    for i = 0, 20 do
        local label = flower.Label("ABCDlg あいうえお")
        --label:setTextSize(math.floor((8 + i) / 0.75))
        label:setTextSize(30)
        label:fitSize()
        label:setPos(0, 30 * i)

        view:addContent(label)
    end
end
