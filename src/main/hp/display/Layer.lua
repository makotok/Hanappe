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

--------------------------------------------------------------------------------
-- Layerインスタンスを生成して返します.
--------------------------------------------------------------------------------
function M:new(params)
    params = params or {}

    -- layer
    local layer = MOAILayer.new()
    table.copy(self, layer)
    
    -- partition
    local partition = MOAIPartition.new()
    layer:setPartition(partition)
    layer.partition = partition

    -- viewport
    local viewport = MOAIViewport.new()
    layer:setViewport(viewport)
    layer.viewport = viewport
    
    layer:setScreenSize(Application.screenWidth, Application.screenHeight)
    layer:setViewSize(Application.viewWidth, Application.viewHeight)
    layer:setOffset(-1, 1)
    
    -- set params
    layer:copyParams(params)
    
    MOAIRenderMgr.pushRenderPass(layer)
    
    return layer
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

return M