local Logger = require("hp/util/Logger")

----------------------------------------------------------------
-- Fontのキャッシュです.
-- フレームワーク内部で使用します.
-- @class table
-- @name FontManager
----------------------------------------------------------------

local M = {
    config = {
        fontPath = "assets/fonts/ipag.ttf",
        textSize = 24,
    }
}
local cache = {}
setmetatable(cache, {__mode = "v"})

local function gcHandler(udata)
    Logger.debug("[FontManager] destroyed => " .. udata.path)
end

function M:request(path)
    path = path or self.config.fontPath
    
    for i, font in ipairs(cache) do
        if font.path == path then
            return font
        end
    end

    local font = MOAIFont.new()
    font:load(path)
    font.__gc = gcHandler
    font.path = path
    table.insert(cache, font)

    return font
end

return M
