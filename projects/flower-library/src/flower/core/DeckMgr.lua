----------------------------------------------------------------------------------------------------
-- This is a singleton class that manages MOAIDeck.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Config = require "flower.core.Config"
local Resources = require "flower.core.Resources"

-- class
local DeckMgr = {}

-- Deck Caches
DeckMgr.imageDecks = setmetatable({}, {__mode = "v"})
DeckMgr.tileImageDecks = setmetatable({}, {__mode = "v"})
DeckMgr.atlasDecks = setmetatable({}, {__mode = "v"})
DeckMgr.nineImageDecks = {} -- setmetatable({}, {__mode = "v"})

---
-- Return the Deck to be used in the Image.
-- @param width width
-- @param height height
-- @param flipX (Optional)flipX
-- @param flipY (Optional)flipY
-- @return deck
function DeckMgr:getImageDeck(width, height, flipX, flipY)
    flipX = flipX and true or false
    flipY = flipY and true or false
    local key = width .. "$" .. height .. "$" .. tostring(flipX) .. "$" .. tostring(flipY)
    local cache = self.imageDecks

    if not cache[key] then
        cache[key] = self:createImageDeck(width, height, flipX, flipY)
    end
    return cache[key]
end

---
-- Create the Deck to be used in the Image.
-- @param width width
-- @param height height
-- @param flipX (Optional)flipX
-- @param flipY (Optional)flipY
-- @return deck
function DeckMgr:createImageDeck(width, height, flipX, flipY)
    if Config.VIEWPORT_YFLIP then
        flipY = not flipY
    end
    local u0 = flipX and 1 or 0
    local v0 = flipY and 1 or 0
    local u1 = flipX and 0 or 1
    local v1 = flipY and 0 or 1
    local deck = MOAIGfxQuad2D.new()
    deck:setUVRect(u0, v0, u1, v1)
    deck:setRect(0, 0, width, height)
    deck.flipX = flipX
    deck.flipY = flipY
    return deck
end

---
-- Return the Deck to be used in the SheetImage.
-- @param textureWidth texture width
-- @param textureHeight texture height
-- @param tileWidth tile width
-- @param tileHeight tile height
-- @param spacing spacing
-- @param margin margin
-- @param gridFlag grid flag
-- @param flipX (option)flipX
-- @param flipY (option)flipY
-- @return deck
function DeckMgr:getTileImageDeck(textureWidth, textureHeight, tileWidth, tileHeight, spacing, margin, gridFlag, flipX, flipY)
    flipX = flipX and true or false
    flipY = flipY and true or false

    local tw, th = textureWidth, textureHeight
    local key = tw .. "$" .. th .. "$" .. tileWidth .. "$" .. tileHeight .. "$" .. spacing .. "$" .. margin .. "$" .. tostring(gridFlag) .. "$" .. tostring(flipX) .. "$" .. tostring(flipY)
    local cache = self.tileImageDecks

    if not cache[key] then
        cache[key] = self:createTileImageDeck(tw, th, tileWidth, tileHeight, spacing, margin, gridFlag, flipX, flipY)
    end
    return cache[key]
end

---
-- Create the Deck to be used in the SheetImage.
-- @param textureWidth texture width
-- @param textureHeight texture height
-- @param tileWidth tile width
-- @param tileHeight tile height
-- @param spacing spacing
-- @param margin margin
-- @param gridFlag grid flag
-- @param flipX (option)flipX
-- @param flipY (option)flipY
-- @return deck
function DeckMgr:createTileImageDeck(textureWidth, textureHeight, tileWidth, tileHeight, spacing, margin, gridFlag, flipX, flipY)
    local tw, th = textureWidth, textureHeight
    local tileX = math.floor((tw - margin) / (tileWidth + spacing))
    local tileY = math.floor((th - margin) / (tileHeight + spacing))

    local deck = MOAIGfxQuadDeck2D.new()
    deck.type = "TileImageDeck"
    deck.sheetSize = tileX * tileY
    deck:reserve(deck.sheetSize)
    deck.textureWidth = textureWidth
    deck.textureHeight = textureHeight
    deck.tileWidth = tileWidth
    deck.tileHeight = tileHeight
    deck.spacing = spacing
    deck.margin = margin 
    deck.gridFlag = gridFlag
    deck.flipX = flipX
    deck.flipY = flipY

    local i = 1
    for y = 1, tileY do
        for x = 1, tileX do
            local sx = (x - 1) * (tileWidth + spacing) + margin
            local sy = (y - 1) * (tileHeight + spacing) + margin
            local ux0 = sx / tw
            local uy0 = sy / th
            local ux1 = (sx + tileWidth) / tw
            local uy1 = (sy + tileHeight) / th

            if not gridFlag then
                deck:setRect(i, 0, 0, tileWidth, tileHeight)
            end
            deck:setUVRect(i, flipX and ux1 or ux0, flipY and uy1 or uy0, flipX and ux0 or ux1, flipY and uy0 or uy1)
            i = i + 1
        end
    end

    return deck
end

---
-- Return the Deck for displaying TextureAtlas.
-- @param luaFilePath TexturePacker lua file path
-- @param flipX (option)flipX
-- @param flipY (option)flipY
-- @return Texture atlas deck
function DeckMgr:getAtlasDeck(luaFilePath, flipX, flipY)
    flipX = flipX and true or false
    flipY = flipY and true or false

    local key = luaFilePath .. "$" .. tostring(flipX) .. "$" .. tostring(flipY)
    local cache = self.atlasDecks

    if not cache[key] then
        cache[key] = self:createAtlasDeck(luaFilePath, flipX, flipY)
    end
    return cache[key]
end

---
-- Create the Deck for displaying TextureAtlas.
-- @param luaFilePath TexturePacker lua file path
-- @return Texture atlas deck
function DeckMgr:createAtlasDeck(luaFilePath, flipX, flipY)
    local frames = Resources.dofile(luaFilePath).frames
    local boundsDeck = MOAIBoundsDeck.new()
    boundsDeck:reserveBounds(#frames)
    boundsDeck:reserveIndices(#frames)

    local deck = MOAIGfxQuadDeck2D.new()
    deck:setBoundsDeck(boundsDeck)
    deck:reserve(#frames)
    deck.frames = frames
    deck.names = {}
    deck.flipX = flipX
    deck.flipY = flipY

    for i, frame in ipairs(frames) do
        local uvRect = frame.uvRect
        local uv = {uvRect.u0, uvRect.v1, uvRect.u1, uvRect.v1, uvRect.u1, uvRect.v0, uvRect.u0, uvRect.v0}
        local r = frame.spriteColorRect
        local b = frame.spriteSourceSize

        if frame.textureRotated then
            uv = {uv[7], uv[8], uv[1], uv[2], uv[3], uv[4], uv[5], uv[6]}
        end
        if flipX then
            uv = {uv[3], uv[4], uv[1], uv[2], uv[7], uv[8], uv[5], uv[6]}
        end
        if flipY then
            uv = {uv[7], uv[8], uv[5], uv[6], uv[3], uv[4], uv[1], uv[2]}
        end

        deck:setUVQuad(i, unpack(uv))
        deck.names[frame.name] = i
        deck:setRect(i, r.x, r.y, r.x + r.width, r.y + r.height)
        boundsDeck:setBounds(i, 0, 0, 0, b.width, b.height, 0)
        boundsDeck:setIndex(i, i)
    end

    return deck
end

---
-- Returns the Deck to draw NineImage.
-- For caching, you must not change the Deck.
-- @param fileName fileName
-- @return MOAIStretchPatch2D instance
function DeckMgr:getNineImageDeck(fileName)
    local filePath = Resources.getResourceFilePath(fileName)
    local cache = self.nineImageDecks

    if not cache[filePath] then
        cache[filePath] = self:createNineImageDeck(filePath)
    end
    return cache[filePath]
end

---
-- Create the Deck to draw NineImage.
-- @param fileName fileName
-- @return MOAIStretchPatch2D instance
function DeckMgr:createNineImageDeck(fileName)
    local filePath = Resources.getResourceFilePath(fileName)

    local image = MOAIImage.new()
    image:load(filePath)

    local imageWidth, imageHeight = image:getSize()
    local displayWidth, displayHeight = imageWidth - 2, imageHeight - 2
    local stretchRows = self:_createStretchRowsOrColumns(image, true)
    local stretchColumns = self:_createStretchRowsOrColumns(image, false)
    local contentPadding = self:_getNineImageContentPadding(image)
    local texture = Resources.getTexture(filePath)
    local uvRect
    if Config.VIEWPORT_YFLIP then
        uvRect = {1 / imageWidth, 1 / imageHeight, (imageWidth - 1) / imageWidth, (imageHeight - 1) / imageHeight}
    else
        uvRect = {1 / imageWidth, (imageHeight - 1) / imageHeight, (imageWidth - 1) / imageWidth, 1 / imageHeight}
    end

    local deck = MOAIStretchPatch2D.new()
    deck.imageWidth = imageWidth
    deck.imageHeight = imageHeight
    deck.displayWidth = displayWidth
    deck.displayHeight = displayHeight
    deck.contentPadding = contentPadding
    deck:reserveUVRects(1)
    deck:setTexture(texture)
    deck:setRect(0, 0, displayWidth, displayHeight)
    deck:setUVRect(1, unpack(uvRect))
    deck:reserveRows(#stretchRows)
    deck:reserveColumns(#stretchColumns)

    for i, row in ipairs(stretchRows) do
        deck:setRow(i, row.weight, row.stretch)
    end
    for i, column in ipairs(stretchColumns) do
        deck:setColumn(i, column.weight, column.stretch)
    end

    return deck
end

function DeckMgr:_createStretchRowsOrColumns(image, isRow)
    local stretchs = {}
    local imageWidth, imageHeight = image:getSize()
    local targetSize = isRow and imageHeight or imageWidth
    local stretchSize = 0
    local pr, pg, pb, pa = image:getRGBA(0, 1)

    for i = 1, targetSize - 2 do
        local r, g, b, a = image:getRGBA(isRow and 0 or i, isRow and i or 0)
        stretchSize = stretchSize + 1

        if pa ~= a then
            table.insert(stretchs, {weight = stretchSize / (targetSize - 2), stretch = pa > 0})
            pa, stretchSize = a, 0
        end
    end
    if stretchSize > 0 then
        table.insert(stretchs, {weight = stretchSize / (targetSize - 2), stretch = pa > 0})
    end

    return stretchs
end

function DeckMgr:_getNineImageContentPadding(image)
    local imageWidth, imageHeight = image:getSize()
    local paddingLeft = 0
    local paddingTop = 0
    local paddingRight = 0
    local paddingBottom = 0

    for x = 0, imageWidth - 2 do
        local r, g, b, a = image:getRGBA(x + 1, imageHeight - 1)
        if a > 0 then
            paddingLeft = x
            break
        end
    end
    for x = 0, imageWidth - 2 do
        local r, g, b, a = image:getRGBA(imageWidth - x - 2, imageHeight - 1)
        if a > 0 then
            paddingRight = x
            break
        end
    end
    for y = 0, imageHeight - 2 do
        local r, g, b, a = image:getRGBA(imageWidth - 1, y + 1)
        if a > 0 then
            paddingTop = y
            break
        end
    end
    for y = 0, imageHeight - 2 do
        local r, g, b, a = image:getRGBA(imageWidth - 1, imageHeight - y - 2)
        if a > 0 then
            paddingBottom = y
            break
        end
    end

    return {paddingLeft, paddingTop, paddingRight, paddingBottom}
end

return DeckMgr