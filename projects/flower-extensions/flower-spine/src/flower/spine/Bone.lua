----------------------------------------------------------------------------------------------------
-- Skeleton bone. Inherited from MOAITransform
-- 
-- @author Vavius
-- @release V1.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Resources = require "flower.Resources"
local SpineUtils = require "flower.spine.SpineUtils"

-- class
local Bone = class()
Bone.__index = MOAITransform.getInterfaceTable()
Bone.__moai_class = MOAITransform

Bone.ROOT = 'root'

---
-- Constructor. 
-- @param boneData bone parameters table. Fields: (name, x, y, scaleX, scaleY, rotation, length, parent)
-- @param skeleton skeleton object
function Bone:init(boneData, skeleton)
    self._data = boneData
    self.skeleton = skeleton

    self:setParent(skeleton.bones[boneData.parent])
    self:setToBindPose()
end

---
-- Set transform to initial position and rotation
function Bone:setToBindPose()
    local boneData = self._data
    local skeleton = self.skeleton

    if boneData and skeleton then
        self:setLoc((boneData.x or 0) * skeleton.scaleX, (boneData.y or 0) * skeleton.scaleY, 0)
        self:setRot(0, 0, (boneData.rotation or 0) * skeleton.scaleZrot)
        self:setScl(boneData.scaleX or 1, boneData.scaleY or 1, 1)
    end
end

---
-- Attach this bone to new parent
-- @param parent parent bone object reference
function Bone:setParent(parent)
    self:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)
    if parent then
        self:setAttrLink(MOAITransform.INHERIT_TRANSFORM, parent, MOAITransform.TRANSFORM_TRAIT)
    end
end

return Bone