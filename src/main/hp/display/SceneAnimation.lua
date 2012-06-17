--------------------------------------------------------------------------------
-- This module to animate the Scene. <br>
-- You are not required to refer to the function is not available. <br>
-- Animation is possible with the function name specified in the SceneManager. <br>
--
-- @auther Makoto
-- @class table
-- @name SceneAnimation
--------------------------------------------------------------------------------

local Animation = require("hp/display/Animation")

local M = {}

local defaultSecond = 0.5

local function createShowAnimation(scene, sec)
    return Animation({scene}, sec)
        :setColor(1, 1, 1, 1):setVisible(true)
        :setLeft(0):setTop(0):setScl(1, 1, 1):setRot(0, 0, 0)
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
    return Animation():parallel(
        Animation({currentScene}, sec)
            :seekColor(0.5, 0.5, 0.5, 0.5),
        createShowAnimation(nextScene, sec)
            :setScl(0, 0, 1):seekScl(1, 1, 1)
    )
end

--------------------------------------------------------------------------------
-- Close the pop-up display. <br>
-- Valid only for scene that displays pop-up.
--------------------------------------------------------------------------------
function M.popOut(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    return Animation():parallel(
        Animation({currentScene}, sec):seekScl(0, 0, 1):setVisible(false),
        Animation({nextScene}, sec):seekColor(1, 1, 1, 1)
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