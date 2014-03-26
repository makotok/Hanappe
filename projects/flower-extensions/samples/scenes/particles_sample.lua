module(..., package.seeall)

local Particles = require "particles"

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setTouchEnabled(true)

    particle = Particles.fromPex("deathBlossomCharge.pex")
    particle:setLayer(layer)

    particle:addEventListener("touchDown", onTouchDown)
    particle:addEventListener("touchMove", onTouchMove)
    particle:addEventListener("touchUp", onTouchUp)
end

function onStart()
    particle.emitter:setLoc(100, 100)
    particle:start()
    particle:startParticle()
end

function onTouchDown(e)
    local wx, wy = layer:wndToWorld(e.x, e.y, 0)
    particle.emitter:setLoc(wx, wy)
    particle:startParticle()
end

function onTouchMove(e)
    local wx, wy = layer:wndToWorld(e.x, e.y, 0)
    particle.emitter:setLoc(wx, wy)
end

function onTouchUp(e)
    particle:stopParticle()
end
