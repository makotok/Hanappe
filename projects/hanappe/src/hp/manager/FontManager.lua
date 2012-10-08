--------------------------------------------------------------------------------
-- This is a class to manage the Font.
--
-- @auther Makoto
-- @class table
-- @name FontManager
--------------------------------------------------------------------------------

-- import
local ResourceManager           = require "hp/manager/ResourceManager"
local Logger                    = require "hp/util/Logger"

-- class
local M                         = {}

-- variables
M.cache                         = {}
M.fontPaths                     = {
    ["VL-PGothic"] = "fonts/VL-PGothic.ttf",
    ["arial-rounded"] = "fonts/arial-rounded.ttf",
}
M.charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'

--------------------------------------------------------------------------------
-- Requests the texture. <br>
-- The textures are cached internally.
-- @param fontName fontName or fontPath.
-- @return MOAIFont instance.
--------------------------------------------------------------------------------
function M:request(fontName)
    local path = ResourceManager:getFilePath(M.fontPaths[fontName] or fontName)
    
    for i, font in ipairs(M.cache) do
        if font.path == path then
            return font
        end
    end

    local font = MOAIFont.new()
    font:load(path)
    font.path = path
    table.insert(M.cache, font)

    return font
end

--------------------------------------------------------------------------------
-- Return you have generated the font. <br>
-- @param fontName fontName or fontPath.
-- @return MOAIFont instance.
--------------------------------------------------------------------------------
function M:newFont(fontName)
    local path = ResourceManager:getFilePath(M.fontPaths[fontName] or fontName)

    local font = MOAIFont.new()
    font:load(path)
    font.path = path
    return font
end

--------------------------------------------------------------------------------
-- Return you have generated the font. <br>
-- @return MOAIFont instance.
--------------------------------------------------------------------------------
function M:newPreloadFont(fontName, points, charcodes, dpi)
    local path = ResourceManager:getFilePath(M.fontPaths[fontName] or fontName)
    charcodes = charcodes or M.charcodes

    local font = MOAIFont.new()
    font:load(path)
    font:preloadGlyphs(charcodes, points, dpi)
    
    return font
end

return M
