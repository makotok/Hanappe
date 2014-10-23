module(..., package.seeall)

local completeHandler = function(self)
    print("animation complete!")
end    

local function throttleAnimation()
    local timer = MOAITimer.new()
    timer:setSpan(2)
    timer:start()
    MOAICoroutine.blockOnAction(timer)
    anim2:setThrottle(4)
    -- timer:start()
    -- MOAICoroutine.blockOnAction(timer)
    -- anim2:stop()
end

function onCreate(params)
    layer = Layer {scene = scene}
    
    sprite1 = Sprite {texture = "cathead.png", layer = layer, left = 0, top = 0}
    sprite2 = Sprite {texture = "cathead.png", layer = layer, left = 0, top = sprite1:getBottom()}

    sprite3 = SpriteSheet {texture = "actor.png", layer = layer}
    sprite3:setTiledSheets(32, 32, 3, 4)
    sprite3:setIndex(2)
    sprite3:setLoc(Application.viewWidth / 2, Application.viewHeight / 2, 0)

    sprite4 = SpriteSheet {texture = "actor.png", layer = layer}
    sprite4:setTiledSheets(32, 32, 3, 4)
    sprite4:setIndex(2)
    sprite4:setLeft(sprite3:getRight() + sprite3:getWidth())
    sprite4:setTop(sprite3:getTop())

    anim1 = Animation({sprite1, sprite2}, 1)
        :moveLoc(50, 50, 0)
        :moveRot(0, 0, 180)
        :moveScl(1, 1, 0)
        :wait(3)
        :sequence(
            Animation(sprite1, 1):moveScl(-1, -1, 0):moveRot(0, 0, -180):moveLoc(-50, -50, 0),
            Animation(sprite2, 1):moveScl(-1, -1, 0):moveRot(0, 0, -180):moveLoc(-50, -50, 0))
        :wait(3)
        :parallel(
            Animation(sprite1, 1):setLeft(10):setTop(10),
            Animation(sprite2, 1):setLeft(10):setTop(sprite1:getHeight() + 10))
            
    anim2 = Animation():loop(5, 
        Animation({sprite3, sprite4}, 1)
            :moveIndex({2, 1, 2, 3, 2}, 0.25)
            :moveLoc(0, 32, 0)
            :moveIndex({5, 4, 5, 6, 5}, 0.25)
            :moveLoc(-32, 0, 0)
            :moveIndex({11, 10, 11, 12, 11}, 0.25)
            :moveLoc(0, -32, 0)
            :moveIndex({8, 7, 8, 9, 8}, 0.25)
            :moveLoc(32, 0, 0))
end

function onStart()
    anim1:play({onComplete = completeHandler})
    anim2:play()

    -- Change animation speed midway
    local thread = MOAICoroutine.new()
    thread:run(throttleAnimation)

end

function onTouchDown(e)
    -- if anim1:isRunning() then
    --     if anim1:isPaused() then
    --         print('resume')
    --         anim1:resume()
    --     else
    --         print('pause')
    --         anim1:pause()
    --     end
    -- end
    if anim2:isRunning() then
        if anim2:isPaused() then
            print('resume')
            anim2:resume()
        else
            print('pause')
            anim2:pause()
        end
    end
end
