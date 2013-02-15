--------------------------------------------------------------------------------
-- This module to animate the Scene. <br>
-- You are not required to refer to the function is not available. <br>
-- Animation is possible with the function name specified in the SceneManager. <br>
--------------------------------------------------------------------------------

local Animation = require "hp/display/Animation"
local Graphics  = require "hp/display/Graphics"
local Layer     = require "hp/display/Layer"

local M = {}

local POPUP_LAYER = "SceneAnimationPopUpLayer"

local defaultSecond = 0.4

local function createShowAnimation(scene, sec)
    return Animation({scene}, sec)
        :setColor(1, 1, 1, 1):setVisible(true)
        :setLeft(0):setTop(0):setScl(1, 1, 1):setRot(0, 0, 0)
end

--------------------------------------------------------------------------------
-- Sets the default animation second.
--------------------------------------------------------------------------------
function M.setDefaultSecond(sec)
    defaultSecond = sec
end

--------------------------------------------------------------------------------
-- The displayed immediately.
--------------------------------------------------------------------------------
function M.changeNow(currentScene, nextScene, params)
    return Animation():parallel(
        Animation({currentScene}, 0):setVisible(false),
        createShowAnimation(nextScene, 0)
    )
end

--------------------------------------------------------------------------------
-- The pop-up display.
--------------------------------------------------------------------------------
function M.popIn(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    
    local layer = Layer {scene = currentScene}
    layer.name = POPUP_LAYER
    layer:setColor(0, 0, 0, 0)
    
    local g = Graphics {layer = layer, width = layer:getViewWidth() + 1, height = layer:getViewHeight() + 1}
    g:setPenColor(0, 0, 0, 1):fillRect()
    
    return Animation():parallel(
        Animation(layer, sec)
            :seekColor(0.5, 0.5, 0.5, 0.5),
        createShowAnimation(nextScene, sec):parallel(
            Animation(nextScene, sec):setColor(0, 0, 0, 0):seekColor(1, 1, 1, 1),
            Animation(nextScene, sec):setScl(0.5, 0.5, 1):seekScl(1, 1, 1)
        )
    )
end

--------------------------------------------------------------------------------
-- Close the pop-up display. <br>
-- Valid only for scene that displays pop-up.
--------------------------------------------------------------------------------
function M.popOut(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local layer = nextScene:getChildByName(POPUP_LAYER)
    
    return Animation():parallel(
        Animation(currentScene, sec):parallel(
            Animation(currentScene, sec):seekColor(0, 0, 0, 0):setVisible(false),
            Animation(currentScene, sec):seekScl(0.5, 0.5, 1)
        ),
        Animation(layer, sec):seekColor(0, 0, 0, 0):callFunc(function() nextScene:removeChild(layer) end)
    )
end

--------------------------------------------------------------------------------
-- order to run fadeOut, fadeIn.
--------------------------------------------------------------------------------
function M.fade(currentScene, nextScene, params)
    local sec = params.sec and params.sec or M.defaultSecond
    return Animation():sequence(
        Animation({nextScene}, sec):setColor(0, 0, 0, 0),
        Animation({currentScene}, sec):setVisible(true):fadeOut():setVisible(false),
        createShowAnimation(nextScene, sec):fadeIn()
    )
end

--------------------------------------------------------------------------------
-- The parallel execution fadeOut, fadeIn.
--------------------------------------------------------------------------------
function M.crossFade(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    return Animation():parallel(
        Animation({currentScene}, sec):setVisible(true):fadeOut():setVisible(false),
        createShowAnimation(nextScene, sec):fadeIn()
    )
end

--------------------------------------------------------------------------------
-- Slide the top.
--------------------------------------------------------------------------------
function M.slideToTop(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene:getWidth(), currentScene:getHeight()
    return Animation():parallel(
        Animation({currentScene}, sec)
            :setVisible(true)
            :moveLoc(0, -sh, 0)
            :setVisible(false),
        createShowAnimation(nextScene, sec)
            :setLeft(0):setTop(sh)
            :moveLoc(0, -sh, 0)
            :setTop(0)
    )
end

--------------------------------------------------------------------------------
-- Slide the bottom.
--------------------------------------------------------------------------------
function M.slideToBottom(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene:getWidth(), currentScene:getHeight()
    return Animation():parallel(
        Animation({currentScene}, sec)
            :moveLoc(0, sh, 0)
            :setVisible(false),
        createShowAnimation(nextScene, sec)
            :setLeft(0):setTop(-sh)
            :moveLoc(0, sh, 0)
            :setTop(0)
    )
end

--------------------------------------------------------------------------------
-- Slide the left.
--------------------------------------------------------------------------------
function M.slideToLeft(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene:getWidth(), currentScene:getHeight()
    return Animation():parallel(
        Animation({currentScene}, sec)
            :setLeft(0):setTop(0)
            :moveLoc(-sw, 0, 0)
            :setVisible(false),
        createShowAnimation(nextScene, sec)
            :setLeft(sw):setTop(0)
            :moveLoc(-sw, 0, 0)
            :setLeft(0)
    )
    
end

--------------------------------------------------------------------------------
-- Slide the right.
--------------------------------------------------------------------------------
function M.slideToRight(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene:getWidth(), currentScene:getHeight()
    return Animation():parallel(
        Animation({currentScene}, sec)
            :setLeft(0):setTop(0)
            :moveLoc(sw, 0, 0)
            :setVisible(false),
        createShowAnimation(nextScene, sec)
            :setLeft(-sw):setTop(0)
            :moveLoc(sw, 0, 0)
            :setLeft(0)
    )
end

return M