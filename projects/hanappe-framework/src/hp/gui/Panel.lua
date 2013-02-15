--------------------------------------------------------------------------------
-- パネルクラスです.<br>
--------------------------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local NinePatch         = require "hp/display/NinePatch"
local TextLabel         = require "hp/display/TextLabel"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/Component"

-- class define
local M                 = class(Component)
local super             = Component

--------------------------------------------------------------------------------
-- 内部変数の初期化処理を行います.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._themeName = "Panel"
end

----------------------------------------------------------------
-- 子コンポーネントを生成します.
----------------------------------------------------------------
function M:createChildren()
    local backgroundSkinClass = self:getStyle("backgroundSkinClass")
    self._background = backgroundSkinClass()
    self._background:setTexture(self:getStyle("backgroundSkin"))
    self:addChild(self._background)
end

--------------------------------------------------------------------------------
-- 表示の更新を行います.
--------------------------------------------------------------------------------
function M:updateDisplay()
    local background = self._background
    background:setColor(unpack(self:getStyle("backgroundColor")))
    background:setTexture(self:getStyle("backgroundSkin"))
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:resizeHandler(e)
    self._background:setSize(e.newWidth, e.newHeight)
end

return M