----------------------------------------------------------------------------------------------------
-- A class to handle transitions between scenes and defining various animations for those transitions.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- class
local SceneAnimations = {}

--- Scene animation
function SceneAnimations.change(currentScene, nextScene, params)
    currentScene:setVisible(false)

    nextScene:setScl(1, 1, 1)
    nextScene:setColor(1, 1, 1, 1)
    nextScene:setPos(0, 0)
    nextScene:setVisible(true)
end

--- Scene animation
function SceneAnimations.overlay(currentScene, nextScene, params)
    nextScene:setScl(1, 1, 1)
    nextScene:setColor(1, 1, 1, 1)
    nextScene:setPos(0, 0)
    nextScene:setVisible(true)
end

--- Scene animation
function SceneAnimations.fade(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType

    nextScene:setVisible(true)
    nextScene:setColor(0, 0, 0, 0)

    MOAICoroutine.blockOnAction(currentScene:seekColor(0, 0, 0, 0, sec, easeType))
    MOAICoroutine.blockOnAction(nextScene:seekColor(1, 1, 1, 1, sec, easeType))

    currentScene:setVisible(false)
    currentScene:setColor(1, 1, 1, 1)
end

--- Scene animation
function SceneAnimations.crossFade(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType

    nextScene:setVisible(true)
    nextScene:setColor(0, 0, 0, 0)

    local action1 = currentScene:seekColor(0, 0, 0, 0, sec, easeType)
    local action2 = nextScene:seekColor(1, 1, 1, 1, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    currentScene:setColor(1, 1, 1, 1)
end

--- Scene animation
function SceneAnimations.popIn(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType

    nextScene:setVisible(true)
    nextScene:setScl(0.5, 0.5, 0.5)
    nextScene:setColor(0, 0, 0, 0)

    local action1 = nextScene:seekColor(1, 1, 1, 1, sec, easeType)
    local action2 = nextScene:seekScl(1, 1, 1, sec, easeType)
    MOAICoroutine.blockOnAction(action1)
end

--- Scene animation
function SceneAnimations.popOut(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType

    local action1 = currentScene:seekColor(0, 0, 0, 0, sec, easeType)
    local action2 = currentScene:seekScl(0.5, 0.5, 0.5, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    currentScene:setColor(1, 1, 1, 1)
    currentScene:setScl(1, 1, 1)
end

--- Scene animation
function SceneAnimations.slideLeft(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType
    local sw, sh = currentScene:getSize()

    nextScene:setVisible(true)
    nextScene:setPos(sw, 0)

    local action1 = currentScene:moveLoc(-sw, 0, 0, sec, easeType)
    local action2 = nextScene:moveLoc(-sw, 0, 0, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    currentScene:setPos(0, 0)
    nextScene:setPos(0, 0)
end

--- Scene animation
function SceneAnimations.slideRight(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType
    local sw, sh = currentScene:getSize()

    nextScene:setVisible(true)
    nextScene:setPos(-sw, 0)

    local action1 = currentScene:moveLoc(sw, 0, 0, sec, easeType)
    local action2 = nextScene:moveLoc(sw, 0, 0, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    currentScene:setPos(0, 0)
    nextScene:setPos(0, 0)
end

--- Scene animation
function SceneAnimations.slideTop(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType
    local sw, sh = currentScene:getSize()

    nextScene:setVisible(true)
    nextScene:setPos(0, sh)

    local action1 = currentScene:moveLoc(0, -sh, 0, sec, easeType)
    local action2 = nextScene:moveLoc(0, -sh, 0, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    currentScene:setPos(0, 0)
    nextScene:setPos(0, 0)
end

--- Scene animation
function SceneAnimations.slideBottom(currentScene, nextScene, params)
    local sec = params.second or 0.5
    local easeType = params.easeType
    local sw, sh = currentScene:getSize()

    nextScene:setVisible(true)
    nextScene:setPos(0, -sh)

    local action1 = currentScene:moveLoc(0, sh, 0, sec, easeType)
    local action2 = nextScene:moveLoc(0, sh, 0, sec, easeType)
    MOAICoroutine.blockOnAction(action1)

    currentScene:setVisible(false)
    currentScene:setPos(0, 0)
    nextScene:setPos(0, 0)
end

return SceneAnimations