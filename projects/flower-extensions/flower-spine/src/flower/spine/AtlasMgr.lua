----------------------------------------------------------------------------------------------------
-- Read Spine atlas files
-- 
-- @author Vavius
-- @release V1.0
----------------------------------------------------------------------------------------------------

-- imports
local class = require "flower.class"
local table = require "flower.table"
local Resources = require "flower.Resources"
local DeckMgr = require "flower.DeckMgr"
local SpineUtils = require "flower.spine.SpineUtils"
local Slot = require "flower.spine.Slot"

-- class
local AtlasMgr = class()
AtlasMgr.atlasCache = {}

AtlasMgr.FILTERS = {
    Nearest = MOAITexture.GL_NEAREST,
    Linear  = MOAITexture.GL_LINEAR,
    MipMapNearestNearest = MOAITexture.GL_NEAREST_MIPMAP_NEAREST, 
    MipMapLinearNearest  = MOAITexture.GL_LINEAR_MIPMAP_NEAREST,
    MipMapNearestLinear  = MOAITexture.GL_NEAREST_MIPMAP_LINEAR, 
    MipMapLinearLinear   = MOAITexture.GL_LINEAR_MIPMAP_LINEAR
}

function AtlasMgr:init()

end

---
-- Parse one line in spine atlas file into lua table
-- @param data output table
-- @param line input line
function AtlasMgr:parseLine(data, line)
    if not line:find(":") then
        data.name = SpineUtils.trim(line)
    else
        local key, value = unpack(SpineUtils.split(line, ":"))
        value = SpineUtils.trim(value)
        if value:find(",") then
            value = SpineUtils.split(value, ",")
        elseif value == "false" then
            value = false
        elseif value == "true" then
            value = true
        end
        data[SpineUtils.trim(key)] = value
    end
end

---
-- Parse spine atlas file. Internall use
-- @param atlas full path to spine atlas file
-- @return lua table with atlas data
function AtlasMgr:load(atlas)
    local pagesData = {}
    local pageData = {}
    local regionsData = {}
    local regionData = {}
    local path = SpineUtils.getPath(atlas)

    local input = io.input(atlas)

    for line in input:lines() do
        if line:len() == 0 and not table.isEmpty(pageData) then
            if not table.isEmpty(regionData) then 
                table.insert(regionsData, regionData)
            end
            pageData.regions = regionsData
            table.insert(pagesData, pageData)
            regionsData = {}
            regionData = {}
            pageData = {}
        else
            if SpineUtils.length(pageData) < 4 then
                self:parseLine(pageData, line)
            else
                if not line:find(":") and not table.isEmpty(regionData) then
                    table.insert(regionsData, regionData)
                    regionData = {}
                end
                self:parseLine(regionData, line)
            end
        end
    end
    table.insert(regionsData, regionData)
    pageData.regions = regionsData
    table.insert(pagesData, pageData)

    input:close()

    local atlas = {}
    for i, pageData in ipairs(pagesData) do
        atlas[i] = {
            texturePath = path .. pageData.name,
            minFilter = AtlasMgr.FILTERS[pageData.filter[1]],
            maxFilter = AtlasMgr.FILTERS[pageData.filter[2]],
            regions = {},
        }
        
        for j, regionData in ipairs(pageData.regions) do
            atlas[i].regions[regionData.name] = {
                rect = {
                    x = tonumber(regionData.offset[1]),
                    y = tonumber(regionData.offset[2]),
                    width = tonumber(regionData.size[1]),
                    height = tonumber(regionData.size[2]),
                },

                x = tonumber(regionData.xy[1]),
                y = tonumber(regionData.xy[2]),
                
                origWidth = tonumber(regionData.orig[1]),
                origHeight = tonumber(regionData.orig[2]),
                rotate = regionData.rotate,
            }
        end
    end

    return atlas
end

--- 
-- Return deck and index for displaying attachment
-- @param attachmentName actual attachment name
-- @param atlasName attachment will be looked up in this atlas
-- @param scale skeleton scale
function AtlasMgr:getAttachmentDeckAndIndex(attachmentName, atlasName, scale)
    local fullPath = Resources.getResourceFilePath(atlasName)
    local cache = AtlasMgr.atlasCache

    if cache[fullPath] == nil then
        cache[fullPath] = AtlasMgr:load(fullPath)
    end
    local atlasPagesMap = cache[fullPath]

    local deck
    local index
    local textureInfo
    for i, page in ipairs(atlasPagesMap) do
        if page.regions and page.regions[attachmentName] then
            deck = self:getSpineAtlasDeck(page, scale)
            index = page.regions[attachmentName].deckIndex
        end
    end

    return deck, index
end

---
-- Return the Deck for displaying Spine Atlas page
-- @param atlasPageData lua table with data for current atlas page
-- @param scale scale
function AtlasMgr:getSpineAtlasDeck(atlasPageData, scale)
    local key = atlasPageData.texturePath .. "$" .. scale
    local cache = DeckMgr.atlasDecks

    if not cache[key] then
        cache[key] = self:createSpineAtlasDeck(atlasPageData, scale)
    end
    return cache[key]
end

---
-- Create the Deck for displaying one Spine Atlas page
-- @param atlasPage lua table with region data for current atlas page
-- @param scale scale
function AtlasMgr:createSpineAtlasDeck(atlasPage, scale)
    local frames = atlasPage.regions
    local totalFrames = SpineUtils.length(frames)
    local boundsDeck = MOAIBoundsDeck.new()
    boundsDeck:reserveBounds(totalFrames)
    boundsDeck:reserveIndices(totalFrames)

    local texture = Resources.getTexture(atlasPage.texturePath)
    assert(texture, "AtlasMgr: cannot load texture")
    texture:setFilter(atlasPage.minFilter, atlasPage.maxFilter)

    local deck = MOAIGfxQuadDeck2D.new()
    deck:setBoundsDeck(boundsDeck)
    deck:reserve(totalFrames)
    deck:setTexture(texture)

    local width, height = texture:getSize()

    local i = 1
    for name, frame in pairs(frames) do
        local r = frame.rect
        local x, y = frame.x, frame.y
        
        if frame.rotate then
            local u0, v0, u1, v1 = x / width, y / height, (x + r.height) / width, (y + r.width) / height
            deck:setUVQuad(i, u1, v1, u1, v0, u0, v0, u0, v1)
        else
            local u0, v0, u1, v1 = x / width, y / height, (x + r.width) / width, (y + r.height) / height
            deck:setUVQuad(i, u0, v1, u1, v1, u1, v0, u0, v0)
        end

        deck:setRect(i, r.x * scale, r.y * scale, (r.x + r.width) * scale, (r.y + r.height) * scale)
        boundsDeck:setBounds(i, 0, 0, 0, frame.origWidth * scale, frame.origHeight * scale, 0)
        boundsDeck:setIndex(i, i)
        frame.deckIndex = i
        i = i + 1
    end

    return deck
end

return AtlasMgr