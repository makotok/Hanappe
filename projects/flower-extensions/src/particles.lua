----------------------------------------------------------------------------------------------------
-- Particle System.
--
-- @author TangZero
-- @release V2.1.5
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local Resources = flower.Resources
local DisplayObject = flower.DisplayObject

-- interfaces
local MOAIPropInterface = MOAIProp.getInterfaceTable()
local MOAIParticleSystemInterface = MOAIParticleSystem.getInterfaceTable()

-- classes
local PEXParticle

----------------------------------------------------------------------------------------------------
-- @type PEXParticle
--
-- A class that displays the particle based on the PEX file.
----------------------------------------------------------------------------------------------------
PEXParticle = class(DisplayObject)
PEXParticle.__index = MOAIParticleSystemInterface
PEXParticle.__moai_class = MOAIParticleSystem
M.PEXParticle = PEXParticle

---
-- Constructor.
-- @param particleName pex file path.
function PEXParticle:init(particleName)
    PEXParticle.__super.init(self)

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
function PEXParticle:setTexture(texture)
    self.texture = Resources.getTexture(texture)
    MOAIParticleSystemInterface.setTexture(self, self.texture)
end

---
-- Start the emitter animation.
function PEXParticle:startEmitter()
    self.emitter:start()
    if self.plugin:getDuration() > -1 then
        self.timer:start()
    end
end

---
-- Stop the emitter animation.
function PEXParticle:stopEmitter()
    self.emitter:stop()
    if self.plugin:getDuration() > -1 then
        self.timer:stop()
    end
end

return M
