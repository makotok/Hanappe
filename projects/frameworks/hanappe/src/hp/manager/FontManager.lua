----------------------------------------------------------------
-- This is a class to manage the Font.
--
-- @auther Makoto
-- @class table
-- @name FontManager
----------------------------------------------------------------

local ResourceManager = require("hp/manager/ResourceManager")
local Logger = require("hp/util/Logger")

local M = {}
local cache = {}

----------------------------------------------------------------
-- Requests the texture. <br>
-- The textures are cached internally.
-- @param path path
-- @return MOAITexture instance.
----------------------------------------------------------------
function M:request(path)
    path = path
    path = ResourceManager:getFilePath(path)
    
    for i, font in ipairs(cache) do
        if font.path == path then
            return font
        end
    end

    local font = MOAIFont.new()
    font:load(path)
    font.path = path
    table.insert(cache, font)

    return font
end

return M
