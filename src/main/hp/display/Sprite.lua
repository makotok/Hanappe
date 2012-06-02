local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local TextureDrawable = require("hp/display/TextureDrawable")

--------------------------------------------------------------------------------
-- 描画オブジェクトを生成するモジュールです.<br>
-- オブジェクトの生成を簡単に行う事ができるようになります。
-- @class table
-- @name Sprite
--------------------------------------------------------------------------------
local M = class(DisplayObject, TextureDrawable)

--------------------------------------------------------------------------------
-- Spriteインスタンスを生成して返します.
--------------------------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)

    params = params or {}
    
    local deck = MOAIGfxQuad2D.new()
    deck:setUVRect(0, 0, 1, 1)
    
    self:setDeck(deck)
    self.deck = deck

    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- パラメータテーブルの値を元に、各setter関数の引数にセットしてコールします.
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.texture and self.setTexture then
        self:setTexture(params.texture)
        self:setSize()
    end
    if params.width and params.height then
        self:setSize(params.width, params.height)
    end

    DisplayObject.copyParams(self, params)
end

--------------------------------------------------------------------------------
-- 幅を設定します.
--------------------------------------------------------------------------------
function M:setWidth(width)
    self:setSize(width, self:getHeight())
end

--------------------------------------------------------------------------------
-- 高さを設定します.
--------------------------------------------------------------------------------
function M:setHeight(height)
    self:setSize(self:getWidth(), height)
end

--------------------------------------------------------------------------------
--サイズを設定します.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    if self.texture then
        local tw, th = self.texture:getSize()
        width = width or tw
        height = height or th
    end
    
    local left, top = self:getLeft(), self:getTop()
    self.deck:setRect(-width / 2, -height / 2, width / 2, height / 2)
    self:setLeft(left)
    self:setTop(top)
end

return M