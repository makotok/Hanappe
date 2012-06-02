local table = require("hp/lang/table")
local class = require("hp/lang/class")
local SpriteSheet = require("hp/display/SpriteSheet")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local RPGMoveFactory = require("hp/rpg/move/RPGMoveFactory")

----------------------------------------------------------------
-- RPGMapView用のスプライトクラスです.<br>
-- @class table
-- @name RPGSprite
----------------------------------------------------------------
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
M.DIR_LEFT = 1
M.DIR_UP = 2
M.DIR_RIGHT = 3
M.DIR_DOWN = 4

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
-- マップ上の座標を返します.
----------------------------------------------------------------
function M:getMapX()
    return math.floor(self:getLeft() / self.mapTileWidth) + 1
end

----------------------------------------------------------------
-- マップ上の座標を返します.
----------------------------------------------------------------
function M:getMapY()
    return math.floor(self:getTop() / self.mapTileHeight) + 1
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
function M:moveMapCommon(mapX, mapY, moveAnim)
    if self:isMoving() then
        return false
    end
    
    if not self:isCurrentAnim(moveAnim) then
        self:playAnim(moveAnim)
    end
        
    -- 衝突判定
    local nextMapX = self:getMapX() + mapX
    local nextMapY = self:getMapY() + mapY
    if self.mapView:collisionWith(self, nextMapX, nextMapY) then
        local e = Event(Event.MOVE_COLLISION)
        e.collisionMapX = nextMapX
        e.collisionMapY = nextMapY
        self:dispatchEvent(e)
        self:onMoveCollision()
        return false
    end
    
    -- 移動処理
    self.currentMoveX = mapX * self.moveSpeed
    self.currentMoveY = mapY * self.moveSpeed
    self.currentMoveCount = self.mapTileWidth / self.moveSpeed
    
    if self:hasEventListener(Event.MOVE_STARTED) then
        self:dispatchEvent(Event.MOVE_STARTED)
    end
    self:onMoveStarted()
        
    return true
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMap(dir)
    if dir == M.DIR_LEFT then
        return self:moveMapLeft()
    end
    if dir == M.DIR_UP then
        return self:moveMapUp()
    end
    if dir == M.DIR_RIGHT then
        return self:moveMapRight()
    end
    if dir == M.DIR_DOWN then
        return self:moveMapDown()
    end
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapLeft()
    return self:moveMapCommon(-1, 0, "walkLeft")
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapUp()
    return self:moveMapCommon(0, -1, "walkUp")
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapRight()
    return self:moveMapCommon(1, 0, "walkRight")
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapDown()
    return self:moveMapCommon(0, 1, "walkDown")
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