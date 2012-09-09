--------------------------------------------------------------------------------
-- パネルクラスです.<br>
-- @class table
-- @name Panel
--------------------------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local NinePatch         = require "hp/display/NinePatch"
local TextLabel         = require "hp/display/TextLabel"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/component/Component"

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
    local borderSkinClass = self:getStyle("borderSkinClass")

    self._background = backgroundSkinClass()
    self._background:setTexture(self:getStyle("backgroundSkin"))
    
    self._border = borderSkinClass()
    self._border:setTexture(self:getStyle("borderSkin"))
    
    self:addChild(self._background)
    self:addChild(self._border)
end

--------------------------------------------------------------------------------
-- スタイルの更新を行います.
--------------------------------------------------------------------------------
function M:updateStyles()
    local background = self._background
    background:setColor(unpack(self:getStyle("backgroundColor")))
    background:setTexture(self:getStyle("backgroundSkin"))

    local border = self._border
    border:setColor(unpack(self:getStyle("borderColor")))
    border:setTexture(self:getStyle("borderSkin"))
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:resizeHandler(e)
    self._background:setSize(e.newWidth, e.newHeight)
    self._border:setSize(e.newWidth, e.newHeight)
end

return M