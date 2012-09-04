--------------------------------------------------------------------------------
-- This is a class to manage the Font.
--
-- @auther Makoto
-- @class table
-- @name FontManager
--------------------------------------------------------------------------------

local class = require "hp/lang/class"
local Event = require "hp/event/Event"
local EventDispatcher = require "hp/event/EventDispatcher"

local M = EventDispatcher()

--------------------------------------------------------------------------------
-- コンポーネントにフォーカスをセットします.
--------------------------------------------------------------------------------
function M:setFocus(component)
    if component == self.focusedComponent then
        return
    end
    if not component:isFocusEnabled() then
        return
    end
    
    if self.focusedComponent then
        self.focusedComponent:dispatchEvent(Event.FOCUS_OUT)
    end
    
    self.focusedComponent = component
    
    if self.focusedComponent then
        self.focusedComponent:dispatchEvent(Event.FOCUS_IN)
    end
end

--------------------------------------------------------------------------------
-- フォーカスがセットされているコンポーネントを返します.
--------------------------------------------------------------------------------
function M:getFocus()
    return self.focusedComponent
end


return M
