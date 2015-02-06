----------------------------------------------------------------------------------------------------
-- @type MovieClip
--
-- Class for animated texture atlases ('MovieClip' is the Adobe Flash terminology)
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local Resources = require "flower.core.Resources"
local SheetImage = require "flower.core.SheetImage"

-- class
local MovieClip = class(SheetImage)

---
-- Constructor.
-- @param texture Texture path, or texture
-- @param sizeX (option) The size of the sheet
-- @param sizeY (option) The size of the sheet
-- @param spacing (option)Spacing of the tiles
-- @param margin (option)Margin of the sheet
-- @param flipX (option)flipX
-- @param flipY (option)flipY
function MovieClip:init(texture, sizeX, sizeY, spacing, margin, flipX, flipY)
    MovieClip.__super.init(self, texture, sizeX, sizeY, spacing, margin, flipX, flipY)
    self.animTable = {}
    self.currentAnim = nil
end

---
-- Sets the custom animation.
-- @param name Name of anim
-- @param anim Anim object
function MovieClip:setAnim(name, anim)
    self.animTable[name] = anim
end

---
-- Sets the animation data.
-- The frame is interpolated from the data.
-- @param name Name of anim
-- @param data Animation data
function MovieClip:setAnimData(name, data)
    local curve = MOAIAnimCurve.new()
    local anim = MOAIAnim.new()

    local frames = data.frames
    local size = #frames
    curve:reserveKeys(size)
    for i = 1, size do
        curve:setKey(i, (i - 1) * data.sec, frames[i], MOAIEaseType.FLAT )
    end

    local mode = data.mode or MOAITimer.LOOP
    anim:reserveLinks(1)
    anim:setMode(mode)
    anim:setLink(1, curve, self, MOAIProp.ATTR_INDEX )
    anim:setCurve(curve)

    self.animTable[name] = anim
end

---
-- Sets multiple animation data up at the same time (convenience function).
-- @param datas Multiple data
function MovieClip:setAnimDatas(datas)
    for i, data in ipairs(datas) do
        local name = data.name or i
        self:setAnimData(name, data)
    end
end

---
-- Start the animation.
-- @param name Name of anim
function MovieClip:playAnim(name)
    local currentAnim = self.currentAnim
    local animTable = self.animTable

    if currentAnim and currentAnim:isBusy() then
        currentAnim:stop()
    end
    if name and animTable[name] then
        currentAnim = animTable[name]
        self.currentAnim = currentAnim
    end
    if currentAnim then
        currentAnim:start()
    end
end

---
-- Stop the animation.
function MovieClip:stopAnim()
    if self.currentAnim then
        self.currentAnim:stop()
    end
end

---
-- Check the current animation with the specified name.
-- @param name Animation name.
-- @return If the current animation is true.
function MovieClip:isCurrentAnim(name)
    return self.currentAnim == self.animTable[name]
end

---
-- Returns whether the running.
-- @return True if busy
function MovieClip:isBusy()
    return self.currentAnim and self.currentAnim:isBusy() or false
end

return MovieClip