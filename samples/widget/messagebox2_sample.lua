module(..., package.seeall)

local Logger = require("hp/util/Logger")


function onCreate(params)
	Logger.debug("onCreate()", scene.name)
 	
	widgetView = View:new()
    widgetView:setScene(scene)
	
    messageBox = MessageBox:new()
    messageBox:setTextSize(16)
    messageBox:setSize(200, 100)
    messageBox:setText("Hello, World!")
    messageBox:setPos(5, 5)
    widgetView:addChild(messageBox)

	messageBox2 = MessageBox:new()
    messageBox2:setTextSize(20)
    messageBox2:setSize(200, 100)
    messageBox2:setText("Hello, Again!")
    messageBox2:setPos(5, messageBox:getBottom() + 5)
    widgetView:addChild(messageBox2)
end

function onStart()
    Logger.debug("onStart()", scene.name)
end

function onResume()
    Logger.debug("onResume()", scene.name)
end

function onPause()
    Logger.debug("onPause()", scene.name)
end

function onStop()
    Logger.debug("onStop()", scene.name)
end

function onDestroy()
    Logger.debug("onDestroy()", scene.name)
end