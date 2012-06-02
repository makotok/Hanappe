module(..., package.seeall)

function onCreate(params)
    widgetView = View()
    widgetView:setScene(scene)
    
    panel = Panel()
    panel:setSize(300, 100)
    panel:setPos(10, 100)
    panel:setParentView(widgetView)
    
    textLabel = TextLabel({text = "こんにちは\nこんにちは\nこんにちは\nこんにちは\nこんにちは\n"})
    textLabel:setTextSize(16)
    textLabel:setPos(80, 10)
    textLabel:setSize(200, 80)
    panel:addChild(textLabel)
    
    sprite = Sprite({texture = "samples/assets/cathead.png"})
    sprite:setPos(10, 10)
    sprite:setSize(64, 64)
    panel:addChild(sprite)
end

function onStart()
end

