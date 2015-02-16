----------------------------------------------------------------------------------------------------
-- @type UIView
-- This is a view class that displays the component.
-- Widgets to the root class view.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local UIGroup = require "flower.widget.UIGroup"
local UILayer = require "flower.widget.UILayer"

-- class
local UIView = class(UIGroup)

---
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
function UIView:_initInternal()
    UIView.__super._initInternal(self)
    self.isUIView = true

    self:setSize(flower.getViewSize())
    self:setScissorContent(true)
end

---
-- Initializes the layer to display the view.
function UIView:_initLayer()
    if self.layer then
        return
    end

    local layer = UILayer()
    self:setLayer(layer)
end

function UIView:validateLayout()
    if self._invalidateLayoutFlag then
        UIView.__super.validateLayout(self)

        -- root
        if not self.parent then
            self:updatePriority()
        end
    end
end

---
-- Sets the scene for layer.
-- @param scene scene
function UIView:setScene(scene)
    self:_initLayer()
    self.layer:setScene(scene)
end

return UIView