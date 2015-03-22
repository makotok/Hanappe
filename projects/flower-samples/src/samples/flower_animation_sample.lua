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
    layer = flower.Layer()
    layer:setScene(scene)
    
    sprite1 = flower.Image("cathead.png")
    sprite1:setLayer(layer)
    sprite1:setPos(0, 0)

    sprite2 = flower.Image("cathead.png")
    sprite2:setLayer(layer)
    sprite2:setPos(sprite1:getBottom(), 0)

    sprite3 = flower.SheetImage("actor.png", 3, 4)
    sprite3:setLayer(layer)
    sprite3:setIndex(2)
    sprite3:setLoc(flower.viewWidth / 2, flower.viewHeight / 2, 0)

    sprite4 = flower.SheetImage("actor.png", 3, 4)
    sprite4:setLayer(layer)
    sprite4:setIndex(2)
    sprite4:setLeft(sprite3:getRight() + sprite3:getWidth())
    sprite4:setTop(sprite3:getTop())

    anim1 = flower.Animation({sprite1, sprite2}, 1)
        :moveLoc(50, 50, 0)
        :moveRot(0, 0, 180)
        :moveScl(1, 1, 0)
        :wait(3)
        :sequence(
            flower.Animation(sprite1, 1):moveScl(-1, -1, 0):moveRot(0, 0, -180):moveLoc(-50, -50, 0),
            flower.Animation(sprite2, 1):moveScl(-1, -1, 0):moveRot(0, 0, -180):moveLoc(-50, -50, 0))
        :wait(3)
        :parallel(
            flower.Animation(sprite1, 1):setLeft(10):setTop(10),
            flower.Animation(sprite2, 1):setLeft(10):setTop(sprite1:getHeight() + 10))
            
    anim2 = flower.Animation():loop(5, 
        flower.Animation({sprite3, sprite4}, 1)
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
