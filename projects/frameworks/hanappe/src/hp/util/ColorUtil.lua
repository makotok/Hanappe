--------------------------------------------------------------------------------
-- This is a utility class to do a comparison of the object.<br>
-- @class table
-- @name ColorUtil
--------------------------------------------------------------------------------
local M = {}


function M.hexToRGBA(colorHex)
    return  tonumber ( "0x"..string.sub( colorHex, 2, 3 ) )/255.0,
            tonumber ( "0x"..string.sub( colorHex, 4, 5 ) )/255.0,
            tonumber ( "0x"..string.sub( colorHex, 6, 7 ) )/255.0,
            tonumber ( "0x"..string.sub( colorHex, 8, 9 ) )/255.0
end

function M.hexToRGBA(colorHex)
    return  tonumber ( "0x"..string.sub( colorHex, 2, 3 ) )/255.0,
            tonumber ( "0x"..string.sub( colorHex, 4, 5 ) )/255.0,
            tonumber ( "0x"..string.sub( colorHex, 6, 7 ) )/255.0,
            tonumber ( "0x"..string.sub( colorHex, 8, 9 ) )/255.0
end

function M.


return M