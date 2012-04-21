----------------------------------------------------------------
-- Fontのキャッシュです.
-- フレームワーク内部で使用します.
-- @class table
-- @name FontCache
----------------------------------------------------------------

local M = {
    config = {
        font = "font_ipag.ttf",
        textSize = 24,
    }
}
local cache = {}

function M:request(ttf)
    ttf = ttf or self.config.font

    for i, v in ipairs(cache) do
        if v.ttf == ttf then
            v.requestCount = v.requestCount + 1
            return v.font
        end
    end

    local font = MOAIFont.new()
    font:load(ttf)
    
    local obj = {font = font, requestCount = 1}
    table.insert(cache, obj)

    return obj.font
end

return M
