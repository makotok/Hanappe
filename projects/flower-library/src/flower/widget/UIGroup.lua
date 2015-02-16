----------------------------------------------------------------------------------------------------
-- It is a class that can have on a child UIComponent.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
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