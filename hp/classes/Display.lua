----------------------------------------------------------------
-- 描画オブジェクトを生成するモジュールです.<br>
-- オブジェクトの生成を簡単に行う事ができるようになります。
-- @class table
-- @name Display
----------------------------------------------------------------
local M = {}

-- classes
local Layer
local Sprite
local SpriteSheet
local MapSprite
local Graphics
local Group
local TextLabel

----------------------------------------------------------------
-- Layerインスタンスを生成して返します.
----------------------------------------------------------------
function M:newLayer(params)
    Layer = Layer or require("hp/classes/Layer")
    return Layer:new(params)
end

----------------------------------------------------------------
-- Spriteインスタンスを生成して返します.
----------------------------------------------------------------
function M:newSprite(params)
    Sprite = Sprite or require("hp/classes/Sprite")
    return Sprite:new(params)
end

----------------------------------------------------------------
-- SpriteSheetインスタンスを生成して返します.
----------------------------------------------------------------
function M:newSpriteSheet(params)
    SpriteSheet = SpriteSheet or require("hp/classes/SpriteSheet")
    return SpriteSheet:new(params)
end

----------------------------------------------------------------
-- MapSpriteインスタンスを生成して返します.
----------------------------------------------------------------
function M:newMapSprite(params)
    MapSprite = MapSprite or require("hp/classes/MapSprite")
    return MapSprite:new(params)
end

----------------------------------------------------------------
-- Graphicsインスタンスを生成して返します.
----------------------------------------------------------------
function M:newGraphics(params)
    Graphics = Graphics or require("hp/classes/Graphics")
    return Graphics:new(params)
end

----------------------------------------------------------------
-- TextLabelインスタンスを生成して返します.
----------------------------------------------------------------
function M:newText(params)
    TextLabel = TextLabel or require("hp/classes/TextLabel")
    return TextLabel:new(params)
end

----------------------------------------------------------------
-- Groupインスタンスを生成して返します.
----------------------------------------------------------------
function M:newGroup(params)
    Group = Group or require("hp/classes/Group")
    return Group:new(params)
end

----------------------------------------------------------------
-- Groupインスタンスを生成して返します.
----------------------------------------------------------------
function M:newAnimation(...)
    Animation = Animation or require("hp/classes/Animation")
    return Animation:new(...)
end

return M