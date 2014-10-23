--------------------------------------------------------------------------------
-- RPG用のMapViewクラスです.<br>
-- マップで表示するオブジェクトがRPGSpriteになります.
-- @class table
-- @name RPGMapView
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local TMXMapView = require("hp/tmx/TMXMapView")
local RPGSprite = require("hp/rpg/RPGSprite")

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
    self.eventLayer = self:findEventLayer()
    
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
function M:collisionWith(object, x, y, w, h)
    if self:collisionWithMap(x, y, w, h) then
        return true
    end
    if self:collisionWithObjects(object, x, y, w, h) then
        return true
    end
    return false
end
--------------------------------------------------------------------------------
-- 指定した位置と衝突判定レイヤーが衝突するか判定します.
--------------------------------------------------------------------------------
function M:collisionWithMap(x, y, w, h)
    if not self.collisionLayer then
        return false
    end
    
    w = w or 1
    h = h or 1
    
    for ty = 1, h do
        for tx = 1, w do
            local gid = self.collisionLayer:getGid(x, y)
            if gid and gid > 0 then
                return true
            end
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- 指定した位置とオブジェクトが衝突するか判定します.
--------------------------------------------------------------------------------
function M:collisionWithObjects(target, x, y, w, h)
    w = w or 1
    h = h or 1
    
    for i, objectLayer in ipairs(self.objectLayers) do
        for j, object in ipairs(objectLayer.objects) do
            if target ~= object and object:isCollisionByMapPosition(x, y, w, h) then
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

--------------------------------------------------------------------------------
-- Eventというnameのレイヤーを検索して返します.
--------------------------------------------------------------------------------
function M:findEventLayer()
    return self.tmxMap:findLayerByName("Event")
end

--------------------------------------------------------------------------------
-- 指定した座標のオブジェクトを検索して、最初に見つかったオブジェクトを返します.
--------------------------------------------------------------------------------
function M:findObjectByMapPosition(x, y, w, h)
    for i, objectLayer in ipairs(self.objectLayers) do
        for j, object in ipairs(objectLayer.objects) do
            if object:isCollisionByMapPosition(x, y) then
                return object
            end
        end
    end
end

--------------------------------------------------------------------------------
-- 指定した座標のオブジェクトを検索して返します.
--------------------------------------------------------------------------------
function M:findObjectsByMapPosition(x, y)
    local objects = {}
    for i, objectLayer in ipairs(self.objectLayers) do
        for j, object in ipairs(objectLayer.objects) do
            if object:isCollisionByMapPosition(x, y) then
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