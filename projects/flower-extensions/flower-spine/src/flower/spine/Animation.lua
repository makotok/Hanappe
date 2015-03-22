----------------------------------------------------------------------------------------------------
-- Animation object. Inherited from MOAIAnim
-- 
-- @author Vavius
-- @release V1.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local SpineUtils = require "flower.spine.SpineUtils"
local Slot = require "flower.spine.Slot"

-- class
local Animation = class()
Animation.__index = MOAIAnim.getInterfaceTable()
Animation.__moai_class = MOAIAnim

--
Animation.BEZIER_SUBDIVS = 10

-- Codes for MOAITimer events
Animation.EVENT_ATTACHMENT = 1
Animation.EVENT_CUSTOM = 2

---
-- The constructor
-- 
-- @param animationData animation table. Look spine json specs for format
-- @param skeleton skeleton object
function Animation:init(animationData, skeleton)
    self._data = animationData
    self.skeleton = skeleton

    self.scaleX = skeleton.scaleX
    self.scaleY = skeleton.scaleY
    self.scaleZrot = skeleton.scaleZrot

    local linksFactory = {}
    linksFactory['rotate']        = self.createRotateLinks
    linksFactory['translate']     = self.createTranslateLinks
    linksFactory['scale']         = self.createScaleLinks
    linksFactory['attachment']    = self.createAttachmentLinks
    linksFactory['color']         = self.createColorLinks

    self:reserveLinks(self:countLinks())
    self.nextLinkId = 1
    self.eventKeyframes = {}

    local bonesAnim = animationData['bones']
    if bonesAnim then
        for boneName, timelineData in pairs(bonesAnim) do
            for k, keys in pairs(timelineData) do
                linksFactory[k] (self, keys, skeleton.bones[boneName])
            end
        end
    end

    local slotsAnim = animationData['slots']
    if slotsAnim then
        for slotName, timelineData in pairs(slotsAnim) do
            for k, keys in pairs(timelineData) do
                linksFactory[k] (self, keys, skeleton.slots[slotName])
            end
        end
    end

    if animationData['events'] then
        self:createEventLinks(animationData['events'])
    end

    self:createEventCallbacks()
end

function Animation:countLinks()
    local totalLinks = 0
    
    local boneAnimations = self._data['bones']
    if boneAnimations then
        for boneName, timelineData in pairs(boneAnimations) do
            for k, v in pairs(timelineData) do
                if k == 'scale' then
                    totalLinks = totalLinks + 2
                elseif k == 'rotate' then
                    totalLinks = totalLinks + 1
                else
                    totalLinks = totalLinks + 1
                end
            end
        end
    end

    local slotAnimations = self._data["slots"]
    if slotAnimations then        
        for slotName, timelineData in pairs(slotAnimations) do
            for k, v in pairs(timelineData) do
                if k == 'color' then
                    totalLinks = totalLinks + 4
                end
            end
        end
    end

    return totalLinks
end

function Animation:countKeys(keysData)
    totalKeys = 0
    for i, key in ipairs(keysData) do
        if key.curve and type(key.curve) == 'table' then
            totalKeys = totalKeys + Animation.BEZIER_SUBDIVS
        else
            totalKeys = totalKeys + 1
        end
    end

    return totalKeys
end

function Animation:createBezierKeys(curve, bezierData, startIndex, startTime, endTime, startValues, endValues)
    local keys = SpineUtils.genBezierKeys(Animation.BEZIER_SUBDIVS + 1, bezierData[1], bezierData[2], bezierData[3], bezierData[4])
    local timeDiff = endTime - startTime

    local valuesDiff = {}
    for i, v in ipairs(startValues) do
        valuesDiff[i] = endValues[i] - startValues[i]
    end

    local args = { }

    for i = 1, #keys - 1 do 
        k = keys[i]
        args[1] = startIndex + i - 1
        args[2] = startTime + k[1] * timeDiff
        for j, v in ipairs(startValues) do
            args[2 + j] = v + k[2] * valuesDiff[j]
        end
        args[#startValues + 3] = MOAIEaseType.LINEAR
        curve:setKey(unpack(args))
    end
end

function Animation:createRotateLinks(keysData, target)
    local m_r = self.scaleZrot

    local curve = MOAIAnimCurve.new()
    curve:reserveKeys(self:countKeys(keysData))

    local angle = (target._data.rotation or 0) * m_r
    local lastAngle = angle
    local bezierIndexOffset = 0

    for i, key in ipairs(keysData) do
        local val = SpineUtils.wrapAngle(angle + key.angle * m_r - lastAngle)
        lastAngle = lastAngle + val
        
        local easeType = key.curve == "stepped" and MOAIEaseType.FLAT or MOAIEaseType.LINEAR
        
        if type(key.curve) == 'table' then
            local nextAngle = SpineUtils.wrapAngle(angle + keysData[i + 1].angle * m_r - lastAngle)
            nextAngle = nextAngle + lastAngle
            self:createBezierKeys(curve, key.curve, i + bezierIndexOffset, key.time, keysData[i + 1].time, {lastAngle}, {nextAngle})
            bezierIndexOffset = bezierIndexOffset + Animation.BEZIER_SUBDIVS - 1

        else
            curve:setKey(i + bezierIndexOffset, key.time, lastAngle, easeType)
        end
    end

    self:setLink(self.nextLinkId, curve, target, MOAITransform.ATTR_Z_ROT)
    self.nextLinkId = self.nextLinkId + 1
end

function Animation:createScaleLinks(keysData, target)
    local curveX = MOAIAnimCurve.new()
    local curveY = MOAIAnimCurve.new()

    local numKeys = self:countKeys(keysData)
    curveX:reserveKeys(numKeys)
    curveY:reserveKeys(numKeys)
    
    local scX, scY = target._data.scaleX or 1, target._data.scaleY or 1
    local bezierIndexOffset = 0

    for i, key in ipairs(keysData) do
        local easeType = key.curve == "stepped" and MOAIEaseType.FLAT or MOAIEaseType.LINEAR
        
        if type(key.curve) == 'table' then
            local nextValX = keysData[i + 1].x * scX
            local nextValY = keysData[i + 1].y * scY
            
            self:createBezierKeys(curveX, key.curve, i + bezierIndexOffset, key.time, keysData[i + 1].time, {scX * key.x}, {nextValX})
            self:createBezierKeys(curveY, key.curve, i + bezierIndexOffset, key.time, keysData[i + 1].time, {scY * key.y}, {nextValY})
            
            bezierIndexOffset = bezierIndexOffset + Animation.BEZIER_SUBDIVS - 1

        else
            curveX:setKey(i + bezierIndexOffset, key.time, scX * key.x, easeType)
            curveY:setKey(i + bezierIndexOffset, key.time, scY * key.y, easeType)
        end
    end

    self:setLink(self.nextLinkId, curveX, target, MOAITransform.ATTR_X_SCL)
    self:setLink(self.nextLinkId + 1, curveY, target, MOAITransform.ATTR_Y_SCL)
    self.nextLinkId = self.nextLinkId + 2
end

function Animation:createTranslateLinks(keysData, target)
    local m_x = self.scaleX
    local m_y = self.scaleY

    local curve = MOAIAnimCurveVec.new()
    curve:reserveKeys(self:countKeys(keysData))

    local x, y = (target._data.x or 0) * m_x, (target._data.y or 0) * m_y
    local bezierIndexOffset = 0

    for i, key in ipairs(keysData) do
        local easeType = key.curve == "stepped" and MOAIEaseType.FLAT or MOAIEaseType.LINEAR
        
        if type(key.curve) == 'table' then
            local curVal = {x + key.x * m_x, y + key.y * m_y, 0}
            local nextVal = {x + keysData[i + 1].x * m_x, y + keysData[i + 1].y * m_y, 0}
            self:createBezierKeys(curve, key.curve, i + bezierIndexOffset, key.time, keysData[i + 1].time, curVal, nextVal)
            bezierIndexOffset = bezierIndexOffset + Animation.BEZIER_SUBDIVS - 1

        else
            curve:setKey(i + bezierIndexOffset, key.time, x + key.x * m_x, y + key.y * m_y, 0, easeType)
        end
    end

    self:setLink(self.nextLinkId, curve, target, MOAITransform.ATTR_TRANSLATE)
    self.nextLinkId = self.nextLinkId + 1
end

function Animation:createColorLinks(keysData, target)
    assert((target.__class == Slot), "Animation: color animation can be applied only to slot objects")

    local curveR = MOAIAnimCurve.new()
    local curveG = MOAIAnimCurve.new()
    local curveB = MOAIAnimCurve.new()
    local curveA = MOAIAnimCurve.new()
    curveR:reserveKeys(self:countKeys(keysData))
    curveG:reserveKeys(self:countKeys(keysData))
    curveB:reserveKeys(self:countKeys(keysData))
    curveA:reserveKeys(self:countKeys(keysData))
    local bezierIndexOffset = 0

    for i, key in ipairs(keysData) do
        local r, g, b, a = SpineUtils.hexToRGBA(key.color)
        local easeType = key.curve == "stepped" and MOAIEaseType.FLAT or MOAIEaseType.LINEAR
        
        if type(key.curve) == 'table' then
            local r2, g2, b2, a2 = SpineUtils.hexToRGBA(keysData[i + 1].color)
            
            self:createBezierKeys(curveR, key.curve, i + bezierIndexOffset, key.time, keysData[i + 1].time, r, r2)
            self:createBezierKeys(curveG, key.curve, i + bezierIndexOffset, key.time, keysData[i + 1].time, g, g2)
            self:createBezierKeys(curveB, key.curve, i + bezierIndexOffset, key.time, keysData[i + 1].time, b, b2)
            self:createBezierKeys(curveA, key.curve, i + bezierIndexOffset, key.time, keysData[i + 1].time, a, a2)

            bezierIndexOffset = bezierIndexOffset + Animation.BEZIER_SUBDIVS - 1
        else
            curveR:setKey(i + bezierIndexOffset, key.time, r, easeType)
            curveG:setKey(i + bezierIndexOffset, key.time, g, easeType)
            curveB:setKey(i + bezierIndexOffset, key.time, b, easeType)
            curveA:setKey(i + bezierIndexOffset, key.time, a, easeType)
        end
    end

    self:setLink(self.nextLinkId,     curveR, target, MOAIColor.ATTR_R_COL)
    self:setLink(self.nextLinkId + 1, curveG, target, MOAIColor.ATTR_G_COL)
    self:setLink(self.nextLinkId + 2, curveB, target, MOAIColor.ATTR_B_COL)
    self:setLink(self.nextLinkId + 3, curveA, target, MOAIColor.ATTR_A_COL)
    
    self.nextLinkId = self.nextLinkId + 4
end

function Animation:createAttachmentLinks(keysData, target)
    assert((target.__class == Slot), "Animation: attachment animation can be applied only to slot objects")

    local eventKeysTable = self.eventKeyframes
    local comp = function(key1, key2)
        return key1.time < key2.time
    end

    for i, key in ipairs(keysData) do
        key._type = Animation.EVENT_ATTACHMENT
        key._target = target
        table.bininsert(eventKeysTable, key, comp)
    end
end

function Animation:createEventLinks(keysData)
    local eventKeyframes = self.eventKeyframes
    local comp = function(key1, key2)
        return key1.time < key2.time
    end

    for i, key in ipairs(keysData) do
        key._type = Animation.EVENT_CUSTOM
        table.bininsert(eventKeyframes, key, comp)
    end
end

function Animation:createEventCallbacks()
    local eventKeyframes = self.eventKeyframes
    local eventCurve = MOAIAnimCurve.new()

    eventCurve:reserveKeys(#eventKeyframes)
    
    for i, key in ipairs(eventKeyframes) do
        eventCurve:setKey(i, key.time, 0, MOAIEaseType.FLAT)
            eventKeyframes[i] = {
                eventType = key._type,
                name = key.name,
                target = key._target,
                int = key.int,
                float = key.float,
                string = key.string,
            }
    end

    self:setListener(MOAITimer.EVENT_TIMER_KEYFRAME, self.timerEventCallback)
    self:setCurve(eventCurve)
end

function Animation:timerEventCallback(keyframe, timesExecuted, time, value)
    local skeleton = self.skeleton
    local event = self.eventKeyframes[keyframe]

    if event.eventType == Animation.EVENT_ATTACHMENT then
        local target = event.target
        target:setAttachment( skeleton:getAttachment(event.name, target._data.name) )

    elseif event.eventType == Animation.EVENT_CUSTOM then
        local defaultEvent = skeleton.events[event.name]
        local eventData = {
            int = event.int or defaultEvent.int,
            float = event.float or defaultEvent.float,
            string = event.string or defaultEvent.string,
        }

        skeleton:dispatchEvent(defaultEvent, eventData)
    end
end


return Animation