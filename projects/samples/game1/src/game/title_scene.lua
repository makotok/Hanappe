module(..., package.seeall)

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

local TITLE_NAME = "DEMO GAME1"

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------
function onCreate(params)
    view = View()
    view:setScene(scene)
    
    --titleImage = Sprite {texture = "game/assets/back1.png", layer = view, left = 0, top = 0}
    background = Mesh.newRect(0, 0, view:getWidth(), view:getHeight(), {"#CCCCCC", "#FFFFFF", 90})
    background:setColor(0.5, 0.5, 1, 1)
    view:addChild(background)
    
    titleLabel = TextLabel {
        text = TITLE_NAME, 
        size = {view:getWidth(), 50},
        pos = {0, 40},
        textSize = 40,
        alignment = {MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY},
        parent = view,
    }
    
    gameButton = Button {
        text = "GAME START",
        size = {200, 50},
        pos = {view:getWidth() / 2 - 200 / 2, view:getHeight() / 3 * 2},
        onClick = onGameButtonClick,
        parent = view,
    }
    
    scoreButton = Button {
        text = "SCORE",
        size = {200, 50},
        pos = {gameButton:getLeft(), gameButton:getBottom() + 20},
        parent = view,
    }
    
end

function onGameButtonClick()
    SceneManager:openNextScene("game/game_main_scene")
end

