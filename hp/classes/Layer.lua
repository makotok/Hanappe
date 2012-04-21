local table = require("hp/lang/table")
local Application = require("hp/Application")
local MOAIPropUtil = require("hp/classes/MOAIPropUtil")

----------------------------------------------------------------
-- 描画オブジェクトを生成するモジュールです.<br>
-- オブジェクトの生成を簡単に行う事ができるようになります。
-- @class table
-- @name display
----------------------------------------------------------------
local M = {}
local I = {}

local function copyParams(self, params)
    if params.width and params.height then
        self.viewport:setSize(params.width, params.height)
    end
    if params.viewWidth and params.viewHeight then
        self.viewport:setScale(params.viewWidth, params.viewHeight)
    end
    if params.offsetX and params.offsetY then
        self.viewport:setOffset(params.offsetX, params.offsetY)
    end
    if params.left then
        self:setLeft(params.left)
    end
    if params.top then
        self:setTop(params.top)
    end
    if params.scene then
        params.scene:addChild(self)
    end
end

----------------------------------------------------------------
-- Viewインスタンスを生成して返します.
----------------------------------------------------------------
function M:new(params)
    params = params or {}

    -- viewport
    local viewport = MOAIViewport.new()
    viewport:setSize(Application.screenWidth, Application.screenHeight)
    viewport:setScale(Application.viewWidth, -Application.viewHeight)
    viewport:setOffset(-1, 1)
    
    -- layer
    local layer = MOAILayer.new()
    layer:setViewport(viewport)
    layer.viewport = vierport

    -- custom functions
    table.copy(I, layer)

    -- set params
    copyParams(layer, params)
    
    MOAIRenderMgr.pushRenderPass(layer)
    
    return layer
end

function I:setScreenSize(width, height)
    self.viewport:setSize(width, height)
end

function I:setViewSize(width, height)
    self.viewport:setScale(width, -height)
end

return M