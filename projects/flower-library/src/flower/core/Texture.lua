----------------------------------------------------------------------------------------------------
-- Texture class.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="http://moaiforge.github.io/moai-sdk/api/latest/class_m_o_a_i_texture.html">MOAITexture</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Config = require "flower.core.Config"

-- class
local Texture = class()
Texture.__index = MOAITexture.getInterfaceTable()
Texture.__moai_class = MOAITexture

---
-- Constructor.
-- @param path Texture path
-- @param filter Texture filter
function Texture:init(path, filter)
    self:load(path)
    self.path = path
    self.filter = filter or Config.TEXTURE_FILTER

    if self.filter then
        self:setFilter(self.filter)
    end
end

return Texture