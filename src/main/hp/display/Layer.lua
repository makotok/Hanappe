local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Application = require("hp/Application")
local DisplayObject = require("hp/display/DisplayObject")

--------------------------------------------------------------------------------
-- MOAILayerを拡張したクラスです.<br>
-- サイズの設定など、レイヤーの生成を簡略化します.<br>
-- @class table
-- @name Layer
--------------------------------------------------------------------------------
local M = class(DisplayObject)
M.MOAI_CLASS = MOAILayer

--------------------------------------------------------------------------------
-- Layerインスタンスを生成して返します.
--------------------------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)
    
    params = params or {}

    local partition = MOAIPartition.new()
    self:setPartition(partition)
    self.partition = partition

    local viewport = MOAIViewport.new()
    self:setViewport(viewport)
    self.viewport = viewport
    
    self:setScreenSize(Application.screenWidth, Application.screenHeight)
    self:setViewSize(Application.viewWidth, Application.viewHeight)
    self:setOffset(-1, 1)
    
    -- set params
    self:copyParams(params)
    
    MOAIRenderMgr.pushRenderPass(self)
end

--------------------------------------------------------------------------------
-- パラメータを各プロパティにコピーします.
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.width and params.height then
        self:setScreenSize(params.width, params.height)
    end
    if params.viewWidth and params.viewHeight then
        self:setViewSize(params.viewWidth, params.viewHeight)
    end
    if params.offsetX and params.offsetY then
        self:setOffset(params.offsetX, params.offsetY)
    end
    if params.scene then
        params.scene:addChild(self)
    end
    
    DisplayObject.copyParams(self, params)
end

--------------------------------------------------------------------------------
-- 画面上のレイヤーのサイズを返します.
-- TODO:変数によるアクセスは将来的に削除される予定です.
--------------------------------------------------------------------------------
function M:getScreenWidth()
    return self.screenWidth
end

--------------------------------------------------------------------------------
-- 画面上のレイヤーのサイズを返します.
-- TODO:変数によるアクセスは将来的に削除される予定です.
--------------------------------------------------------------------------------
function M:getScreenHeight()
    return self.screenHeight
end

--------------------------------------------------------------------------------
-- 画面上のレイヤーのサイズを返します.
-- TODO:変数によるアクセスは将来的に削除される予定です.
--------------------------------------------------------------------------------
function M:getScreenSize()
    return self:getScreenWidth(), self:getScreenHeight()
end

--------------------------------------------------------------------------------
-- 画面上のレイヤーのサイズを設定します.
--------------------------------------------------------------------------------
function M:setScreenSize(width, height)
    self.screenWidth = width
    self.screenHeight = height
    self.viewport:setSize(width, height)
end

--------------------------------------------------------------------------------
-- レイヤーのビューポートサイズを設定します.
--------------------------------------------------------------------------------
function M:getViewWidth()
    return self.viewWidth
end

--------------------------------------------------------------------------------
-- レイヤーのビューポートサイズを設定します.
--------------------------------------------------------------------------------
function M:getViewHeight()
    return self.viewHeight
end

--------------------------------------------------------------------------------
-- レイヤーのビューポートサイズを設定します.
--------------------------------------------------------------------------------
function M:getViewSize()
    return self:getViewWidth(), self:getViewHeight()
end

--------------------------------------------------------------------------------
-- レイヤーのビューポートサイズを設定します.
--------------------------------------------------------------------------------
function M:setViewSize(width, height)
    self.viewWidth = width
    self.viewHeight = height
    self.viewport:setScale(width, -height)
end

--------------------------------------------------------------------------------
-- ビューポートのオフセットを設定します.
--------------------------------------------------------------------------------
function M:setOffset(offsetX, offsetY)
    self.offsetX = offsetX
    self.offsetY = offsetY
    self.viewport:setOffset(offsetX, offsetY)
end

---------------------------------------
-- スクリーンとViewportのスケールを返します.
---------------------------------------
function M:getViewScale()
    return self.screenWidth / self.viewWidth, self.screenHeight / self.viewHeight
end

---------------------------------------
-- スクリーンとViewportのスケールを返します.
---------------------------------------
function M:getViewScaleX()
    return self.screenWidth / self.viewWidth
end

---------------------------------------
-- スクリーンとViewportのスケールを返します.
---------------------------------------
function M:getViewScaleY()
    return self.screenHeight / self.viewHeight
end

--------------------------------------------------------------------------------
-- シーンを設定します.
--------------------------------------------------------------------------------
function M:setScene(scene)
    if self.scene == scene then
        self.scene:removeChild(self)
    end
    self.scene = scene
    if self.scene then
        self.scene:addChild(self)
    end
end

return M