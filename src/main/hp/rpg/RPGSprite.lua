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
M.MOVE_SEC = 0.5

--
M.MOVE_NONE = "moveTypeNone"
M.MOVE_RANDOM = "moveTypeRandom"

local function moveMapCommon(self, moveX, moveY, moveAnim)
    if self:isMoving() then
        return false
    end
    self.moveAction = self:moveLoc(moveX, moveY, 0, M.MOVE_SEC, MOAIEaseType.LINEAR)
    
    if not self:isCurrentAnim(moveAnim) then
        self:playAnim(moveAnim)
    end
    
    self.moveAction:setListener(MOAIAction.EVENT_STOP,
        function()
            self.moveAction = nil
            self.moveComplete = true
        end)
    
    return true
end

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
    
    return obj
end

----------------------------------------------------------------
-- フレーム更新処理を行います.
----------------------------------------------------------------
function M:onEnterFrame()
    if self:isMoving() then
        return
    end
    if self.moveComplete then
        self.moveComplete = false
        self:onMoveComplete()
    end
    
    local moveTypeFunc = self[self.moveType]
    if moveTypeFunc then
        moveTypeFunc(self)
    end
end

----------------------------------------------------------------
-- 浮動小数点による座標のずれを調整します.
----------------------------------------------------------------
function M:adjustLoc()
    local x, y, z = self:getLoc()
    x, y  = math.floor(x + 0.5), math.floor(y + 0.5)
    self:setLoc(x, y, z)
end

function M:onMoveComplete()
    self:adjustLoc()
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
    return moveMapCommon(self, -self.mapTileWidth, 0, "walkLeft")
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapUp()
    return moveMapCommon(self, 0, -self.mapTileHeight, "walkUp")
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapRight()
    return moveMapCommon(self, self.mapTileWidth, 0, "walkRight")
end

----------------------------------------------------------------
-- マップ上の座標を移動します.
----------------------------------------------------------------
function M:moveMapDown()
    return moveMapCommon(self, 0, self.mapTileHeight, "walkDown")
end

----------------------------------------------------------------
-- マップ上の座標を移動しているか返します.
----------------------------------------------------------------
function M:isMoving()
    return self.moveAction ~= nil
end

return M