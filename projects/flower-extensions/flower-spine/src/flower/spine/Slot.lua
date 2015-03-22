---
-- @type Slot
-- 
-- DisplayObject that will be bound to bones. 


-- import
local json   = MOAIJsonParser
local class = require "flower.class"
local table = require "flower.table"
local DisplayObject = require "flower.DisplayObject"
local SpineUtils = require "flower.spine.SpineUtils"
local SpineEvent = require "flower.spine.SpineEvent"

-- class
local Slot = class(DisplayObject)

---
-- The constructor. 
-- @param slotData slot parameters table. Fields: (name, bone, color, attachment)
-- @param skeleton skeleton object
function Slot:init(slotData, skeleton)
    Slot.__super.init(self)
    self._data = slotData
    self.skeleton = skeleton

    local bone = skeleton.bones[slotData.bone]
    assert(bone, "Slot " .. slotData.name .. ": bone " .. slotData.bone .. " not found")

    self:setBone(bone)
    self:setToBindPose()
end

---
-- Attach slot to a bone
-- @param bone bone object
function Slot:setBone(bone)
    self:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)
    if bone then
        self:setAttrLink(MOAITransform.INHERIT_TRANSFORM, bone, MOAITransform.TRANSFORM_TRAIT)
    end
end

---
-- Set attachment for a slot
-- @param attachment attachment object
function Slot:setAttachment(attachment)
    if not attachment then
        self:setDeck()
        self:setIndex()
        self:setTexture()
        return
    end

    self:setDeck(attachment:getDeck())
    self:setIndex(attachment:getDeckIndex())
    self:setTexture(attachment:getTexture())

    self:setLoc(attachment:getLoc())
    self:setRot(attachment:getRot())
    self:setScl(attachment:getScl())

    local w, h = self:getSize()
    self:setPiv(w / 2, h / 2)
end

---
-- Reset slot data to initial values
function Slot:setToBindPose()
    local attachment = self._data.attachment
    local color = self._data.color or "ffffffff"

    if attachment then
        self:setAttachment(self.skeleton:getAttachment(attachment, self._data.name))
    end

    self:setColor(SpineUtils.hexToRGBA(color))
end

return Slot