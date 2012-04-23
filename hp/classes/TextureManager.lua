local Logger = require("hp/classes/Logger")

----------------------------------------------------------------
-- テクスチャを要求するとキャッシュして、Textureを返します.<br>
-- @class table
-- @name TextureManager
----------------------------------------------------------------
local M = {}
local cache = {}

setmetatable(cache, {__mode = "v"})

local function gcHandler(udata)
    Logger.debug("[TextureManager] destroyed => " .. udata.path)
end

----------------------------------------------------------------
-- テクスチャを要求します.
-- @param path テクスチャのパス
-- @return テクスチャ
----------------------------------------------------------------
function M:request(path)
    if cache[path] == nil then
        local texture = MOAITexture.new()
        texture:load(path)
        texture.path = path
        texture.__gc = gcHandler
        cache[path] = texture
    end
    
    local texture = cache[path]
    return cache[path]
end

return M