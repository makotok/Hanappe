--------------------------------------------------------------------------------
-- 描画オブジェクトのファクトリークラスです.<br>
-- 各クラスをimportすると名前衝突する場合があるので、こちらを使用することもできます.
-- @class table
-- @name DisplayFactory
--------------------------------------------------------------------------------
local M = {}

local Sprite
local SpriteSheet
local MapSprite
local NinePatch
local TextLabel
local Graphics
local Group
local Layer
local Animation

function M.createSprite(...)
    Sprite = Sprite or require("hp/display/Sprite")
    return Sprite:new(...)
end

function M.createSpriteSheet(...)
    SpriteSheet = SpriteSheet or require("hp/display/SpriteSheet")
    return SpriteSheet:new(...)
end

function M.createMapSprite(...)
    MapSprite = MapSprite or require("hp/display/MapSprite")
    return MapSprite:new(...)
end

function M.createNinePatch(...)
    NinePatch = NinePatch or require("hp/display/NinePatch")
    return NinePatch:new(...)
end

function M.createTextLabel(...)
    TextLabel = TextLabel or require("hp/display/TextLabel")
    return TextLabel:new(...)
end

function M.createGraphics(...)
    Graphics = Graphics or require("hp/display/Graphics")
    return Graphics:new(...)
end

function M.createGroup(...)
    Group = Group or require("hp/display/Group")
    return Group:new(...)
end

function M.createLayer(...)
    Layer = Layer or require("hp/display/Layer")
    return Layer:new(...)
end

function M.createAnimation(...)
    Animation = Animation or require("hp/display/Animation")
    return Animation:new(...)
end

return M