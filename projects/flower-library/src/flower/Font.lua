----------------------------------------------------------------------------------------------------
-- Font class.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="http://moaiforge.github.io/moai-sdk/api/latest/class_m_o_a_i_font.html">MOAIProp</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Config = require "flower.Config"

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
-- @param filter (option) Font filter
function Font:init(path, charcodes, points, dpi, filter)
    self:load(path)
    self.path = path
    self.charcodes = charcodes
    self.points = points
    self.dpi = dpi
    self.filter = filter

    -- Added from V1.6
    if self.filter and self.setFilter then
        self:setFilter(self.filter)
    end

    if charcodes and points then
        self:preloadGlyphs(charcodes, points, dpi)
    end
end

return Font