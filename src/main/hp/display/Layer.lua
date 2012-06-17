--------------------------------------------------------------------------------
-- This class inherits the MOAILayer. <br>
-- Simplifies the generation of a set of size and layer. <br>
--
-- @auther Makoto
-- @class table
-- @name Layer
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Application = require("hp/Application")
local DisplayObject = require("hp/display/DisplayObject")

local M = class(DisplayObject)
M.MOAI_CLASS = MOAILayer

----------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
----------------------------------------------------------------
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
    
    self:copyParams(params)
    
    MOAIRenderMgr.pushRenderPass(self)
end

--------------------------------------------------------------------------------
-- Set the parameter setter function.
-- @param params Parameter is set to Object.<br>
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
-- Returns the size of the layer on the screen.
-- @return Width of screen.
--------------------------------------------------------------------------------
function M:getScreenWidth()
    return self.screenWidth
end

--------------------------------------------------------------------------------
-- Returns the size of the layer on the screen.
-- @return Height of screen.
--------------------------------------------------------------------------------
function M:getScreenHeight()
    return self.screenHeight
end

--------------------------------------------------------------------------------
-- Returns the size of the layer on the screen.
-- @return width, height
--------------------------------------------------------------------------------
function M:getScreenSize()
    return self:getScreenWidth(), self:getScreenHeight()
end

--------------------------------------------------------------------------------
-- Sets the size of the layer on the screen.
-- @param width Width of the screen.
-- @param height Height of the screen.
--------------------------------------------------------------------------------
function M:setScreenSize(width, height)
    self.screenWidth = width
    self.screenHeight = height
    self.viewport:setSize(width, height)
end

--------------------------------------------------------------------------------
-- Returns the viewport size of the layer.
-- @return viewWidth.
--------------------------------------------------------------------------------
function M:getViewWidth()
    return self.viewWidth
end

--------------------------------------------------------------------------------
-- Returns the viewport size of the layer.
-- @return viewHeight.
--------------------------------------------------------------------------------
function M:getViewHeight()
    return self.viewHeight
end

--------------------------------------------------------------------------------
-- Returns the viewport size of the layer.
-- @return viewWidth, viewHeight.
--------------------------------------------------------------------------------
function M:getViewSize()
    return self:getViewWidth(), self:getViewHeight()
end

--------------------------------------------------------------------------------
-- Sets the viewport size of the layer.
-- @param width Width of the viewport.
-- @param height Height of the viewport.
--------------------------------------------------------------------------------
function M:setViewSize(width, height)
    self.viewWidth = width
    self.viewHeight = height
    self.viewport:setScale(width, -height)
end

--------------------------------------------------------------------------------
-- Sets the offset of the viewport.
-- @param offsetX offsetX.
-- @param offsetY offsetY.
--------------------------------------------------------------------------------
function M:setOffset(offsetX, offsetY)
    self.offsetX = offsetX
    self.offsetY = offsetY
    self.viewport:setOffset(offsetX, offsetY)
end

--------------------------------------------------------------------------------
-- Returns the scale of the screen and viewport.
-- @return scaleX, scaleY.
--------------------------------------------------------------------------------
function M:getViewScale()
    return self.screenWidth / self.viewWidth, self.screenHeight / self.viewHeight
end

--------------------------------------------------------------------------------
-- Returns the scale of the screen and viewport.
-- @return scaleX
--------------------------------------------------------------------------------
function M:getViewScaleX()
    return self.screenWidth / self.viewWidth
end

--------------------------------------------------------------------------------
-- Returns the scale of the screen and viewport.
-- @return scaleY.
--------------------------------------------------------------------------------
function M:getViewScaleY()
    return self.screenHeight / self.viewHeight
end

--------------------------------------------------------------------------------
-- Sets the scene.<br>
-- By setting the scene, and then draw in the scene.
-- @param scene scene.
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