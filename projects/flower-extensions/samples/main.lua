-- import
flower = require "flower"
tiled = require "tiled"
widget = require "widget"
themes = require "themes"
audio = require "audio"
config = require "config"

-- audio initialize
audio.init()

-- open window
flower.openWindow("Flower extensions", config.screenWidth, config.screenHeight, config.viewScale)

-- open scene
flower.openScene("main_scene")

-- debug
debugLayer = flower.Layer()
fpsLabel = flower.Label("FPS:" .. math.floor(MOAISim.getPerformance()), 200, 50)
fpsLabel:setLayer(debugLayer)
fpsTimer = MOAITimer.new()
fpsTimer:setMode(MOAITimer.LOOP)
fpsTimer:setSpan(1)
fpsTimer:setListener(MOAITimer.EVENT_TIMER_LOOP, function()
    fpsLabel:setString("FPS:" .. math.floor(MOAISim.getPerformance()))
end)
fpsTimer:start()
    
flower.RenderMgr:addChild(debugLayer)
    