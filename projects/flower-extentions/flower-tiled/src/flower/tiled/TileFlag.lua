----------------------------------------------------------------------------------------------------
-- Constant representing the flag of the tile.
----------------------------------------------------------------------------------------------------

-- import
local BitUtils = require "flower.BitUtils"

-- class
local TileFlag = {}

--- Flip horizontal of the flag.
TileFlag.FLIPPED_HORIZONTALLY_FLAG = BitUtils.bit(32)

--- Flip vertical of the flag.
TileFlag.FLIPPED_VERTICALLY_FLAG = BitUtils.bit(31)

--- Flip diagonally of the flag.
TileFlag.FLIPPED_DIAGONALLY_FLAG = BitUtils.bit(30)

function TileFlag.clearFlags(value)
    if value >= TileFlag.FLIPPED_DIAGONALLY_FLAG then
        value = BitUtils.clearbit(value, TileFlag.FLIPPED_HORIZONTALLY_FLAG)
        value = BitUtils.clearbit(value, TileFlag.FLIPPED_VERTICALLY_FLAG)
        value = BitUtils.clearbit(value, TileFlag.FLIPPED_DIAGONALLY_FLAG)
    end
    return value
end

return TileFlag