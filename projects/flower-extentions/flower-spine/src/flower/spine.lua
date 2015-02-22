----------------------------------------------------------------------------------------------------
-- Flower Extentions Library for spine.
--
-- Spine is 2d skeletal animation system by Esoteric Software
-- http://www.esotericsoftware.com
-- 
-- This flower extension is an unofficial Spine runtime for Moai SDK
-- 
-- @author Vavius
-- @release V1.0
----------------------------------------------------------------------------------------------------

local spine = {}

----------------------------------------------------------------------------------------------------
-- Classes
-- @section Classes
----------------------------------------------------------------------------------------------------

---
-- Bone Class.
-- @see flower.spine.Bone
spine.Bone = require "flower.spine.Bone"

---
-- Slot Class.
-- @see flower.spine.Slot
spine.Slot = require "flower.spine.Slot"

---
-- AtlasMgr Class.
-- @see flower.spine.AtlasMgr
spine.AtlasMgr = require "flower.spine.AtlasMgr"

---
-- Attachment Class.
-- @see flower.spine.Attachment
spine.Attachment = require "flower.spine.Attachment"

---
-- Skeleton Class.
-- @see flower.spine.Skeleton
spine.Skeleton = require "flower.spine.Skeleton"

---
-- Animation Class.
-- @see flower.spine.Animation
spine.Animation = require "flower.spine.Animation"

---
-- SpineEvent Class.
-- @see flower.spine.SpineEvent
spine.SpineEvent = require "flower.spine.SpineEvent"

---
-- SpineUtils Class.
-- @see flower.spine.SpineUtils
spine.SpineUtils = require "flower.spine.SpineUtils"

return spine