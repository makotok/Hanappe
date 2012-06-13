module(..., package.seeall)

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

local GAME_WIDTH = 320
local GAME_HEIGHT = 480

local FLOOR_WIDTH = 80
local FLOOR_HEIGHT = 6
local FLOOR_MARGIN = 100

local FLOOR_NO_MAX = 3
local FLOOR_NO_RED = 1
local FLOOR_NO_NORMAL = 2
local FLOOR_NO_BOUND = 3

local SCREEN_TOUCH_LEFT = 1
local SCREEN_TOUCH_RIGHT = 2

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
    
    movePlayer()
    moveFloors()
    updateScore()
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
        if bodyB.prop and bodyB.prop.floorNo == FLOOR_NO_RED then
            damageHitpoint()
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
    player = SpriteSheet {texture = "samples/assets/actor.png", layer = gameLayer}
    player:setTiledSheets(32, 32)
    player:setSheetAnims(PLAYER_ANIMS)
    player.body = physicsWorld:createBodyFromProp(player, nil, {xMin = -12, xMax = 12, friction = 0})
    player.body:setPos(gameLayer:getViewWidth() / 2, 32)
    player.body:setFixedRotation(true)
    player.body:addEventListener("collision", onPlayerCollision)
    player:playAnim("left")
end

function makeFloors()
    -- TODO:Loop generation of floor
    local makeFuncs = {}
    makeFuncs[FLOOR_NO_RED] = makeFloorForRed
    makeFuncs[FLOOR_NO_NORMAL] = makeFloorForNormal
    makeFuncs[FLOOR_NO_BOUND] = makeFloorForBound
    
    for i = 1, 100 do
        local f = math.random(FLOOR_NO_MAX)
        local x = math.random(GAME_WIDTH - FLOOR_WIDTH)
        local y = i * FLOOR_MARGIN
        local floor = makeFuncs[f](x, y, FLOOR_WIDTH, FLOOR_HEIGHT)
        floor.floorNo = f
        floor.floorIndex = i
    end 
end

function makeFloorForRed(x, y, width, height)
    local floor = Mesh.newRect(0, 0, width, height, {"#990000", "#330000", 90})
    floor.body = physicsWorld:createBodyFromProp(floor, "static")
    floor.body:setPos(x, y)
    floor:setLayer(gameLayer)
    table.insert(floors, floor)    
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
    floor.body = physicsWorld:createBodyFromProp(floor, "static", {restitution = 1})
    floor.body:setPos(x, y)
    floor:setLayer(gameLayer)
    table.insert(floors, floor)
    return floor
end

function makeWalls()
    local vw, vh = gameLayer:getViewSize()
    physicsWorld:createRect(0, -1, vw, 1, {name = "wallTop", type = "static"})
    physicsWorld:createRect(-1, 0, 1, vh, {type = "static"})
    physicsWorld:createRect(vw, 0, 1, vh, {type = "static"})
end

function makeGuiView()
    guiView = View()
    guiView:setScene(scene)
    
    makeScoreLabel()
    makeLevelLabel()
    makeHitpointBar()
end

function makeScoreLabel()
    scoreLabel = TextLabel {text = "SCORE:0", layer = guiView}
    scoreLabel:setSize(150, 30)
    scoreLabel:setPos(5, 5)
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
    levelLabel = TextLabel {text = "LEVEL:0", layer = guiView}
    levelLabel:setSize(150, 30)
    levelLabel:setPos(5, scoreLabel:getBottom())
end

function makeHitpointBar()
    hitpointBar = Group({left = guiView:getViewWidth() - 105, top = 5, width = 100, height = 30})
    hitpointBar:addChild(TextLabel {text = "HP:", width = 40, height = 30})
    hitpointBar:addChild(Mesh.newRect(40, 0, 60, 30, {"#009900", "#003300", 90}))
    hitpointBar:addChild(Graphics({left = 40, top = 0, width = 60, height = 30}):setPenWidth(1):drawRect())
    hitpointBar:setLayer(guiView)
    hitpointBar.bar = hitpointBar.children[2]
end

function makeGameOverLabel()
    gameOverLabel = TextLabel {text = "Game Over!", textSize = 40, layer = guiView}
    gameOverLabel:setSize(guiView:getWidth(), 60)
    gameOverLabel:setAlignment(MOAITextBox.CENTER_JUSTIFY)
    gameOverLabel:setLeft((guiView:getViewWidth() - gameOverLabel:getWidth()) / 2)
    gameOverLabel:setTop((guiView:getViewHeight() - gameOverLabel:getHeight()) / 2)
end

--------------------------------------------------------------------------------
-- Game Logic
--------------------------------------------------------------------------------

function updateTouchData(x, y)
    if x < Application.screenWidth / 2 then
        screenTouchFlag = SCREEN_TOUCH_LEFT
    else
        screenTouchFlag = SCREEN_TOUCH_RIGHT
    end
end

function damageHitpoint()
    local x, y, z = hitpointBar.bar:getScl()
    if x <= 0 then
        return
    end
    
    hitpointBar.bar:addScl(-0.1, 0, 0)
    player:setColor(1, 0.5, 0.5, 1)
    player:seekColor(1, 1, 1, 1, 1)
    
    if isGameOver() then
        gameOver()
    end
end

function isGameOver()
    local x = hitpointBar.bar:getScl()
    return x <= 0
end

function gameOver()
    
    player:moveRot(0, 0, 360 * 3, 1)
    player:seekScl(0, 0, 0, 1)
    player:seekColor(0, 0, 0, 0, 1)
    
    makeGameOverLabel()
    gameOverLabel:setScl(0, 0, 1)
    gameOverLabel:seekScl(1, 1, 1, 1)
    
    physicsWorld:stop()
end

function movePlayer()
    local direction = getPlayerDirection()
    local linerX, linerY = player.body:getLinearVelocity()
    linerX = PLAYER_MOVE_VALUES[direction] or 0
    linerX = linerX / 0.06
    
    player.body:setAwake(true)
    player.body:setLinearVelocity(linerX, linerY)
    
    if player:getSheetAnim(direction) and not player:isCurrentAnim(direction) then
        player:playAnim(direction)
    end
end

function moveFloors()
    for i, floor in ipairs(floors) do
        floor.body:addPos(0, floorSpeed)
        if floor.onMove then
            floor:onMove()
        end
    end
end

function getPlayerDirection()
    if InputManager:isKeyDown("a") or screenTouchFlag == SCREEN_TOUCH_LEFT then
        return "left"
    end
    if InputManager:isKeyDown("d") or screenTouchFlag == SCREEN_TOUCH_RIGHT then
        return "right"
    end
    return ""
end

function updateScore()
    scoreLabel:addScore(0.05)
end
