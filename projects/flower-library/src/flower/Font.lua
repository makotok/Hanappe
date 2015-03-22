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