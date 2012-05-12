local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")

----------------------------------------------------------------
-- ウィジットクラスを管理するクラスです.<br>
-- ウィジットのテーマや名前生成を管理します.
-- @class table
-- @name WidgetManager
----------------------------------------------------------------
local M = EventDispatcher:new()

-- variables
local defaultTheme
local defaultThemeCangedEvent = Event:new("defaultThemeChanged")

----------------------------------------------------------------
-- ウィジットが使用するデフォルトテーマを設定します.
-- 生成済ウィジットには影響がありません.
-- 新規に生成するウィジットはデフォルトテーマを使用します.
----------------------------------------------------------------
function M:setDefaultTheme(theme)
    theme = type(theme) == "string" and require(theme) or theme
    if defaultTheme ~= theme then
        defaultTheme = theme
        self:dispatchEvent(defaultThemeCangedEvent)
    end
end

----------------------------------------------------------------
-- 現在のデフォルトテーマを返します.
----------------------------------------------------------------
function M:getDefaultTheme()
    return defaultTheme
end


return M