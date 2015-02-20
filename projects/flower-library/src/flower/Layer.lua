----------------------------------------------------------------------------------------------------
-- This is flower's idea of a Layer, which is a superclass of the MOAI concept of Layer.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.DisplayObject.html">DisplayObject</a><l/i>
--   <li><a href="http://moaiforge.github.io/moai-sdk/api/latest/class_m_o_a_i_layer.html">MOAILayer</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Config = require "flower.Config"
local DisplayObject = require "flower.DisplayObject"
local Viewport = require "flower.Viewport"
local TouchHandler = require "flower.TouchHandler"

-- class
local Layer = class(DisplayObject)
Layer.__index = MOAILayer.getInterfaceTable()
Layer.__moai_class = MOAILayer

---
-- The constructor.
-- @param viewport (option)viewport
function Layer:init(viewport)
    Layer.__super.init(self)

    local partition = MOAIPartition.new()
    self:setPartition(partition)
    self.partition = partition

    self:setViewport(viewport or Viewport.getDefaultViewport())
    self.touchEnabled = false
    self.touchHandler = nil
    self.touchHandlerClass = TouchHandler
end

---
-- Enables this layer for touch events.
-- @param value enabled
function Layer:setTouchEnabled(value)
    if self.touchEnabled == value then
        return
    end
    self.touchEnabled = value
    if value  then
        self.touchHandler = self.touchHandler or self.touchHandlerClass(self)
    end
end

---
-- Sets the scene for this layer.
-- @param scene scene
function Layer:setScene(scene)
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
end

---
-- Unsupport nested layer.
-- @param layer layer
function Layer:setLayer(layer)
end

return Layer