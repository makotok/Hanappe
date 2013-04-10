---------------------------------------------------------------------------------------------------
-- This is a class to manage the Texture.
---------------------------------------------------------------------------------------------------

local ResourceManager = require("hp/manager/ResourceManager")
local Logger = require("hp/util/Logger")

local M = {}
local cache = {}

setmetatable(cache, {__mode = "v"})

M.DEFAULT_FILTER = MOAITexture.GL_LINEAR

----------------------------------------------------------------
-- Requests the texture. <br>
-- The textures are cached internally.
-- @param path path
-- @return MOAITexture instance.
----------------------------------------------------------------
function M:request(path)
    path = ResourceManager:getFilePath(path)

    if cache[path] == nil then
        local texture = MOAITexture.new()
        texture:load(path)
        texture.path = path
        cache[path] = texture
        
        if M.DEFAULT_FILTER then
            texture:setFilter(M.DEFAULT_FILTER)
        end
    end
    
    local texture = cache[path]
    return cache[path]
end

return M
