module(..., package.seeall)

function onCreate(params)
    widgetView = View:new()
    widgetView:setScene(scene)
    
    panel = Panel:new()
    panel:setSize(300, 100)
    panel:setPos(10, 100)
    panel:setParentView(widgetView)
    
    textLabel = TextLabel:new({text = "こんにちは\nこんにちは\nこんにちは\nこんにちは\nこんにちは\n"})
    textLabel:setTextSize(16)
    textLabel:setPos(10, 10)
    textLabel:setSize(280, 80)
    panel:addChild(textLabel)
    
    local text =  "こんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちは"
    messageBox = MessageBox:new()
    messageBox:setSize(300, 200)
    messageBox:setText(text)
    messageBox:setPos(panel:getLeft(), panel:getBottom() + 10)
    widgetView:addChild(messageBox)
    
    print(messageBox.textLabel:getStringBounds(1 + 3*9, 3))
    print(messageBox.textLabel:getStringBounds(1 + 3*10, 3))
    print(messageBox.textLabel:getStringBounds(1 + 3*11, 3))
    print(messageBox.textLabel:getStringBounds(1 + 3*12, 3))
    
end

function onStart()
end

