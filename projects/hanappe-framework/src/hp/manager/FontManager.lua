--------------------------------------------------------------------------------
-- This is a class to manage the Font.
--
-- @auther Makoto
-- @class table
-- @name FontManager
--------------------------------------------------------------------------------

-- import
local ResourceManager           = require "hp/manager/ResourceManager"

-- class
local M                         = {}

-- variables
M.cache                         = {}
M.fontPaths                     = {
    ["VL-PGothic"] = "fonts/VL-PGothic.ttf",
    ["arial-rounded"] = "fonts/arial-rounded.ttf",
}

local function generateUid(fontPath, points, charcodes, dpi)
    return (fontPath or "") .. "$" .. (points or "") .. "$" .. (charcodes or "") .. "$" .. (dpi or "") 
end

--------------------------------------------------------------------------------
-- Requests the texture. <br>
-- The textures are cached internally.
-- @param fontName fontName or fontPath.
-- @return MOAIFont instance.
--------------------------------------------------------------------------------
function M:request(fontName, points, charcodes, dpi)
    local path = ResourceManager:getFilePath(M.fontPaths[fontName] or fontName)
    local uid = generateUid(path, points, charcodes, dpi)
    
    if self.cache[uid] then
        return M.cache[uid]
    end

    local font = self:newFont(path, points, charcodes, dpi)
    self.cache[font.uid] = font

    return font
end

--------------------------------------------------------------------------------
-- Return you have generated the font. <br>
-- @param fontName fontName or fontPath.
-- @return MOAIFont instance.
--------------------------------------------------------------------------------
function M:newFont(fontName, points, charcodes, dpi)
    local path = ResourceManager:getFilePath(M.fontPaths[fontName] or fontName)

    local font = MOAIFont.new()
    font:load(path)
    font.path = path
    font.points = points
    font.charcodes = charcodes
    font.dpi = dpi
    font.uid = generateUid(path, points, charcodes, dpi)
    
    if points and charcodes then
        font:preloadGlyphs(charcodes, points, dpi)
    end
    
    return font
end

return M
