----------------------------------------------------------------
-- RPGSpriteの移動を行うクラスです.<br>
-- ランダム移動を行います.<br>
-- @class table
-- @name RPGRandomMove
----------------------------------------------------------------
local table = require("hp/lang/table")
local class = require("hp/lang/class")
local RPGMove = require("hp/rpg/move/RPGMove")

local M = class(RPGMove)

local super = RPGMove

math.randomseed(os.time())

----------------------------------------------------------------
-- コンストラクタです.<br>
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
end

----------------------------------------------------------------
-- ランダム移動処理を行います.
----------------------------------------------------------------
function M:onStep()
    local target = self:getTarget()
    local r = math.random(200)
    target:moveMap(r)
end

return M