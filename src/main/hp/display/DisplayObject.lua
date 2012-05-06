local class = require("hp/lang/class")
local MOAIPropUtil = require("hp/util/MOAIPropUtil")

--------------------------------------------------------------------------------
-- 描画オブジェクトの基底クラスです.<br>
-- MOAIPropを拡張して、便利な関数を追加します.
-- @class table
-- @name DisplayObject
--------------------------------------------------------------------------------
local M = class(MOAIPropUtil)

--------------------------------------------------------------------------------
-- パラメータテーブルの値を元に、各setter関数の引数にセットしてコールします.
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.left then
        self:setLeft(params.left)
    end
    if params.top then
        self:setTop(params.top)
    end
    if params.layer then
        self:setLayer(params.layer)
    end
end

--------------------------------------------------------------------------------
-- レイヤーを設定します.
--------------------------------------------------------------------------------
function M:setLayer(layer)
    if self.layer == layer then
        return
    end

    if self.layer then
        self.layer:removeProp(self)
    end

    self.layer = layer

    if self.layer then
        layer:insertProp(self)
    end
end

return M