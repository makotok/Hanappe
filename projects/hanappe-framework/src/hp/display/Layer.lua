--------------------------------------------------------------------------------
-- This class inherits the MOAILayer. <br>
-- Simplifies the generation of a set of size and layer. <br>
--------------------------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local class                 = require "hp/lang/class"
local Application           = require "hp/core/Application"
local DisplayObject         = require "hp/display/DisplayObject"
local Resizable             = require "hp/display/Resizable"
local TouchProcessor        = require "hp/display/TouchProcessor"

-- class define
local M                     = class(DisplayObject, Resizable)
local MOAILayerInterface    = MOAILayer.getInterfaceTable()
M.MOAI_CLASS                = MOAILayer

----------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
----------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)
    self:setTouchEnabled(false)
    
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
end

--------------------------------------------------------------------------------
-- Sets the size of the layer.
-- @param width width of layer.
-- @param height height of layer.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    self:setScreenSize(width, height)
    self:setViewSize(width, height)
end

--------------------------------------------------------------------------------
-- Returns the size of the layer on the screen.
-- @return Width of screen.
--------------------------------------------------------------------------------
function M:getScreenWidth()
    return self.screenWidth
end

--------------------------------------------------------------------------------
-- Sets the size of the layer on the screen.
-- @param width Width of screen.
--------------------------------------------------------------------------------
function M:setScreenWidth(width)
    self:setScreenSize(width, self:getScreenHeight())
end

--------------------------------------------------------------------------------
-- Returns the size of the layer on the screen.
-- @return Height of screen.
--------------------------------------------------------------------------------
function M:getScreenHeight()
    return self.screenHeight
end

--------------------------------------------------------------------------------
-- Sets the size of the layer on the screen.
-- @param height Height of screen.
--------------------------------------------------------------------------------
function M:setScreenHeight(height)
    self:setScreenSize(self:getScreenHeight(), height)
end

--------------------------------------------------------------------------------
-- Returns the size of the layer on the screen.
-- @return width
-- @return height
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
    if self.screenWidth and self.screenHeight then
        self.viewport:setSize(width, height)
    end
end

--------------------------------------------------------------------------------
-- Returns the viewport size of the layer.
-- @return viewWidth.
--------------------------------------------------------------------------------
function M:getViewWidth()
    return self.viewWidth
end

--------------------------------------------------------------------------------
-- Sets the viewport size of the layer.
-- @param width Width of viewport.
--------------------------------------------------------------------------------
function M:setViewWidth(width)
    self:setViewSize(width, self:getViewHeight())
end

--------------------------------------------------------------------------------
-- Returns the viewport size of the layer.
-- @return viewHeight.
--------------------------------------------------------------------------------
function M:getViewHeight()
    return self.viewHeight
end

--------------------------------------------------------------------------------
-- Sets the viewport size of the layer.
-- @param height height of viewport
--------------------------------------------------------------------------------
function M:setViewHeight(height)
    self:setViewSize(self:getViewWidth(), height)
end

--------------------------------------------------------------------------------
-- Returns the viewport size of the layer.
-- @return viewWidth
-- @return viewHeight
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
    if self.viewWidth and self.viewHeight then
        self.viewport:setScale(width, -height)
    end
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
-- @return scale
--------------------------------------------------------------------------------
function M:getViewScale()
    return self.screenWidth / self.viewWidth
end

--------------------------------------------------------------------------------
-- Returns self.
-- @return self
--------------------------------------------------------------------------------
function M:getLayer()
    return self
end

--------------------------------------------------------------------------------
-- Sets the scene.<br>
-- By setting the scene, and then draw in the scene.
-- @param scene scene.
--------------------------------------------------------------------------------
function M:setScene(scene)
    if self.scene == scene then
        return
    end
    if self.scene then
        self.scene:removeChild(self)
    end
    
    self.scene = scene
    
    if self.scene then
        self.scene:addChild(self)
    end
    
    if self._touchProcessor then
        self._touchProcessor:setEventSource(scene)
    end
end

--------------------------------------------------------------------------------
-- Returns the scene.
--------------------------------------------------------------------------------
function M:getScene()
    return self.scene
end

--------------------------------------------------------------------------------
-- Sets the props<br>
-- @param props props
--------------------------------------------------------------------------------
function M:setProps(props)
    self:clear()
    for i, prop in ipairs(props) do
        if prop.setLayer then
            prop:setLayer(self)
        else
            self:insertProp(prop)
        end
    end
end

--------------------------------------------------------------------------------
-- Sets the touch enabled.
-- @param value touch enabled.
--------------------------------------------------------------------------------
function M:setTouchEnabled(value)
    if self._touchEnabled == value then
        return
    end
    
    self._touchEnabled = value
    
    if value and not self._touchProcessor then
        self._touchProcessor = TouchProcessor(self)
        self._touchProcessor:setEventSource(self:getScene())
    end
    if self._touchProcessor then
        self._touchProcessor:setEnabled(value)
    end
end

--------------------------------------------------------------------------------
-- Sets the TouchProcessor object.
--------------------------------------------------------------------------------
function M:setTouchProcessor(value)
    if self._touchProcessor then
        self._touchProcessor:dispose(nil)
        self._touchProcessor = nil
    end
    self._touchProcessor = value
end

--------------------------------------------------------------------------------
-- Dispose resourece.
--------------------------------------------------------------------------------
function M:dispose()
    self:setScene(nil)
    self:clear()
    if self._touchProcessor then
        self._touchProcessor:dispose()
    end
end

--------------------------------------------------------------------------------
-- Create and sets camera.
-- @param ortho ortho
-- @param near near
-- @param far far
--------------------------------------------------------------------------------
function M:createCamera(ortho, near, far)
    ortho = ortho ~= nil and ortho or true
    near = near or 1
    far = far or -1

    local camera = MOAICamera.new()
    camera:setOrtho(ortho)
    camera:setNearPlane(near)
    camera:setFarPlane(far)
    self:setCamera(camera)
    self.camera = camera
    
    return camera
end

return M