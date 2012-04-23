----------------------------------------------------------------
-- アプリケーションの初期化処理を行うモジュールです.<br>
-- アプリケーションの開始処理を行います.
-- @class table
-- @name Application
----------------------------------------------------------------
local M = {}

local defaultConfig = {
    title = "title",
    screenWidth = 320,
    screenHeight = 480,
    viewWidth = 320,
    viewHeight = 480,
    landscape = false,
    showWindow = true,
    useInputManager = true,
}

local function getScreenSize(self, config)
    local w, h = config.screenWidth, config.screenHeight
    if self:isMobile() then
        local w, h = MOAIEnvironment.screenWidth, MOAIEnvironment.screenHeight
    end
    if config.landscape then
        return h, w
    end
    return w, h
end

local function getViewSize(self, config)
    local w, h = config.viewWidth, config.viewHeight
    if config.landscape then
        return h, w
    end
    return w, h
end

----------------------------------------------------------------
-- アプリケーションを開始します.
-- Windowを生成します.
----------------------------------------------------------------
function M:appStart(config)
    if not config then
        config = defaultConfig
    end
    
    local title = config.title
    local screenWidth, screenHeight = getScreenSize(self, config)
    local viewWidth, viewHeight = getViewSize(self, config)
    local inputManager = require("hp/classes/InputManager")
    
    self.title = title
    self.screenWidth = screenWidth
    self.screenHeight = screenHeight
    self.viewWidth = viewWidth
    self.viewHeight = viewHeight
    self.showWindow = config.showWindow
    
    if self.showWindow then
        MOAISim.openWindow(title, screenWidth, screenHeight)
    end
    if config.useInputManager then
        inputManager:initialize()
    end
end

---------------------------------------
--- 指定したテーブルにクラスをインポートします.
---------------------------------------
function M:importClasses(t, prefix)
    prefix = prefix or ""
    
    -- application
    t[prefix .. "Application"] = require("hp/Application")

    -- display classes
    t[prefix .. "Layer"] = require("hp/classes/Layer")
    t[prefix .. "Sprite"] = require("hp/classes/Sprite")
    t[prefix .. "SpriteSheet"] = require("hp/classes/SpriteSheet")
    t[prefix .. "MapSprite"] = require("hp/classes/MapSprite")
    t[prefix .. "Graphics"] = require("hp/classes/Graphics")
    t[prefix .. "Group"] = require("hp/classes/Group")
    t[prefix .. "TextLabel"] = require("hp/classes/TextLabel")
    t[prefix .. "Animation"] = require("hp/classes/Animation")
    
    -- manager classes
    t[prefix .. "SceneManager"] = require("hp/classes/SceneManager")
    t[prefix .. "InputManager"] = require("hp/classes/InputManager")
    t[prefix .. "TextureManager"] = require("hp/classes/TextureManager")
    t[prefix .. "FontManager"] = require("hp/classes/FontManager")

    -- tmx classes
    t[prefix .. "TMXMapFactory"] = require("hp/classes/TMXMapFactory")

end

---------------------------------------
--- 実行環境がモバイルかどうか返します.
---------------------------------------
function M:isMobile()
    local bland = MOAIEnvironment.osBrand
    return bland == MOAIEnvironment.OS_BRAND_ANDROID or bland == MOAIEnvironment.OS_BRAND_IOS
end

---------------------------------------
--- 実行環境がデスクトップかどうか返します.
---------------------------------------
function M:isDesktop()
    return not self:isMobile()
end

return M