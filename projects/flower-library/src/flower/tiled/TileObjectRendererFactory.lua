----------------------------------------------------------------------------------------------------
-- This class is a factory for generating TileObjectRenderer.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local TileObjectRenderer = require "flower.tiled.TileObjectRenderer"

-- class
local TileObjectRendererFactory = class()

---
-- Generate the renderer to draw the TileObject.
-- If there is no gid, objects is not generated.
-- @param tileObject TileObject
-- @return TileObjectRenderer
function TileObjectRendererFactory:newInstance(tileObject)
    if not tileObject.gid or tileObject.gid == 0 then
        return
    end

    return TileObjectRenderer(tileObject)
end

return TileObjectRendererFactory
