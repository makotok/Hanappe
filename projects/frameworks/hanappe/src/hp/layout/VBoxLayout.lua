local class = require("hp/lang/class")
local BoxLayout = require("hp/layout/BoxLayout")

----------------------------------------------------------------
-- デフォルトで垂直方向にオブジェクトを配置するBoxLayoutです
-- @class table
-- @name VBoxLayout
----------------------------------------------------------------
local M = class(BoxLayout)

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    M:super(self, params)
    self.direction = BoxLayout.DIRECTION_V
end

return M