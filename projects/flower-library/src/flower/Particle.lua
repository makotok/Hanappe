----------------------------------------------------------------------------------------------------
-- A class that displays the particle based on the PEX file.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.DisplayObject.html">DisplayObject</a><l/i>
--   <li><a href="http://moaiforge.github.io/moai-sdk/api/latest/class_m_o_a_i_particle_system.html">MOAIParticleSystem</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Resources = require "flower.Resources"
local DisplayObject = require "flower.DisplayObject"

-- class
local Particle = class(DisplayObject)
Particle.__index = MOAIParticleSystem.getInterfaceTable()
Particle.__moai_class = MOAIParticleSystem

---
-- Constructor.
-- @param particleName pex file path.
function Particle:init(particleName)
    Particle.__super.init(self)

    local filePath = Resources.getResourceFilePath(particleName)
    local plugin =  MOAIParticlePexPlugin.load(filePath)

    self:reserveParticles(plugin:getMaxParticles(), plugin:getSize())
    self:reserveSprites(plugin:getMaxParticles())
    self:reserveStates(1)
    self:setBlendMode(plugin:getBlendMode())
    self:setTexture(plugin:getTextureName())

    local state = MOAIParticleState.new()
    state:setTerm(plugin:getLifespan())
    state:setPlugin(plugin)

    local emitter = MOAIParticleTimedEmitter.new()
    emitter:setLoc(0, 0)
    emitter:setSystem(self)
    emitter:setEmission(plugin:getEmission())
    emitter:setFrequency(plugin:getFrequency())
    emitter:setRect(plugin:getRect())

    local timer = MOAITimer.new()
    timer:setSpan(plugin:getDuration())
    timer:setMode(MOAITimer.NORMAL)
    timer:setListener(MOAIAction.EVENT_STOP, function() self:stopEmitter() end)

    local deck = MOAIGfxQuad2D.new()
    deck = MOAIGfxQuad2D.new()
    deck:setUVRect(0, 0, 1, 1)
    deck:setRect(-0.5, -0.5, 0.5, 0.5)

    self.plugin = plugin
    self.emitter = emitter
    self.state = state
    self.timer = timer
    self.deck = deck

    self:setState(1, state)

    self:setDeck(deck)
    self:setPivToCenter()
end

---
-- Sets the texture.
-- @param texture Texture path, or texture
function Particle:setTexture(texture)
    self.texture = Resources.getTexture(texture)
    Particle.__index.setTexture(self, self.texture)
end

---
-- Start the emitter animation.
function Particle:startEmitter()
    self.emitter:start()
    if self.plugin:getDuration() > -1 then
        self.timer:start()
    end
end

---
-- Stop the emitter animation.
function Particle:stopEmitter()
    self.emitter:stop()
    if self.plugin:getDuration() > -1 then
        self.timer:stop()
    end
end

return Particle
