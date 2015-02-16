module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setTouchEnabled(true)

    particle = flower.Particle("deathBlossomCharge.pex")
    particle:setLayer(layer)

    particle:addEventListener("touchDown", onTouchDown)
    particle:addEventListener("touchMove", onTouchMove)
    particle:addEventListener("touchUp", onTouchUp)
end

function onStart()
    particle.emitter:setLoc(100, 100)
    particle:start()
    particle:startEmitter()
end

function onTouchDown(e)
    particle.emitter:setLoc(e.wx, e.wy)
    particle:startEmitter()
end

function onTouchMove(e)
    particle.emitter:setLoc(e.wx, e.wy)
end

function onTouchUp(e)
    particle:stopEmitter()
end
