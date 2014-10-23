module(..., package.seeall)

DIALOG_SIZE = { Application.viewWidth * 0.95, 180}

function onCreate(params)
    view = View {
        scene = scene,
        layout = VBoxLayout {
            align = {"center", "center"},
            padding = {10, 10, 10, 10},
        },
    }
    
    infoButton = Button {
        text = "Info",
        size = {200, 50},
        parent = view,
        onClick = onInfoClick,
    }
    confirmButton = Button {
        text = "Confirm",
        size = {200, 50},
        parent = view,
        onClick = onConfirmClick,
    }
    warningButton = Button {
        text = "Warning",
        size = {200, 50},
        parent = view,
        onClick = onWarnClick,
    }
    errorButton = Button {
        text = "Error",
        size = {200, 50},
        parent = view,
        onClick = onErrorClick,
    }
end

-- the reason we do it by opening a new scene with the dialog
-- is because if we just create the component in this view,
-- the other components would still work (be clickable etc)
-- which is not what we want for 'modal' dialogs...

function onInfoClick(e)
    SceneManager:openScene("samples/gui/dialog_scene",
    {
        animation = "popIn", backAnimation = "popOut",
        size = DIALOG_SIZE,
        type = DialogBox.TYPE_INFO,
        title = "Information",
        text = "Some information text",
        buttons = {"OK"},
        onResult = onDialogResult,
    })
end

function onConfirmClick(e)
    SceneManager:openScene("samples/gui/dialog_scene",
    {
        animation = "popIn", backAnimation = "popOut",
        size = DIALOG_SIZE,
        type = DialogBox.TYPE_CONFIRM,
        title = "Confirmation",
        text = "Answer the question?",
        buttons = {"Yes", "No", "Cancel"},
        onResult = onDialogResult,
    })
end

function onWarnClick(e)
    SceneManager:openScene("samples/gui/dialog_scene",
    {
        animation = "popIn", backAnimation = "popOut",
        size = DIALOG_SIZE,
        type = DialogBox.TYPE_WARNING,
        title = "Warning",
        text = "Watch-out text!",
        buttons = {"OK", "Cancel"},
        onResult = onDialogResult,
    })
end

function onErrorClick(e)
    SceneManager:openScene("samples/gui/dialog_scene",
    {
        animation = "popIn", backAnimation = "popOut",
        size = DIALOG_SIZE,
        type = DialogBox.TYPE_ERROR,
        title = "Error",
        text = "Error at address:\n<c:ff0000>0xbaadf00d</c>",
        buttons = {"OK"},
        onResult = onDialogResult,
    })
end

function onDialogResult(e)
    print("Dialog result is: '" .. e.result .. "', index " .. tostring(e.resultIndex))
end
