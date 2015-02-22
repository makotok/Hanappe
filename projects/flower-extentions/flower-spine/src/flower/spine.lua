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

-- Classes
spine.Bone = require "flower.spine.Bone"
spine.Slot = require "flower.spine.Slot"
spine.AtlasMgr = require "flower.spine.AtlasMgr"
spine.Attachment = require "flower.spine.Attachment"
spine.Skeleton = require "flower.spine.Skeleton"
spine.Animation = require "flower.spine.Animation"
spine.SpineEvent = require "flower.spine.SpineEvent"
spine.SpineUtils = require "flower.spine.SpineUtils"

return spine