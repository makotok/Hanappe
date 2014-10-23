--------------------------------------------------------------------------------
-- Class is a tileset of TMXMap.
--------------------------------------------------------------------------------

local class = require("hp/lang/class")

local M = class()

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init(tmxMap)
    self.tmxMap = tmxMap
    self.name = ""
    self.firstgid = 0
    self.tilewidth = 0
    self.tileheight = 0
    self.spacing = 0
    self.margin = 0
    self.image = {source = "", width = 0, height = 0}
    self.tiles = {}
    self.properties = {}
end

--------------------------------------------------------------------------------
-- Returns the tile-index of the specified gid <br>
-- @param gid gid.
-- @return tile-index.
--------------------------------------------------------------------------------
function M:getTileIndexByGid(gid)
    return gid - self.firstgid + 1
end

return M