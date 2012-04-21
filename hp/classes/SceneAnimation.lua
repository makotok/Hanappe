local Animation = require("hp/classes/Animation")

--------------------------------------------------------------------------------
-- Sceneクラスをアニメーションする為の関数群です.
-- @class table
-- @name M
--------------------------------------------------------------------------------
local M = {}
local defaultSecond = 0.5

---------------------------------------
-- 即座に表示します.
---------------------------------------
function M.none(currentScene, nextScene, params)
    return Animation:new():parallel(
        Animation:new({currentScene}, sec):setVisible(false),
        Animation:new({nextScene}, sec):setVisible(true):setLeft(0):setTop(0)
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
        Animation:new({nextScene}, sec)
            :setVisible(true):setLeft(0):setTop(0):setScl(0, 0, 0)
            :seekScl(1, 1, 0)
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
        Animation:new({currentScene}, sec):fadeOut(),
        Animation:new({nextScene}, sec):fadeIn()
    )
end

---------------------------------------
-- fadeOut,fadeInを並列して行います.
---------------------------------------
function M.crossFade(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    return Animation:new():parallel(
        Animation:new(currentScene, sec):fadeOut(),
        Animation:new(nextScene, sec):fadeIn()
    )
end

---------------------------------------
-- 画面上の移動します.
---------------------------------------
function M.slideToTop(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene.width, currentScene.height
    return Animation:new():parallel(
        Animation:new(currentScene, sec)
            :copy({x = 0, y = 0, z = 0})
            :moveLocation(0, -sh, 0)
            :copy({visible = false}),
        Animation:new(nextScene, sec)
            :copy({x = 0, y = sh, z = 0, visible = true})
            :moveLocation(0, -sh, 0)
            :copy({y = 0})
    )
end

---------------------------------------
-- 画面下の移動します.
---------------------------------------
function M.slideToBottom(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene.width, currentScene.height
    return Animation:new():parallel(
        Animation:new(currentScene, sec)
            :copy({x = 0, y = 0})
            :moveLocation(0, sh, 0)
            :copy({visible = false}),
        Animation:new(nextScene, sec)
            :copy({x = 0, y = -sh, visible = true})
            :moveLocation(0, sh, 0)
            :copy({y = 0})
    )
end

---------------------------------------
-- 画面左の移動します.
---------------------------------------
function M.slideToLeft(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene.width, currentScene.height
    return Animation:new():parallel(
        Animation:new(currentScene, sec)
            :setLeft(0):setTop(0)
            :moveLoc(-sw, 0, 0)
            :setVisible(false),
        Animation:new(nextScene, sec)
            :setLeft(sw):setTop(0)
            :setVisible(true)
            :moveLoc(-sw, 0, 0)
            :setLeft(0)
    )
end

---------------------------------------
-- 画面右の移動します.
---------------------------------------
function M.slideToRight(currentScene, nextScene, params)
    local sec = params.sec and params.sec or defaultSecond
    local sw, sh = currentScene.width, currentScene.height
    return Animation:new():parallel(
        Animation:new(currentScene, sec)
            :setLeft(0):setTop(0)
            :moveLoc(sw, 0, 0)
            :setVisible(false),
        Animation:new(nextScene, sec)
            :setLeft(-sw):setTop(0)
            :setVisible(true)
            :moveLoc(sw, 0, 0)
            :setLeft(0)
    )
end

return M