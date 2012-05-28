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
    local inputManager = require("hp/manager/InputManager")
    
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
    t[prefix .. "Layer"]        = require("hp/display/Layer")
    t[prefix .. "Sprite"]       = require("hp/display/Sprite")
    t[prefix .. "SpriteSheet"]  = require("hp/display/SpriteSheet")
    t[prefix .. "MapSprite"]    = require("hp/display/MapSprite")
    t[prefix .. "Graphics"]     = require("hp/display/Graphics")
    t[prefix .. "Group"]        = require("hp/display/Group")
    t[prefix .. "TextLabel"]    = require("hp/display/TextLabel")
    t[prefix .. "NinePatch"]    = require("hp/display/NinePatch")
    t[prefix .. "Animation"]    = require("hp/display/Animation")
    
    -- manager classes
    t[prefix .. "SceneManager"]     = require("hp/manager/SceneManager")
    t[prefix .. "InputManager"]     = require("hp/manager/InputManager")
    t[prefix .. "TextureManager"]   = require("hp/manager/TextureManager")
    t[prefix .. "FontManager"]      = require("hp/manager/FontManager")
    t[prefix .. "WidgetManager"]      = require("hp/manager/WidgetManager")

    -- tmx classes
    t[prefix .. "TMXLayer"]         = require("hp/tmx/TMXLayer")
    t[prefix .. "TMXMap"]           = require("hp/tmx/TMXMap")
    t[prefix .. "TMXMapLoader"]     = require("hp/tmx/TMXMapLoader")
    t[prefix .. "TMXMapView"]       = require("hp/tmx/TMXMapView")
    t[prefix .. "TMXObject"]        = require("hp/tmx/TMXObject")
    t[prefix .. "TMXObjectGroup"]   = require("hp/tmx/TMXObjectGroup")
    t[prefix .. "TMXTileset"]       = require("hp/tmx/TMXTileset")
    
    -- widget classes
    t[prefix .. "View"] = require("hp/widget/View")
    t[prefix .. "ScrollView"] = require("hp/widget/ScrollView")
    t[prefix .. "Widget"] = require("hp/widget/Widget")
    t[prefix .. "Button"] = require("hp/widget/Button")
    t[prefix .. "RadioButton"] = require("hp/widget/RadioButton")
    t[prefix .. "RadioGroup"] = require("hp/widget/RadioGroup")
    t[prefix .. "Panel"] = require("hp/widget/Panel")
    t[prefix .. "MessageBox"] = require("hp/widget/MessageBox")
    t[prefix .. "Joystick"] = require("hp/widget/Joystick")
    
    -- rpg classes
    t[prefix .. "RPGMapView"] = require("hp/rpg/RPGMapView")
    t[prefix .. "RPGSprite"] = require("hp/rpg/RPGSprite")
    
    return t
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

---------------------------------------
--- フレーム開始時の色を設定します.
---------------------------------------
function M:setClearColor(r, g, b, a)
    MOAIGfxDevice.setClearColor(r, g, b, a)
end

---------------------------------------
-- スクリーンとViewportのベーススケールを返します.
---------------------------------------
function M:getViewScale()
    return self.screenWidth / self.viewWidth, self.screenHeight / self.viewHeight
end

return M