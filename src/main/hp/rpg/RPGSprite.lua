----------------------------------------------------------------
-- RPGMapView用のスプライトクラスです.<br>
-- @class table
-- @name RPGSprite
----------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local SpriteSheet = require("hp/display/SpriteSheet")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local RPGMoveFactory = require("hp/rpg/move/RPGMoveFactory")

local M = class(SpriteSheet)

-- constraints
-- Sheet animations
M.SHEET_ANIMS = {
    {name = "walkDown", indexes = {2, 1, 2, 3, 2}, sec = 0.25},
    {name = "walkLeft", indexes = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "walkRight", indexes = {8, 7, 8, 9, 8}, sec = 0.25},
    {name = "walkUp", indexes = {11, 10, 11, 12, 11}, sec = 0.25},
}

-- 移動方向
M.DIR_NONE = "none"
M.DIR_LEFT = "left"
M.DIR_UP = "up"
M.DIR_RIGHT = "right"
M.DIR_DOWN = "down"

-- 移動方向と移動先座標のオフセット値
M.DIR_NEXT = {
    [M.DIR_NONE] = {0, 0},
    [M.DIR_LEFT] = {-1, 0},
    [M.DIR_UP] = {0, -1},
    [M.DIR_RIGHT] = {1, 0},
    [M.DIR_DOWN] = {0, 1},
}

-- 移動方向とアニメーションの表
M.DIR_ANIMS = {
    [M.DIR_LEFT] = "walkLeft",
    [M.DIR_UP] = "walkUp",
    [M.DIR_RIGHT] = "walkRight",
    [M.DIR_DOWN] = "walkDown",
}

-- 移動速度
M.MOVE_SPEED = 2

-- 移動タイプ
M.MOVE_NONE = "noneMove"
M.MOVE_RANDOM = "randomMove"

----------------------------------------------------------------
-- インスタンスを生成して返します.<br>
-- @return インスタンス
----------------------------------------------------------------
function M:init(params)
    SpriteSheet.init(self, params)
    
    self:setSheetAnims(self.SHEET_ANIMS)
    
    self.mapView = assert(params.mapView)
    self.mapTileWidth = self.mapView.tmxMap.tilewidth
    self.mapTileHeight = self.mapView.tmxMap.tileheight
    
    self.moveLogicFactory = RPGMoveFactory
    self.moveSpeed = self.MOVE_SPEED
    
    self.currentDirection = M.DIR_NONE
    self.currentMoveX = 0
    self.currentMoveY = 0
    self.currentMoveCount = 0
end

----------------------------------------------------------------
-- フレーム更新処理を行います.
----------------------------------------------------------------
function M:onEnterFrame()
    -- 移動ロジックの処理
    local moveTypeFunc = self[self.moveType]
    if moveTypeFunc then
        moveTypeFunc(self)
    end
    
    -- 移動処理
    self:moveStep()
end

----------------------------------------------------------------
-- マップ座標で衝突するか判定します.
----------------------------------------------------------------
function M:isCollisionByMapPosition(targetX, targetY, targetW, targetH)
    targetW = targetW or 1
    targetH = targetH or 1
    local mapX, mapY = self:getMapLoc()
    local mapW, mapH = self:getMapSize()
    
    for y = targetY, targetY + targetH - 1 do
        for x = targetX, targetX + targetW - 1 do
            if mapX <= x and x < mapX + mapW and mapY <= y and y < mapY + mapH then
                return true
            end
        end
    end
    return false
end

----------------------------------------------------------------
-- マップ座標で衝突するか判定します.
----------------------------------------------------------------
function M:isCollisionByMapObject(obj)
    local mapX, mapY = obj:getMapLoc()
    local mapW, mapH = obj:getMapSize()
    return self:isCollisionByMapPosition(mapX, mapY, mapW, mapH)
end

----------------------------------------------------------------
-- 次に移動する予定のマップ上の座標を返します.
----------------------------------------------------------------
function M:getNextMapLoc()
    local mapX, mapY = self:getMapLoc()
    local offsetMap = M.DIR_NEXT[self.currentDirection] or M.DIR_NEXT[M.DIR_NONE]
    local offsetX, offsetY = offsetMap[1], offsetMap[2]
    return mapX + offsetX, mapY + offsetY
end

----------------------------------------------------------------
-- マップ上の座標を返します.
----------------------------------------------------------------
function M:getMapLoc()
    return self:getMapX(), self:getMapY()
end

----------------------------------------------------------------
-- マップ上の座標を設定します.
----------------------------------------------------------------
function M:setMapLoc(x, y)
    self:setMapX(x)
    self:setMapY(y)
end

----------------------------------------------------------------
-- マップ上の座標を返します.
----------------------------------------------------------------
function M:getMapX()
    return math.floor(self:getLeft() / self.mapTileWidth) + 1
end

----------------------------------------------------------------
-- マップ上の座標を設定します.
----------------------------------------------------------------
function M:setMapX(mapX)
    local x = (mapX - 1) * self.mapTileWidth
    self:setLeft(x)
end

----------------------------------------------------------------
-- マップ上の座標を返します.
----------------------------------------------------------------
function M:getMapY()
    return math.floor(self:getTop() / self.mapTileHeight) + 1
end

----------------------------------------------------------------
-- マップ上の座標を設定します.
----------------------------------------------------------------
function M:setMapY(mapY)
    local y = (mapY - 1) * self.mapTileHeight
    self:setTop(y)
end

----------------------------------------------------------------
-- マップ上の幅を返します.
----------------------------------------------------------------
function M:getMapSize()
    return self:getMapWidth(), self:getMapHeight()
end

----------------------------------------------------------------
-- マップ上の幅を返します.
----------------------------------------------------------------
function M:getMapWidth()
    return math.ceil(self:getWidth() / self.mapTileWidth)
end

----------------------------------------------------------------
-- マップ上の高さを返します.
----------------------------------------------------------------
function M:getMapHeight()
    return math.ceil(self:getHeight() / self.mapTileHeight)
end

----------------------------------------------------------------
-- 移動区分を設定します.
----------------------------------------------------------------
function M:setMoveType(moveType)
    self.moveType = moveType
    self.moveLogic = self.moveLogicFactory:createMove(self.moveType, {target = self})
end

----------------------------------------------------------------
-- 現在の向きを設定します.
-- ただし、移動中の場合は無視されます.
----------------------------------------------------------------
function M:setDirection(direction)
    if self:isMoving() then
        return
    end
    if self.currentDirection == direction then
        return
    end
    
    self.currentDirection = direction
    
    local animName = M.DIR_ANIMS[direction]
    if animName then
        self:playAnim(animName)
    end
end

----------------------------------------------------------------
-- ステップ毎の移動処理を行います.
-- moveLocではいまいちなので、自前で移動する.
----------------------------------------------------------------
function M:moveStep()
    if self.moveLogic then
        self.moveLogic:onStep()
    end

    if self:isMoving() then
        self:addLoc(self.currentMoveX, self.currentMoveY, 0)
        self.currentMoveCount = self.currentMoveCount - 1
        if self.currentMoveCount == 0 then
            if self:hasEventListener(Event.MOVE_FINISHED) then
                self:dispatchEvent(Event.MOVE_FINISHED)
            end
            self:onMoveFinished()
        end
    end
end


----------------------------------------------------------------
-- マップ上の座標を移動する共通処理です.
-- TODO:リファクタリング
----------------------------------------------------------------
function M:moveMapLoc(direction)
    if self:isMoving() then
        return false
    end
    if not M.DIR_NEXT[direction] then
        return false
    end
    
    -- 移動方向を設定
    self:setDirection(direction)
    
    -- 衝突判定
    local mapX, mapY = self:getMapLoc()
    local mapW, mapH = self:getMapSize()
    local nextMapX, nextMapY = self:getNextMapLoc()
    local moveX, moveY = nextMapX - mapX, nextMapY - mapY
    
    -- 移動しない場合
    if moveX == 0 and moveY == 0 then
        return
    end
    
    -- 移動先が衝突する場合
    if self.mapView:collisionWith(self, nextMapX, nextMapY, mapW, mapH) then
        local e = Event(Event.MOVE_COLLISION)
        e.collisionMapX = nextMapX
        e.collisionMapY = nextMapY
        self:dispatchEvent(e)
        self:onMoveCollision()
        return false
    end
    
    -- 移動処理
    self.currentMoveX = moveX * self.moveSpeed
    self.currentMoveY = moveY * self.moveSpeed
    self.currentMoveCount = self.mapTileWidth / self.moveSpeed
    
    if self:hasEventListener(Event.MOVE_STARTED) then
        self:dispatchEvent(Event.MOVE_STARTED)
    end
    self:onMoveStarted()
        
    return true
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
-- TODO:互換性の為に残しています.いずれ削除すべきです.
----------------------------------------------------------------
function M:moveMap(dir)
    return self:moveMapLoc(dir)
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapLeft()
    return self:moveMapLoc(M.DIR_LEFT)
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapUp()
    return self:moveMapLoc(M.DIR_UP)
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapRight()
    return self:moveMapLoc(M.DIR_RIGHT)
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapDown()
    return self:moveMapLoc(M.DIR_DOWN)
end

----------------------------------------------------------------
-- マップ上の座標を移動しているか返します.
----------------------------------------------------------------
function M:isMoving()
    return self.currentMoveCount > 0
end

----------------------------------------------------------------
-- 移動開始時に呼ばれます.
----------------------------------------------------------------
function M:onMoveStarted()

end

----------------------------------------------------------------
-- 移動完了時に呼ばれます.
----------------------------------------------------------------
function M:onMoveFinished()
    local eventLayer = self.mapView:findEventLayer()
    if not eventLayer then
        return
    end
    
    local gid = eventLayer:getGid(self:getMapX(), self:getMapY())
    if gid and gid > 0 and self:hasEventListener("moveOnTile") then
        local tileset = self.mapView.tmxMap:findTilesetByGid(gid)
        local e = Event("moveOnTile")
        e.gid = gid
        e.tileNo = tileset:getTileIndexByGid(gid)
        self:dispatchEvent(e)
    end
end

----------------------------------------------------------------
-- 移動で衝突した時に呼ばれます.
----------------------------------------------------------------
function M:onMoveCollision()

end

return M