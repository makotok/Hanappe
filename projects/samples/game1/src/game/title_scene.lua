module(..., package.seeall)

--------------------------------------------------------------------------------
-- Constraints
--------------------------------------------------------------------------------

local TITLE_NAME = "たいとる"

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------
function onCreate(params)
    view = View()
    view:setScene(scene)
    
    --titleImage = Sprite {texture = "game/assets/back1.png", layer = view, left = 0, top = 0}
    background = Mesh.newRect(0, 0, view:getViewWidth(), view:getViewHeight(), {"#CCCCCC", "#FFFFFF", 90})
    background:setColor(0.5, 0.5, 1, 1)
    background:setLayer(view)
    
    titleLabel = TextLabel {text = TITLE_NAME, layer = view, width = view:getWidth(), height = 50}
    titleLabel:setPos(0, 40)
    titleLabel:setTextSize(40)
    titleLabel:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
    
    gameButton = Button()
    gameButton:setSize(200, 50)
    gameButton:setText("GAME START")
    gameButton:setLeft(view:getViewWidth() / 2 - gameButton:getWidth() / 2)
    gameButton:setTop(view:getViewHeight() / 2 + 30)
    gameButton:addEventListener("click", onGameButtonClick)
    view:addChild(gameButton)
    
end

function onGameButtonClick()
    SceneManager:openNextScene("game/game_main_scene")
end

