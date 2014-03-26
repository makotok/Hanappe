----------------------------------------------------------------------------------------------------
-- Particle System.
--
-- @author TangZero
-- @release
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower            = require "flower"
local class             = flower.class
local Resources         = flower.Resources
local DeckMgr           = flower.DeckMgr
local Image             = flower.Image

-- interfaces
local MOAIParticleSystemInterface = MOAIParticleSystem.getInterfaceTable()

-- class
local M = class(Image)
M.__index = MOAIParticleSystemInterface
M.__moai_class = MOAIParticleSystem


function M.fromPex(particleName)
    local filePath = Resources.getResourceFilePath(particleName)
    local plugin =  MOAIParticlePexPlugin.load(filePath)

    local self = M(plugin:getTextureName())
    self:reserveParticles(plugin:getMaxParticles(), plugin:getSize())
    self:reserveSprites(plugin:getMaxParticles())
    self:reserveStates(1)
    self:setBlendMode(plugin:getBlendMode())

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
    timer:setListener(MOAIAction.EVENT_STOP, function() self:stopParticle() end)

    self.plugin = plugin
    self.emitter = emitter
    self.state = state
    self.timer = timer

    self:setState(1, state)

    return self
end

function M:setSize(width, height)
    local deck = DeckMgr:getImageDeck(width, height)
    deck:setRect(-0.5, -0.5, 0.5, 0.5) -- HACK: Currently for scaling we need to set the deck's rect to 1x1
    self:setDeck(deck)
    self:setPivToCenter()
end

function M:startParticle()
    self.emitter:start()
    if self.plugin:getDuration() > -1 then
        self.timer:start()
    end
end

function M:stopParticle()
    self.emitter:stop()
    if self.plugin:getDuration() > -1 then
        self.timer:stop()
    end
end

return M
