module(..., package.seeall)

local completeHandler = function(self)
    print("animation complete!")
end    

function onCreate(params)
    layer = Layer:new({scene = scene})
    
    sprite1 = Sprite:new({texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 0})
    sprite2 = Sprite:new({texture = "samples/assets/cathead.png", layer = layer, left = 0, top = sprite1:getBottom()})

    sprite3 = SpriteSheet:new({texture = "samples/assets/actor.png", layer = layer})
    sprite3:setTiledSheets(32, 32, 3, 4)
    sprite3:setIndex(2)
    sprite3:setLoc(Application.viewWidth / 2, Application.viewHeight / 2, 0)

    sprite4 = SpriteSheet:new({texture = "samples/assets/actor.png", layer = layer})
    sprite4:setTiledSheets(32, 32, 3, 4)
    sprite4:setIndex(2)
    sprite4:setLeft(sprite3:getRight() + sprite3:getWidth())
    sprite4:setTop(sprite3:getTop())
    
    anim1 = Animation:new({sprite1, sprite2}, 1)
        :moveLoc(50, 50, 0)
        :moveRot(0, 0, 180)
        :moveScl(1, 1, 0)
        :wait(3)
        :sequence(
            Animation:new({sprite1}, 1):moveScl(-1, -1, 0):moveRot(0, 0, -180):moveLoc(-50, -50, 0),
            Animation:new({sprite2}, 1):moveScl(-1, -1, 0):moveRot(0, 0, -180):moveLoc(-50, -50, 0))
        :wait(3)
        :parallel(
            Animation:new({sprite1}, 1):setLeft(10):setTop(10),
            Animation:new({sprite2}, 1):setLeft(10):setTop(sprite1:getHeight() + 10))
            
    anim2 = Animation:new():loop(5, 
        Animation:new({sprite3, sprite4}, 1)
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
end

function onTouchDown()
    SceneManager:closeScene({animation = "fade"})
end