----------------------------------------------------------------
-- デフォルトで水平方向にオブジェクトを配置するBoxLayoutです
-- @class table
-- @name HBoxLayout
----------------------------------------------------------------

-- import
local class             = require "hp/lang/class"
local BoxLayout         = require "hp/gui/layout/BoxLayout"

-- class define
local M                 = class(BoxLayout)
local super             = BoxLayout

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    super.init(self, params)
    self.direction = BoxLayout.DIRECTION_H
end

return M