local Animation = require("hp/classes/Animation")

--------------------------------------------------------------------------------
-- Sceneクラスをアニメーションする為の関数群です.
-- @class table
-- @name M
--------------------------------------------------------------------------------
local M = {}
local defaultSecond = 0.5

local function createShowAnimation(scene, sec)
    return Animation:new({scene}, sec)
        :setColor(1, 1, 1, 1):setVisible(true)
        :setLeft(0):setTop(0):setScl(1, 1, 0):setRot(0, 0, 0)
end

---------------------------------------
-- 即座に表示します.
---------------------------------------
function M.changeNow(currentScene, nextScene, params)
    return Animation:new():parallel(
        Animation:new({currentScene}, 0):setVisible(false),
        createShowAnimation(nextScene, 0)
    )
end

---------------------------------------
-- ポップアップ表示します.
---------------------------------------
function M.popIn(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    return Animation:new():parallel(
        Animation:new({currentScene}, sec)
            :seekColor(-0.5, -0.5, -0.5, -0.5),
        createShowAnimation(nextScene, sec)
            :setScl(0, 0, 0):seekScl(1, 1, 0)
    )
end

---------------------------------------
-- ポップアップ表示をクローズします.
-- ポップアップ表示したシーンに対してのみ有効です.
---------------------------------------
function M.popOut(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    return Animation:new():parallel(
        Animation:new({currentScene}, sec):seekScl(0, 0, 0):setVisible(false),
        Animation:new({nextScene}, sec):seekColor(1, 1, 1, 1)
    )
end

---------------------------------------
-- fadeOut,fadeInを順次行います.
---------------------------------------
function M.fade(currentScene, nextScene, params)
    local sec = params.sec and params.sec or M.defaultSecond
    return Animation:new():sequence(
        Animation:new({nextScene}, sec):setColor(0, 0, 0, 0),
        Animation:new({currentScene}, sec):setVisible(true):fadeOut():setVisible(false),
        createShowAnimation(nextScene, sec):fadeIn()
    )
end

---------------------------------------
-- fadeOut,fadeInを並列して行います.
---------------------------------------
function M.crossFade(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    return Animation:new():parallel(
        Animation:new({currentScene}, sec):setVisible(true):fadeOut():setVisible(false),
        createShowAnimation(nextScene, sec):fadeIn()
    )
end

---------------------------------------
-- 画面上の移動します.
---------------------------------------
function M.slideToTop(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene:getWidth(), currentScene:getHeight()
    return Animation:new():parallel(
        Animation:new({currentScene}, sec)
            :setVisible(true)
            :moveLoc(0, -sh, 0)
            :setVisible(false),
        createShowAnimation(nextScene, sec)
            :setLeft(0):setTop(sh)
            :moveLoc(0, -sh, 0)
            :setTop(0)
    )
end

---------------------------------------
-- 画面下の移動します.
---------------------------------------
function M.slideToBottom(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene:getWidth(), currentScene:getHeight()
    return Animation:new():parallel(
        Animation:new({currentScene}, sec)
            :moveLoc(0, sh, 0)
            :setVisible(false),
        createShowAnimation(nextScene, sec)
            :setLeft(0):setTop(-sh)
            :moveLoc(0, sh, 0)
            :setTop(0)
    )
end

---------------------------------------
-- 画面左の移動します.
---------------------------------------
function M.slideToLeft(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene:getWidth(), currentScene:getHeight()
    return Animation:new():parallel(
        Animation:new({currentScene}, sec)
            :setLeft(0):setTop(0)
            :moveLoc(-sw, 0, 0)
            :setVisible(false),
        createShowAnimation(nextScene, sec)
            :setLeft(sw):setTop(0)
            :moveLoc(-sw, 0, 0)
            :setLeft(0)
    )
    
end

---------------------------------------
-- 画面右の移動します.
---------------------------------------
function M.slideToRight(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene:getWidth(), currentScene:getHeight()
    return Animation:new():parallel(
        Animation:new({currentScene}, sec)
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