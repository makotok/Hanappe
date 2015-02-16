----------------------------------------------------------------------------------------------------
-- This is a class to manage the layout of the widget.
-- Please get an instance from the widget module.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Resources = require "flower.core.Resources"
local UIEvent = require "flower.widget.UIEvent"
local EventDispatcher = require "flower.core.EventDispatcher"

-- class
local IconMgr = class()

-- static variables
local INSTANCE = nil

---
-- Return the singlton instance.
function IconMgr.getInstance()
    if not INSTANCE then
        INSTANCE = IconMgr()
    end
    return INSTANCE
end

---
-- Constructor.
function IconMgr:init()
    assert(INSTANCE == nil)
    self._iconTextureInfos = {}
    self:addIconTexture("skins/icons.png", 24, 24)
end

function IconMgr:addIconTexture(textureName, tileWidth, tileHeight)
    local iconInfo = {}
    local texture = Resources.getTexture(textureName)
    local textureW, textureH = texture:getSize()
    iconInfo.texture = texture
    iconInfo.tileWidth = tileWidth
    iconInfo.tileHeight = tileHeight
    iconInfo.iconSize = math.floor(textureW / tileWidth) * math.floor(textureH / tileHeight)

    table.insertElement(self._iconTextureInfos, iconInfo)
end

function IconMgr:createIconImage(iconNo)
    local curIconNo = 0
    for i, iconInfo in ipairs(self._iconTextureInfos) do
        if iconNo <= curIconNo + iconInfo.iconSize then
            local image = SheetImage(iconInfo.texture)
            image:setTileSize(iconInfo.tileWidth, iconInfo.tileHeight)
            image:setIndex(iconNo - curIconNo)
            return image
        end
        curIconNo = curIconNo + iconInfo.iconSize
    end
end

return IconMgr