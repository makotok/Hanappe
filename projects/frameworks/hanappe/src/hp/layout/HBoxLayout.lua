local class = require("hp/lang/class")
local BoxLayout = require("hp/layout/BoxLayout")

----------------------------------------------------------------
-- デフォルトで水平方向にオブジェクトを配置するBoxLayoutです
-- @class table
-- @name HBoxLayout
----------------------------------------------------------------
local M = class(BoxLayout)

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    M:super(self, params)
    self.direction = BoxLayout.DIRECTION_H
end

return M