module(..., package.seeall)

local Executors = require("hp/util/Executors")

--------------------------------------------------------------------------------
-- Const
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Create
--------------------------------------------------------------------------------

function onCreate(params)
    makeGuiView()
    makeGameOverLabel()
    makeRestartButton()
    makeExitButton()
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onStart()
end

function onDestroy()
    Executors.callLater(openNextScene)
end

function onEnterFrame()
end

function onRestartButtonClick(e)
    restartGameFlag = true
    SceneManager:closeScene({animation = "popOut"})
end

function onExitButtonClick(e)
    exitGameFlag = true
    SceneManager:closeScene({animation = "popOut"})
end

--------------------------------------------------------------------------------
-- Make Functions
--------------------------------------------------------------------------------

function makeGuiView()
    guiView = View()
    guiView:setScene(scene)    
end

function makeGameOverLabel()
    gameOverLabel = TextLabel {text = "GAME OVER!", textSize = 40}
    gameOverLabel:setSize(guiView:getWidth(), 60)
    gameOverLabel:setAlignment(MOAITextBox.CENTER_JUSTIFY)
    gameOverLabel:setLeft((guiView:getWidth() - gameOverLabel:getWidth()) / 2)
    gameOverLabel:setTop((guiView:getHeight() - gameOverLabel:getHeight()) / 2 - 40)
    guiView:addChild(gameOverLabel)
end

function makeRestartButton()
    restartButton = Button {text = "RESTART!", width = 200, height = 50}
    restartButton:setPos((guiView:getWidth() - restartButton:getWidth()) / 2, gameOverLabel:getBottom() + 10)
    restartButton:addEventListener("click", onRestartButtonClick)
    guiView:addChild(restartButton)
end

function makeExitButton()
    exitButton = Button {text = "EXIT", width = 200, height = 50}
    exitButton:setPos(restartButton:getLeft(), restartButton:getBottom() + 10)
    exitButton:addEventListener("click", onExitButtonClick)
    guiView:addChild(exitButton)
end

--------------------------------------------------------------------------------
-- Common logic
--------------------------------------------------------------------------------
function openNextScene()
    if restartGameFlag then
        SceneManager:closeScene({closingScene = "game/game_main_scene"})
        SceneManager:openScene("game/game_main_scene")
    end
    if exitGameFlag then
        SceneManager:openNextScene("game/title_scene", {animation = "crossFade"})
    end
end
