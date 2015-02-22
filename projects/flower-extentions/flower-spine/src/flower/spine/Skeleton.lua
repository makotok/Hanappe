---
-- @type Skeleton
-- 
-- Skeleton object that can be created from Spine json files
-- It is basically a DisplayObject that acts like a container for inner slots
---

----------------------------------------------------------------------------------------------------

-- import
local json   = MOAIJsonParser
local class = require "flower.class"
local table = require "flower.table"
local DisplayObject = require "flower.DisplayObject"
local Resources = require "flower.Resources"
local Bone = require "flower.spine.Bone"
local Slot = require "flower.spine.Slot"
local Animation = require "flower.spine.Animation"
local Attachment = require "flower.spine.Attachment"
local SpineUtils = require "flower.spine.SpineUtils"
local SpineEvent = require "flower.spine.SpineEvent"

-- class
local Skeleton = class(DisplayObject)

Skeleton.DEFAULT_SKIN = 'default'

-----------------------------
-- Create skeleton from json file 
-- 
-- Flower by default have inverted Y axis (0 at top). Also, z rotation growth is clockwise. 
-- Spine uses the folowing coordinate conventions: Y is growing from bottom to top, 
-- rotation direction is counter-clockwise 
-- scaleX, scaleY and scaleZrot can be used for coordinate translation from spine to current project. 
-- 
-- @param path skeleton json path 
-- @param attachmentsPath (option) path to attachment images
-- @param scaleX (option) x scale of the skeleton. Can be used to scale skeleton for different resolutions
-- @param scaleY (option) x scale of the skeleton
-- @param scaleZrot (option) rotation scale
-----------------------------
function Skeleton:init(path, attachmentsPath, scaleX, scaleY, scaleZrot)
    Skeleton.__super.init(self)
    local filepath = Resources.getResourceFilePath(path)
    local jsonData = Resources.readFile(filepath)
    self._data = json.decode(jsonData)

    assert(self._data, "skeleton json could not be loaded: " .. path)

    self.scaleX = scaleX or 1
    self.scaleY = scaleY or -1
    self.scaleZrot = scaleZrot or -1
    self.attachmentsPath = attachmentsPath or SpineUtils.getPath(path)
    self.usesAtlas = attachmentsPath and (SpineUtils.getExtension(attachmentsPath) == ".atlas")

    self:_initBones()
    self:_initAttachments()
    self:_initSlots()
    self:_initAnimations()
    self:_initEvents()
end

---
-- Initialize bone objects from inner data
function Skeleton:_initBones()
    self.bones = {}

    local bonesTable = self._data.bones
    for i, boneData in ipairs(bonesTable) do
        local bone = Bone(boneData, self)
        self.bones[boneData.name] = bone
    end

    local rootBone = self.bones[Bone.ROOT]
    if rootBone then
        rootBone:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)
        rootBone:setAttrLink(MOAITransform.INHERIT_TRANSFORM, self, MOAITransform.TRANSFORM_TRAIT)
    end
end

---
-- Initialize slot objects from inner data
function Skeleton:_initSlots()
    self.slots = {}

    local slotsTable = self._data.slots
    if not slotsTable then
        return
    end

    for i, slotData in ipairs(slotsTable) do
        local slot = Slot(slotData, self)
        slot:setPriority(i)
        self.slots[slotData.name] = slot
        if self.layer then
            slot:setLayer(self.layer)
        end
    end
end

---
-- Initialize attachment objects from inner data
function Skeleton:_initAttachments()
    self.skins = {}
    self.currentSkin = Skeleton.DEFAULT_SKIN

    local skinsTable = self._data.skins
    if not skinsTable then
        return
    end
    
    for skinName, skinData in pairs(skinsTable) do
        self.skins[skinName] = {}
        for slotName, attachmentsTable in pairs(skinData) do 
            local slotAttachments = {}
            self.skins[skinName][slotName] = slotAttachments
            
            for attachmentName, attachmentData in pairs(attachmentsTable) do
                local attachment = Attachment(attachmentData, attachmentName, self)
                slotAttachments[attachmentName] = attachment
            end
        end
    end
end

---
-- Initialize animation objects from inner data
function Skeleton:_initAnimations()
    self.animations = {}

    local animationsTable = self._data.animations
    if not animationsTable then
        return
    end

    for animName, animData in pairs(animationsTable) do
        self.animations[animName] = Animation(animData, self)
    end
end

---
-- Initialize custom events from inner data
function Skeleton:_initEvents()
    self.events = {}

    local eventsTable = self._data.events
    if not eventsTable then
        return
    end
    
    for eventName, eventData in pairs(eventsTable) do
        self.events[eventName] = SpineEvent(eventName, eventData)
    end
end

---
-- Returns attachment object for slot
-- @param attachmentName name of the attachment
-- @param slotName name of the slot for that attachment
function Skeleton:getAttachment(attachmentName, slotName)
    if attachmentName == Attachment.NO_ATTACHMENT then
        return nil
    end

    local curSkin = self.skins[self.currentSkin]
    local curSkinAttachment = curSkin[slotName] and curSkin[slotName][attachmentName]
    local defaultAttachment = self.skins[Skeleton.DEFAULT_SKIN][slotName] and self.skins[Skeleton.DEFAULT_SKIN][slotName][attachmentName]

    return curSkinAttachment or defaultAttachment
end

---
-- Set layer for the skeleton
-- Inserts all child slots props to the given layer
-- @param layer layer
function Skeleton:setLayer(layer)
    if self.layer == layer then
        return
    end

    if self.layer then
        for slotName, slot in pairs(self.slots) do
            if slot.setLayer then
                slot:setLayer(nil)
            else
                self.layer:removeProp(slot)
            end
        end
    end

    self.layer = layer

    if self.layer then
        for slotName, slot in pairs(self.slots) do
            if slot.setLayer then
                slot:setLayer(self.layer)
            else
                self.layer:insertProp(slot)
            end
        end
    end
end

---
-- This event is called when scene is destroyed
function Skeleton:onSceneStop(e)

end

---
-- Set new skin to use
-- @param skinName skin name
function Skeleton:setSkin(skinName)
    local skin = self.skins[skinName]
    assert(skin, "Skin not found")
    self.currentSkin = skinName

    for slotName, slot in pairs(self.slots) do
        local attachment = self:getAttachment(slot._data.attachment, slotName)
        slot:setAttachment(attachment)
    end
end

---
-- Reset skeleton to initial pose
function Skeleton:setToBindPose()
    for k, bone in pairs(self.bones) do
        bone:setToBindPose()
    end

    for k, slot in pairs(self.slots) do
        slot:setToBindPose()
    end
end

---
-- Play animation
-- @param animationName animation name
-- @param loop (option) loop the animation. Default is false
-- @return animation object
function Skeleton:playAnim(animationName, loop)
    local anim = self.animations[animationName]

    if anim then
        anim:start()
        if loop then
            anim:setMode(MOAITimer.LOOP)
        else 
            anim:setMode(MOAITimer.NORMAL)
        end
    end

    return anim
end

---
-- Stop animation
-- @param animationName name of animation to stop or nil to stop all animations
function Skeleton:stopAnim(animationName)
    local anim = self.animations[animationName]
    if anim then
        anim:stop()
    else
        for name, anim in pairs(self.animations) do
            anim:stop()
        end
    end
end

return Skeleton