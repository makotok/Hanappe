module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    view = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {},
    }
    
    textlabel1 = widget.TextLabel {
        size = {flower.viewWidth - 10, 100},
        text = "こんにちは、ウィジェットの世界へ！\nHello World!",
        parent = view,
    }

    textlabel2 = widget.TextLabel {
        text = "こんにちは、ウィジェットの世界へ！\nHello World!",
        parent = view,
    }

    textlabel3 = widget.TextLabel {
        text = "こんにちは、ウィジェットの世界へ！\nHello World!",
        textResizePolicy = {"auto", "auto"},
        parent = view,
    }

    textlabel4 = widget.TextLabel {
        text = "こんにちは、ウィジェットの世界へ！\nHello World!",
        textResizePolicy = {"auto", "auto"},
        textPadding = {10, 10, 10, 10},
        parent = view,
    }

    textlabel5 = widget.TextLabel {
        text = "あいうえおかきくけこさしすせたつちてとなにぬねのまみむめも",
        width = flower.viewWidth,
        textResizePolicy = {"none", "auto"},
        parent = view,
    }

    resizeButton = widget.Button {
        text = "Resize",
        size = {100, 50},
        parent = view,
        onClick = function(e)
            textlabel1:setSize(100, 150)
        end,
    }
end

