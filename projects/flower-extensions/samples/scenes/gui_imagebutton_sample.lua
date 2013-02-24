module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setTouchEnabled(true)
    
    imageButton = gui.ImageButton("button-up.png")
    imageButton:setPos(50, 50)
    imageButton:setLayer(layer)
    imageButton:addEventListener("click", imageButton_OnClick)
end

function imageButton_OnClick(e)
    print("Click!")
end