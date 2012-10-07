module(..., package.seeall)

local screenWidth, screenHeight = Application.screenWidth, Application.screenHeight

function onCreate(params)
    -- viewport
    local viewport = MOAIViewport.new()
    viewport:setSize(screenWidth, screenHeight)
    viewport:setScale(screenWidth, -screenHeight)
    viewport:setOffset(-1, 1)
    
    -- layer
    local layer = MOAILayer.new()
    layer:setViewport(viewport)
    -- You do not need to add to the Scene.
    --MOAIRenderMgr.pushRenderPass(layer)
    
    -- deck
    local deck = MOAIGfxQuad2D.new()
    deck:setUVRect(0, 0, 1, 1)
    deck:setRect(-64, -64, 64, 64)
    deck:setTexture("cathead.png")
    
    -- prop
    prop = MOAIProp.new()
    prop:setDeck(deck)
    prop:setLoc(100, 100, 0)
    layer:insertProp(prop)
    
    -- scene add child
    scene:addChild(layer)
end

function onStart()
    -- Animation can be performed to standard MOAIProp.
    Animation:new({prop}, 3):moveLoc(40, 40, 0):moveColor(-0.5, -0.5, -0.5, -0.5):play()
end
