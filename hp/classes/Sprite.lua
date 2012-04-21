local table = require("hp/lang/table")
local MOAIPropUtil = require("hp/classes/MOAIPropUtil")
local TextureManager = require("hp/classes/TextureManager")

----------------------------------------------------------------
-- 描画オブジェクトを生成するモジュールです.<br>
-- オブジェクトの生成を簡単に行う事ができるようになります。
-- @class table
-- @name Sprite
----------------------------------------------------------------
local M = {}
local I = {}

local function copyParams(prop, params)
    if params.texture then
        prop:setTexture(params.texture)
    end
    prop:setRectSize(params.width, params.height)
    if params.left then
        prop:setLeft(params.left)
    end
    if params.top then
        prop:setTop(params.top)
    end
    if params.layer then
        params.layer:insertProp(prop)
    end
end

----------------------------------------------------------------
-- Spriteインスタンスを生成して返します.
----------------------------------------------------------------
function M:new(params)
    assert(params, "params is nil!")
    assert(params.texture, "texture is nil!")

    -- prop, deck
    local deck = MOAIGfxQuad2D.new()
    local prop = MOAIProp.new()
    prop:setDeck(deck)
    prop.deck = deck
    deck:setUVRect(0, 0, 1, 1)

    -- custom functions
    table.copy(MOAIPropUtil, prop)
    table.copy(I, prop)

    copyParams(prop, params)
    
    return prop
end

----------------------------------------------------------------
-- Textureを設定します.
----------------------------------------------------------------
function I:setTexture(texture)
    if not texture then
        self.texture = nil
        self.deck:setTexture(nil)
        return
    end
    if type(texture) == "string" then
        texture = TextureManager:request(texture)
    end
    self.texture = texture
    self.deck:setTexture(texture)
end

----------------------------------------------------------------
-- 四角形のサイズを設定します.
----------------------------------------------------------------
function I:setRectSize(width, height)
    local tw, th = self.texture:getSize()
    width = width or tw
    height = height or th
    
    self.deck:setRect(-width / 2, -height / 2, width / 2, height / 2)
end

return M