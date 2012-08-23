----------------------------------------------------------------
-- This is a class to manage the Texture.<br>
-- 
-- @auther Makoto
-- @class table
-- @name TextureManager
----------------------------------------------------------------

local ResourceManager = require("hp/manager/ResourceManager")
local Logger = require("hp/util/Logger")


local M = {}
local cache = {}

setmetatable(cache, {__mode = "v"})

local function gcHandler(udata)
    Logger.debug("[TextureManager] destroyed => " .. udata.path)
    udata:__oldgc()
end

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
        texture.__oldgc = texture.__gc
        texture.__gc = gcHandler
        cache[path] = texture
    end
    
    local texture = cache[path]
    return cache[path]
end

return M