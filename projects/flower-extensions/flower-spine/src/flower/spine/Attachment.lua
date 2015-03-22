----------------------------------------------------------------------------------------------------
-- Attachment is a visual representation of the slot. 
-- It contains information about deck, deckIndex, texture and own transform. 
-- This transform is used to offset attachment from the bone. 
-- 
-- @author Vavius
-- @release V1.0
----------------------------------------------------------------------------------------------------

-- import
local json   = MOAIJsonParser
local class = require "flower.class"
local table = require "flower.table"
local Resources = require "flower.Resources"
local DeckMgr = require "flower.DeckMgr"
local AtlasMgr = require "flower.spine.AtlasMgr"
local SpineUtils = require "flower.spine.SpineUtils"

-- class
local Attachment = class()

Attachment.NO_ATTACHMENT = json.JSON_NULL

---
-- The constructor.
-- @param attachmentData attachments parameters table. 
-- Fields: (x, y, rotation, width, height, name) 
-- @param attachmentName name of the attachment
-- @param skeleton skeleton object
function Attachment:init(attachmentData, attachmentName, skeleton)
    self._data = attachmentData
    self.skeleton = skeleton
    self.name = attachmentName

    self:initRegionAttachment()
end

function Attachment:initRegionAttachment()
    local skeleton = self.skeleton
    local attachmentData = self._data
    local actualName = attachmentData.name or self.name
    local scaleX, scaleY = math.abs(skeleton.scaleX), math.abs(skeleton.scaleY)

    local index = 1
    local deck = DeckMgr:getImageDeck(scaleX * attachmentData.width, scaleY * attachmentData.height)

    if skeleton.usesAtlas then
        deck, index = AtlasMgr:getAttachmentDeckAndIndex(actualName, skeleton.attachmentsPath, scaleX)
        self:setTexture(nil)
    else
        self:setTexture(Resources.getTexture(self.skeleton.attachmentsPath .. actualName .. ".png"))
    end

    self:setDeck(deck)
    self:setDeckIndex(index)
end

function Attachment:setDeck(deck)
    self.deck = deck
end

function Attachment:setDeckIndex(index)
    self.deckIndex = index
end

function Attachment:setTexture(texture)
    self.texture = texture
end

function Attachment:getDeck()
    return self.deck
end

function Attachment:getDeckIndex()
    return self.deckIndex
end

function Attachment:getTexture()
    return self.texture
end

function Attachment:getRot()
    return 0, 0, (self._data.rotation or 0) * self.skeleton.scaleZrot
end

function Attachment:getLoc()
    return (self._data.x or 0) * self.skeleton.scaleX, (self._data.y or 0) * self.skeleton.scaleY, 0
end

function Attachment:getScl()
    return self._data.scaleX or 1, self._data.scaleY or 1, 1
end

return Attachment