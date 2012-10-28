module(..., package.seeall)

table = require "hp/lang/table"

--------------------------------------------------------------------------------
-- Const
--------------------------------------------------------------------------------

local PLAYER_ANIMS = {
    {name = "left", indexes = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "right", indexes = {8, 7, 8, 9, 8}, sec = 0.25},
}

local PLAYER_MOVE_VALUES = {
    left = -6,
    right = 6
}

local GAME_WIDTH = Application.viewWidth
local GAME_HEIGHT = Application.viewHeight

local KEY_LEFT = "a"
local KEY_RIGHT = "d"

local FLOOR_WIDTH = 80
local FLOOR_HEIGHT = 6
local FLOOR_MARGIN = 100

local FLOOR_NO_MAX = 3
local FLOOR_NO_RED = 1
local FLOOR_NO_NORMAL = 2
local FLOOR_NO_BOUND = 3

local SCORE_NEXT = 50
local SCORE_ADD_POINT = 0.05

local SCREEN_TOUCH_LEFT = 1
local SCREEN_TOUCH_RIGHT = 2

local UNITS_MATER = 0.06

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
-- floor
local floors = {}
local floorSpeed = -1

-- init random seed
math.randomseed(os.time())

--------------------------------------------------------------------------------
-- Create
--------------------------------------------------------------------------------

function onCreate(params)
    makePhysicsWorld()
    
    makeGameLayer()
    makePlayer()
    makeFloors()
    makeWalls()
    
    makeGuiView()
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onStart()
    physicsWorld:start()
end

function onEnterFrame()
    if isGameOver() then
        return
    end
    
    updatePlayer()
    updateFloors()
    updateScore()
    updateLevel()
end

function onTouchDown(e)
    updateTouchData(e.x, e.y)
end

function onTouchMove(e)
    updateTouchData(e.x, e.y)
end

function onTouchUp(e)
    screenTouchFlag = nil
end

function onPlayerCollision(e)
    local bodyA = e.fixtureA:getBody()
    local bodyB = e.fixtureB:getBody()
    
    if e.phase == "begin" then
        if bodyB.onCollision then
            bodyB:onCollision()
        end
    end
end

--------------------------------------------------------------------------------
-- Make Functions
--------------------------------------------------------------------------------
function makePhysicsWorld()
    physicsWorld = PhysicsWorld()
end

function makeGameLayer()
    gameLayer = Layer()
    gameLayer:setScene(scene)
    --gameLayer:setBox2DWorld(physicsWorld)
end

function makePlayer()
    player = SpriteSheet {
        texture = "actor.png",
        tiledSheets = {32, 32},
        sheetAnims = {PLAYER_ANIMS},
        layer = gameLayer,
    }
    
    player.body = physicsWorld:createBodyFromProp(player, nil, {xMin = -12, xMax = 12, friction = 0})
    player.body:setPos(gameLayer:getViewWidth() / 2, 32)
    player.body:setFixedRotation(true)
    player.body:addEventListener("collision", onPlayerCollision)
    player:playAnim("left")
end

function makeFloors()
    for i = 1, 10 do
        makeFloor(i)
    end 
end

function makeFloor(i)
    local makeFuncs = {}
    makeFuncs[FLOOR_NO_RED] = makeFloorForRed
    makeFuncs[FLOOR_NO_NORMAL] = makeFloorForNormal
    makeFuncs[FLOOR_NO_BOUND] = makeFloorForBound
    
    local f = math.random(FLOOR_NO_MAX)
    local x = math.random(GAME_WIDTH - FLOOR_WIDTH)
    local y = i * FLOOR_MARGIN
    local floor = makeFuncs[f](x, y, FLOOR_WIDTH, FLOOR_HEIGHT)
    floor.floorNo = f
    floor.floorIndex = i
    return floor
end

function makeFloorForRed(x, y, width, height)
    local floor = Mesh.newRect(0, 0, width, height, {"#990000", "#330000", 90})
    floor.body = physicsWorld:createBodyFromProp(floor, "static")
    floor.body:setPos(x, y)
    floor:setLayer(gameLayer)
    table.insert(floors, floor)
    
    function floor.body:onCollision()
        damageHitpoint()
    end
    
    return floor
end

function makeFloorForNormal(x, y, width, height)
    local floor = Mesh.newRect(0, 0, width, height, {"#CCCCCC", "#CCCCCC", 90})
    floor.body = physicsWorld:createBodyFromProp(floor, "static")
    floor.body:setPos(x, y)
    floor:setLayer(gameLayer)
    table.insert(floors, floor)
    return floor
end

function makeFloorForBound(x, y, width, height)
    local floor = Mesh.newRect(0, 0, width, height, {"#000099", "#000033", 90})
    floor.body = physicsWorld:createBodyFromProp(floor, "static")
    floor.body:setPos(x, y)
    floor:setLayer(gameLayer)
    table.insert(floors, floor)
    
    function floor.body:onCollision()
        recoverHitpoint()
    end
    
    return floor
end

function makeWalls()
    local vw, vh = gameLayer:getViewSize()
    local wallTop = physicsWorld:createRect(0, -1, vw, 1, {name = "wallTop", type = "static"})
    local wallLeft = physicsWorld:createRect(-1, 0, 1, vh, {type = "static"})
    local wallRight = physicsWorld:createRect(vw, 0, 1, vh, {type = "static"})
    
    function wallTop:onCollision()
        damageHitpoint(-10)
    end
end

function makeGuiView()
    guiView = Layer()
    guiView:setScene(scene)
    
    makeScoreLabel()
    makeLevelLabel()
    makeHitpointBar()
end

function makeScoreLabel()
    scoreLabel = TextLabel {
        text = "SCORE:0",
        size = {150, 30},
        pos = {5, 5},
        layer = guiView,
    }
    scoreLabel.scorePoint = 0

    function scoreLabel:setScore(i)
        self.scorePoint = i
        self:setText("SCORE:" .. math.floor(self.scorePoint))
    end
    function scoreLabel:addScore(i)
        self.scorePoint = self.scorePoint + i
        self:setText("SCORE:" .. math.floor(self.scorePoint))
    end
end

function makeLevelLabel()
    levelLabel = TextLabel {
        text = "LEVEL:1",
        size = {150, 30},
        pos = {5, scoreLabel:getBottom()},
        layer = guiView,
    }
    levelLabel.nextScorePoint = SCORE_NEXT
    levelLabel.level = 1
    
    function levelLabel:levelUp()
        self.level = self.level + 1
        levelLabel.nextScorePoint = levelLabel.nextScorePoint + SCORE_NEXT
        
        self:setText("LEVEL:" .. self.level)
        self:setScl(1.2, 1.2, 1)
        self:setColor(1, 0.5, 0.5, 1)
        
        self:seekScl(1, 1, 1, 1)
        self:seekColor(0, 0, 0, 1, 1)
        
        floorSpeed = floorSpeed - 0.5
    end
    
    function levelLabel:isLevelUp()
        return self.nextScorePoint <= scoreLabel.scorePoint
    end
end

function makeHitpointBar()
    hitpointBar = Group {
        pos = {5, levelLabel:getBottom()},
        size = {100, 30},
        layer = guiView,
    }
    
    local label = TextLabel {
        text = "HP:",
        size = {40, 30},
        parent = hitpointBar,
    }
    
    local bar = Mesh.newRect(40, 5, 60, 20, {"#009900", "#003300", 90})
    bar:setParent(hitpointBar)
    hitpointBar.bar = bar

    local border = Graphics {
        pos = {40, 5},
        size = {60, 20},
        parent = hitpointBar
    }
    border:setPenWidth(1):drawRect()
    
    function hitpointBar:getHitpoint()
        local x, y, z = self:getScl()
        return x
    end
    
end

function makeGameOverLabel()
    gameOverLabel = TextLabel {text = "Game Over!", textSize = 40, layer = guiView}
    gameOverLabel:setSize(guiView:getWidth(), 60)
    gameOverLabel:setAlignment(MOAITextBox.CENTER_JUSTIFY)
    gameOverLabel:setLeft((guiView:getViewWidth() - gameOverLabel:getWidth()) / 2)
    gameOverLabel:setTop((guiView:getViewHeight() - gameOverLabel:getHeight()) / 2)
end

--------------------------------------------------------------------------------
-- Update logic
--------------------------------------------------------------------------------

function updateTouchData(x, y)
    if x < Application.screenWidth / 2 then
        screenTouchFlag = SCREEN_TOUCH_LEFT
    else
        screenTouchFlag = SCREEN_TOUCH_RIGHT
    end
end

function updatePlayer()
    local direction = getPlayerDirection()
    local linerX, linerY = player.body:getLinearVelocity()
    linerX = PLAYER_MOVE_VALUES[direction] or 0
    linerX = linerX / UNITS_MATER
    
    player.body:setAwake(true)
    player.body:setLinearVelocity(linerX, linerY)
    
    if player:getSheetAnim(direction) and not player:isCurrentAnim(direction) then
        player:playAnim(direction)
    end
    if player.body:getY() > gameLayer:getViewHeight() + 32 then
        damageHitpoint(-2)
    end
end

function updateFloors()
    for i, floor in ipairs(floors) do
        floor.body:addPos(0, floorSpeed)
        if floor.onMove then
            floor:onMove()
        end
        if floor.body:getY() < -10 then
            recreateFloor(floor)
        end
    end
end

function updateScore()
    scoreLabel:addScore(SCORE_ADD_POINT)
end

function updateLevel()
    if levelLabel:isLevelUp() then
        levelLabel:levelUp()
    end 
end

function getPlayerDirection()
    if InputManager:isKeyDown(KEY_LEFT) or screenTouchFlag == SCREEN_TOUCH_LEFT then
        return "left"
    end
    if InputManager:isKeyDown(KEY_RIGHT) or screenTouchFlag == SCREEN_TOUCH_RIGHT then
        return "right"
    end
    return ""
end

--------------------------------------------------------------------------------
-- GameOver logic
--------------------------------------------------------------------------------

function isGameOver()
    local x = hitpointBar.bar:getScl()
    return x <= 0
end

function gameOver()
    if player.action then
        player.action:stop()
        player.action = nil
    end
    
    player:seekScl(3, 3, 1, 1)
    player:seekColor(0, 0, 0, 0, 1)
    
    gameLayer:seekColor(0, 0, 0, 0, 3)
    
    makeGameOverLabel()
    gameOverLabel:setScl(0, 0, 1)
    gameOverLabel:seekScl(1, 1, 1, 1)
    gameOverLabel:moveRot(0, 0, 360 * 2, 1)
    
    physicsWorld:stop()
end

--------------------------------------------------------------------------------
-- Common logic
--------------------------------------------------------------------------------

function damageHitpoint(point)
    point = point or -0.2
    local x, y, z = hitpointBar.bar:getScl()
    point = x + point <= 0 and -x or point
    if x <= 0 then
        return
    end
    if player.action then
        player.action:stop()
        player.action = nil
    end
    
    hitpointBar.bar:addScl(point, 0, 0)
    player:setColor(1, 0.5, 0.5, 1)
    player.action = player:seekColor(1, 1, 1, 1, 1)
    
    if isGameOver() then
        gameOver()
    end
end

function recoverHitpoint(point)
    point = point or 0.1
    local x, y, z = hitpointBar.bar:getScl()
    if x >= 1 then
        return
    end
    if player.action then
        player.action:stop()
        player.action = nil
    end
    
    hitpointBar.bar:addScl(point, 0, 0)
    player:setColor(0.5, 0.5, 1, 1)
    player.action = player:seekColor(1, 1, 1, 1, 1)
end

function recreateFloor(floor)
    floor.body:destroy()
    table.removeElement(floors, floor)
    local lastFloor = floors[#floors]
    floor = makeFloor(lastFloor.floorIndex + 1)
    floor.body:setY(lastFloor.body:getY() + FLOOR_MARGIN)
end
