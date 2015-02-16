----------------------------------------------------------------------------------------------------
-- TODO:Doc
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local UIComponent = require "flower.widget.UIComponent"

-- class
local Spacer = class(UIComponent)

function Spacer:_initInternal()
    Spacer.__super._initInternal(self)
    self._focusEnabled = false
end

return Spacer