--------------------------------------------------------------------------------
-- This is a class to draw the texture. <br>
-- Base Classes => DisplayObject, TextureDrawable, Resizable <br>
-- 
-- @auther Makoto
-- @class table
-- @name Particles
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local TextureDrawable = require("hp/display/TextureDrawable")

local M = class(DisplayObject, TextureDrawable)
M.MOAI_CLASS = MOAIParticleSystem

local function delegates(self)

end

function M.fromPex(particleName, resourceDirectory)
    resourceDirectory = resourceDirectory or ""
    local plugin =  MOAIParticlePexPlugin.load(resourceDirectory .. particleName)
    
    local self = M(resourceDirectory .. plugin:getTextureName())
    self:reserveParticles(plugin:getMaxParticles(), plugin:getSize())
    self:reserveSprites(plugin:getMaxParticles())
    self:reserveStates(1)
    self:setBlendMode(plugin:getBlendMode())

    local state = MOAIParticleState.new ()
    state:setTerm(plugin:getLifespan())
    state:setPlugin(plugin)
    
    local emitter = MOAIParticleTimedEmitter.new()
    emitter:setLoc(0, 0)
    emitter:setSystem(self)
    emitter:setEmission(plugin:getEmission())
    emitter:setFrequency(plugin:getFrequency())
    emitter:setRect(plugin:getRect())
    
    self.plugin = plugin
    self.emitter = emitter
    self.state = state
    
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

--------------------------------------------------------------------------------
-- Set the parameter setter function.
-- @param params Parameter is set to Object.
--      (params:texture, width, height)
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.texture and self.setTexture then
        self:setTexture(params.texture)
    end

    DisplayObject.copyParams(self, params)
end

return M