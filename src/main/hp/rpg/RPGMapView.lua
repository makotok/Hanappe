local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Application = require("hp/Application")
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
-- コンストラクタです.
-- この段階では表示オブジェクトは生成しません.
-- loadMap関数を使用する事で、表示オブジェクトを生成します.
--------------------------------------------------------------------------------
function M:init(resourceDirectory)
    TMXMapView.init(self, resourceDirectory)
    self.cameraToFocusObjectEnabled = true
end

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
    if object.properties.visible then
        sprite:setVisible(toboolean(object.properties.visible))
    end
    
    return sprite
end

--------------------------------------------------------------------------------
-- マップ読み込み後、カメラの位置をプレイヤーの座標に設定します.
--------------------------------------------------------------------------------
function M:loadMap(tmxMap)
    TMXMapView.loadMap(self, tmxMap)
    self.focusObject = self:findPlayerObject()
    self.collisionLayer = self:findCollisionLayer()
    
    self:scrollCameraToFocusObject()
end

--------------------------------------------------------------------------------
-- フレーム毎の処理を行います.
--------------------------------------------------------------------------------
function M:onEnterFrame()
    -- object move
    for i, layer in ipairs(self.objectLayers) do
        for i, object in ipairs(layer.objects) do
            if object.onEnterFrame then
                object:onEnterFrame()
            end
        end
    end
    
    -- camera move
    self:scrollCameraToFocusObject()
end

--------------------------------------------------------------------------------
-- 指定した位置の衝突判定を行います.
--------------------------------------------------------------------------------
function M:collisionWith(object, x, y)
    if self:collisionWithMap(x, y) then
        return true
    end
    if self:collisionWithObjects(x, y) then
        return true
    end
    return false
end
--------------------------------------------------------------------------------
-- 指定した位置と衝突判定レイヤーが衝突するか判定します.
--------------------------------------------------------------------------------
function M:collisionWithMap(x, y)
    if not self.collisionLayer then
        return false
    end
    
    local gid = self.collisionLayer:getGid(x, y)
    return gid and gid > 0
end

--------------------------------------------------------------------------------
-- 指定した位置とオブジェクトが衝突するか判定します.
--------------------------------------------------------------------------------
function M:collisionWithObjects(x, y)
    for i, objectLayer in ipairs(self.objectLayers) do
        for j, object in ipairs(objectLayer.objects) do
--            if object:getMapX() >= x and x < object:getMapX() + object:getMapWidth() and 
--               object:getMapY() >= y and y < object:getMapY() + object:getMapHeight() then
            if object:getMapX() == x and 
               object:getMapY() == y then
                return true
            end
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- Playerというnameのオブジェクトを検索して返します.
--------------------------------------------------------------------------------
function M:findPlayerObject()
    return self:findObjectByName("Player")
end

--------------------------------------------------------------------------------
-- Collisionというnameのレイヤーを検索して返します.
--------------------------------------------------------------------------------
function M:findCollisionLayer()
    return self.tmxMap:findLayerByName("Collision")
end

function M:findObjectsByPosition(x, y)
    local objects = {}
    for i, objectLayer in ipairs(self.objectLayers) do
        for j, object in ipairs(objectLayer.objects) do
            if object:getMapX() >= x and object:getMapX() + object:getMapWidth() < x and 
               object:getMapY() >= y and object:getMapY() + object:getMapHeight() < y then
                table.insert(objects, object)
            end
        end
    end
    return objects
end

--------------------------------------------------------------------------------
-- カメラの位置をプレイヤーの座標まで移動します.
--------------------------------------------------------------------------------
function M:scrollCameraToFocusObject()
    if not self.cameraToFocusObjectEnabled then
        return
    end
    if not self.focusObject then
        return
    end
    
    local x, y = self.focusObject:getLoc()
    self:scrollCameraToCenter(x, y)
end

return M