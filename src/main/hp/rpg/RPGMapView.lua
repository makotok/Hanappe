local table = require("hp/lang/table")
local class = require("hp/lang/class")
local TMXMapView = require("hp/tmx/TMXMapView")
local RPGSprite = require("hp/rpg/RPGSprite")

--------------------------------------------------------------------------------
-- RPG用のMapViewクラスです.<br>
-- マップで表示するオブジェクトがRPGSpriteになります.
-- @class table
-- @name RPGMapView
--------------------------------------------------------------------------------
local M = class(TMXMapView)

--------------------------------------------------------------------------------
-- 表示オブジェクトを作成します.
--------------------------------------------------------------------------------
function M:createDisplayObject(object)
    local tmxMap = self.tmxMap
    local gid = object.gid
    local tileset = tmxMap:findTilesetByGid(gid)
    self:loadTexture(tileset)

    local texture = tileset.texture
    local tw, th = texture:getSize()
    local spacing, margin = tileset.spacing, tileset.margin
    local tilewidth, tileheight = tileset.tilewidth, tileset.tileheight
    local tileCol = math.floor((tw + spacing) / tilewidth)
    local tileRow = math.floor((th + spacing) / tileheight)
    
    local sprite = RPGSprite:new({texture = texture, mapView = self})
    sprite.mapObject = object
    sprite.mapType = object.type

    sprite:setTiledSheets(tilewidth, tileheight, tileCol, tileRow)
    sprite:setLeft(object.x)
    sprite:setTop(object.y - sprite:getHeight())
    sprite:setIndex(object.gid - tileset.firstgid + 1)

    if object.properties.playAnim then
        sprite:playAnim(object.properties.playAnim)
    end
    if object.properties.moveType then
        sprite:setMoveType(object.properties.moveType)
    end
    
    return sprite
end

function M:onEnterFrame()
    for i, layer in ipairs(self.objectLayers) do
        for i, object in ipairs(layer.objects) do
            if object.onEnterFrame then
                object:onEnterFrame()
            end
        end
    end
end

return M