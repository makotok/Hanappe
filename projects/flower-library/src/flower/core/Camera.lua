----------------------------------------------------------------------------------------------------
-- flower's idea of a Camera, which is a superclass of the Moai Camera.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="http://moaiforge.github.io/moai-sdk/api/latest/class_m_o_a_i_camera.html">MOAICamera</a><l/i>
-- </ul>
-- 
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"

-- class
local Camera = class()
Camera.__index = MOAICamera.getInterfaceTable()
Camera.__moai_class = MOAICamera

---
-- The constructor.
-- @param ortho (option)ortho
-- @param near (option)near plane
-- @param far (option)far plane
function Camera:init(ortho, near, far)
    ortho = ortho == nil and true or ortho
    near = near or 1
    far = far or -1

    self:setOrtho(ortho)
    self:setNearPlane(near)
    self:setFarPlane(far)
end

return Camera