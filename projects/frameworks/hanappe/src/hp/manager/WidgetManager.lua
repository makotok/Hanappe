----------------------------------------------------------------
-- This is a class to manage widgets.<br>
--
-- @auther Makoto
-- @class table
-- @name WidgetManager
----------------------------------------------------------------

local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")

local M = EventDispatcher()

-- variables
local defaultTheme
local defaultThemeCangedEvent = Event:new("defaultThemeChanged")

----------------------------------------------------------------
-- Sets the default widget theme to use.
-- @param theme Widget theme.
----------------------------------------------------------------
function M:setDefaultThemes(theme)
    theme = type(theme) == "string" and require(theme) or theme
    if defaultTheme ~= theme then
        defaultTheme = theme
        self:dispatchEvent(defaultThemeCangedEvent)
    end
end

----------------------------------------------------------------
-- Returns the current default theme.
-- @return default theme.
----------------------------------------------------------------
function M:getDefaultThemes()
    return defaultTheme
end


return M