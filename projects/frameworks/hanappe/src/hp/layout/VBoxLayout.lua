----------------------------------------------------------------
-- デフォルトで垂直方向にオブジェクトを配置するBoxLayoutです
-- @class table
-- @name VBoxLayout
----------------------------------------------------------------

-- import
local class             = require "hp/lang/class"
local BoxLayout         = require "hp/layout/BoxLayout"

-- class define
local M                 = class(BoxLayout)
local super             = BoxLayout

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    super.init(self, params)
    self.direction = BoxLayout.DIRECTION_V
end

return M