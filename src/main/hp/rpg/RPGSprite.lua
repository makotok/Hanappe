local table = require("hp/lang/table")
local class = require("hp/lang/class")
local SpriteSheet = require("hp/display/SpriteSheet")

----------------------------------------------------------------
-- RPGMapView用のスプライトクラスです.<br>
-- @class table
-- @name RPGSprite
----------------------------------------------------------------
local M = class(SpriteSheet)

math.randomseed(os.time())

-- constraints
-- Sheet animations
M.SHEET_ANIMS = {
    {name = "walkDown", indexes = {2, 1, 2, 3, 2}, sec = 0.25},
    {name = "walkLeft", indexes = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "walkRight", indexes = {8, 7, 8, 9, 8}, sec = 0.25},
    {name = "walkUp", indexes = {11, 10, 11, 12, 11}, sec = 0.25},
}

-- move direction
M.DIR_LEFT = 1
M.DIR_UP = 2
M.DIR_RIGHT = 3
M.DIR_DOWN = 4

--
M.MOVE_SPEED = 2

--
M.MOVE_NONE = "moveTypeNone"
M.MOVE_RANDOM = "moveTypeRandom"

----------------------------------------------------------------
-- インスタンスを生成して返します.<br>
-- @return インスタンス
----------------------------------------------------------------
function M:new(params)
    local obj = SpriteSheet.new(self, params)
    obj:setSheetAnims(self.SHEET_ANIMS)
    
    obj.mapView = assert(params.mapView)
    obj.mapTileWidth = obj.mapView.tmxMap.tilewidth
    obj.mapTileHeight = obj.mapView.tmxMap.tileheight
    
    obj.moveSpeed = self.MOVE_SPEED
    
    obj.currentMoveX = 0
    obj.currentMoveY = 0
    obj.currentMoveCount = 0
    
    return obj
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
end

----------------------------------------------------------------
-- ランダム移動処理を行います.
----------------------------------------------------------------
function M:moveTypeRandom()
    local r = math.random(200)
    self:moveMap(r)
end

----------------------------------------------------------------
-- ステップ毎の移動処理を行います.
-- moveLocではいまいちなので、自前で移動する.
----------------------------------------------------------------
function M:moveStep()
    if self:isMoving() then
        self:addLoc(self.currentMoveX, self.currentMoveY, 0)
        self.currentMoveCount = self.currentMoveCount - 1
    end
end

----------------------------------------------------------------
-- マップ上の座標を移動する共通処理です.
----------------------------------------------------------------
function M:moveMapCommon(mapX, mapY, moveAnim)
    if self:isMoving() then
        return false
    end
    if not self.mapView:collisionWith(self, self:getMapX() + mapX, self:getMapY() + mapY) then
        self.currentMoveX = mapX * self.moveSpeed
        self.currentMoveY = mapY * self.moveSpeed
        self.currentMoveCount = self.mapTileWidth / self.moveSpeed
    end
    
    if not self:isCurrentAnim(moveAnim) then
        self:playAnim(moveAnim)
    end
        
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

return M