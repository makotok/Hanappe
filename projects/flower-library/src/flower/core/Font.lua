----------------------------------------------------------------------------------------------------
-- Font class.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Config = require "flower.core.Config"

-- class
local Font = class()
Font.__index = MOAIFont.getInterfaceTable()
Font.__moai_class = MOAIFont

---
-- Constructor.
-- @param path Font path
-- @param charcodes (option) Font charcodes
-- @param points (option) Font points
-- @param dpi (option) Font dpi
function Font:init(path, charcodes, points, dpi)
    self:load(path)
    self.path = path
    self.charcodes = charcodes
    self.points = points
    self.dpi = dpi

    if charcodes and points then
        self:preloadGlyphs(charcodes, points, dpi)
    end
end

return Font