----------------------------------------------------------------
-- テクスチャを要求するとキャッシュして、Textureを返します.<br>
-- @class table
-- @name texture
----------------------------------------------------------------
local M = {}
local cache = {}

----------------------------------------------------------------
-- テクスチャを要求します.
-- @param path テクスチャのパス
-- @return テクスチャ
----------------------------------------------------------------
function M:request(path)
    if cache[path] == nil then
        local texture = MOAITexture.new ()
        texture:load(path)
        texture.path = path
        cache[path] = texture
    end
    
    local texture = cache[path]
    return cache[path]
end

return M