----------------------------------------------------------------
-- RPGMoveを作成するファクトリークラスです.<br>
-- @class table
-- @name RPGMoveFactory
----------------------------------------------------------------
local table = require("hp/lang/table")
local class = require("hp/lang/class")
local RPGRandomMove = require("hp/rpg/move/RPGRandomMove")

local M = class()

M.MOVE_CLASSES = {
    randomMove = RPGRandomMove,
}

----------------------------------------------------------------
-- 移動を行うクラスのインスタンスを生成します.<br>
----------------------------------------------------------------
function M:createMove(name, params)
    if not name then
        return
    end

    local moveClass = self.MOVE_CLASSES[name]
    if moveClass then
        return moveClass:new(params)
    end
end

return M