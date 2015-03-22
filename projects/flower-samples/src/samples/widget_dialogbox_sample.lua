module(..., package.seeall)

function onCreate(e)
    view = widget.UIView {
        scene = scene,
        layout = widget.BoxLayout {
        },
    }

    infoButton = widget.Button {
        size = {200, 50},
        pos = {5, 5},
        text = "Info",
        parent = view,
        onClick = function()
            widget.showDialogBox (scene, {
                title = "Dialog",
                text = "Hello Dialog!",
                buttons = {"OK", "CANCEL"},
                onShow = function(e)
                    print("onShow")
                end,
                onHide = function(e)
                    print("onHide")
                end,
                onResult = function(e)
                    print("onResult", e.result)
                end,
            })
        end,
    }

    warnButton = widget.Button {
        size = {200, 50},
        pos = {5, 5},
        text = "Warning",
        parent = view,
        onClick = function()
            widget.showDialogBox (scene, {
                title = "Dialog",
                text = "どうもこんにちは警告くんです.",
                type = "Warning",
                buttons = {"OK", "CANCEL"},
                onShow = function(e)
                    print("onShow")
                end,
                onHide = function(e)
                    print("onHide")
                end,
                onResult = function(e)
                    print("onResult", e.result)
                end,
            })
        end,
    }

    errorButton = widget.Button {
        size = {200, 50},
        pos = {5, 5},
        text = "Error",
        parent = view,
        onClick = function()
            widget.showDialogBox (scene, {
                title = "Dialog",
                text = "ERROR!!!!!!",
                type = "Error",
                buttons = {"OK"},
                onShow = function(e)
                    print("onShow")
                end,
                onHide = function(e)
                    print("onHide")
                end,
                onResult = function(e)
                    print("onResult", e.result)
                end,
            })
        end,
    }
end
