--------------------------------------------------------------------------------
-- Is the module object can be resized to be implemented.<br>
-- TODO:In the future, there is likely to change in order to unify the origin of the position.
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Set the width.<br>
-- @param width width
--------------------------------------------------------------------------------
function M:setWidth(width)
    self:setSize(width, self:getHeight())
end

--------------------------------------------------------------------------------
-- Set the height<br>
-- @param height height
--------------------------------------------------------------------------------
function M:setHeight(height)
    self:setSize(self:getWidth(), height)
end

--------------------------------------------------------------------------------
-- Set the height and width.<br>
-- If the argument is not set the size of the texture will be set.
-- TODO:In the future, there is likely to change in order to unify the origin of the position.
-- @param width width
-- @param height height
--------------------------------------------------------------------------------
function M:setSize(width, height)
    if self.texture then
        local tw, th = self.texture:getSize()
        width = width or tw
        height = height or th
    end
    
    width = width or self:getWidth()
    height = height or self:getHeight()
    
    local left, top = self:getPos()
    self.deck:setRect(-width / 2, -height / 2, width / 2, height / 2)
    self:setPos(left, top)
end

--------------------------------------------------------------------------------
-- Function indicating that it is possible to resize.<br>
-- @return true
--------------------------------------------------------------------------------
function M:isResizable()
    return true
end

return M