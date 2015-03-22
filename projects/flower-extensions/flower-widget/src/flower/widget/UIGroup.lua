----------------------------------------------------------------------------------------------------
-- It is a class that can have on a child UIComponent.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.widget.UIComponent.html">UIComponent</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local UIComponent = require "flower.widget.UIComponent"

-- class
local UIGroup = class(UIComponent)

---
-- Initialization is the process of internal variables.
-- Please to inherit this function if the definition of the variable.
function UIGroup:_initInternal()
    UIGroup.__super._initInternal(self)
    self.isUIGroup = true
    self._focusEnabled = false
end

return UIGroup