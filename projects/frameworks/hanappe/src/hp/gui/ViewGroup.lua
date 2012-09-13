----------------------------------------------------------------
-- Viewを格納できるコンテナクラスです. <br>
-- @class table
-- @name ViewGroup
----------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local class                 = require "hp/lang/class"
local Layer                 = require "hp/display/Layer"
local Event                 = require "hp/event/Event"
local Executors             = require "hp/util/Executors"
local View                  = require "hp/gui/view/View"

-- class define
local M                     = class(View)
local super                 = View

--------------------------------------------------------------------------------
-- Viewの初期化処理を行います.
-- デフォルトのサイズは、画面サイズとします.
--------------------------------------------------------------------------------
function M:initComponent()
    self:setSize(Application.screenWidth, Application.screenHeight)
    super.initComponent(self)
end

--------------------------------------------------------------------------------
-- ViewGroupはLayerを持たないため、無効にします.
--------------------------------------------------------------------------------
function M:initViewLayer()
end

--------------------------------------------------------------------------------
-- ViewGroupはLayerを持たないため、無効にします.
--------------------------------------------------------------------------------
function M:setLayer(layer)
end

--------------------------------------------------------------------------------
-- 描画レイヤーテーブルを返します.
--------------------------------------------------------------------------------
function M:getRenderTable()
    local t = {}
    for i, v in ipairs(self:getChildren()) do
        table.insert(t, v:getRenderTable())
    end
    return t
end

return M