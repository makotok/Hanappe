----------------------------------------------------------------
-- This is a class to manage the Font.
--
-- @auther Makoto
-- @class table
-- @name FontManager
----------------------------------------------------------------

local Logger = require("hp/util/Logger")

local M = {}

M.DEFAULT_FONT = "assets/fonts/ipag.ttf"

local cache = {}
setmetatable(cache, {__mode = "v"})

local function gcHandler(udata)
    Logger.debug("[FontManager] destroyed => " .. udata.path)
end

function M:request(path)
    path = path or self.DEFAULT_FONT
    
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
