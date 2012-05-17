module(..., package.seeall)

function onCreate(params)
    widgetView = View:new()
    widgetView:setScene(scene)
        
    local text =  ""
    for i = 1, 20 do
        text = text .. "メッセージ" .. i .. "\n"
    end
    messageBox = MessageBox:new()
    messageBox:setTextSize(16)
    messageBox:setSize(300, 100)
    messageBox:setText(text)
    messageBox:setPos(10, 10)
    widgetView:addChild(messageBox)
    
end

function onStart()
end

function onTouchDown(e)
    messageBox.textLabel:nextPage()
end