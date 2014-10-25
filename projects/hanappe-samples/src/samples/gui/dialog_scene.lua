module(..., package.seeall)

function onCreate(e)
    local width = 480
    local height = 320

    if e.size and type(e.size) == "table" and #e.size >= 2 then
        width = e.size[1]
        height = e.size[2]
    end

    view = View {
        scene = scene
    }

    local dlg = DialogBox {
        parent = view,
        type = e.type or DialogBox.TYPE_INFO,
        title = e.title or "Message title",
        text = e.text or "Message text",
        pos = {(Application.viewWidth - width) * 0.5, (Application.viewHeight - height) * 0.5},
        size = {width, height},
        buttons = e.buttons or {"OK"},
        onMessageResult = e.onResult,
        onMessageHide = onDialogHide,
    }
    dlg:show()
end

function onDialogHide(e)
    SceneManager:closeScene({animation="popOut"})
end