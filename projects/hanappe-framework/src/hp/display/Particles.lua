--------------------------------------------------------------------------------
-- This is a class to draw the texture. <br>
-- Base Classes => DisplayObject, TextureDrawable, Resizable <br>
--------------------------------------------------------------------------------

local table             = require("hp/lang/table")
local class             = require("hp/lang/class")
local DisplayObject     = require("hp/display/DisplayObject")
local TextureDrawable   = require("hp/display/TextureDrawable")
local ResourceManager   = require("hp/manager/ResourceManager")

local M = class(DisplayObject, TextureDrawable)

M.MOAI_CLASS = MOAIParticleSystem

function M.fromPex(particleName)
    local filePath = ResourceManager:getFilePath(particleName)
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

--------------------------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)

    params = params or {}
    params = type(params) == "string" and {texture = params} or params
    
    local deck = MOAIGfxQuad2D.new()
    deck:setUVRect(0, 0, 1, 1)
    deck:setRect(-0.5, -0.5, 0.5, 0.5)
    
    self:setDeck(deck)
    self.deck = deck

    self:copyParams(params)
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