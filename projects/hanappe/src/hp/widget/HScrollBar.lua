local table = require("hp/lang/table")
local class = require("hp/lang/class")
local ScrollBarBase = require("hp/widget/ScrollBarBase")
local WidgetManager = require("hp/manager/WidgetManager")

----------------------------------------------------------------
-- スクロールバークラスです.<br>
-- 水平バーを表示するだけです.
-- @class table
-- @name HScrollBar
----------------------------------------------------------------
local M = class(ScrollBarBase)

local super = ScrollBarBase

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
end

--------------------------------------------------------------------------------
-- デフォルトテーマを返します.
--------------------------------------------------------------------------------
function M:getDefaultTheme()
    return WidgetManager:getDefaultTheme()["HScrollBar"]
end

return M