module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    scene:addChild(layer)

    -- image1
    mapImage1 = flower.MapImage("numbers.png", 8, 5, 32, 32)
    mapImage1:setLayer(layer)
    mapImage1:setRows {
        { 1,  2 + MOAIGridSpace.TILE_X_FLIP,  3 + MOAIGridSpace.TILE_Y_FLIP,  4 + MOAIGridSpace.TILE_XY_FLIP,  5,  6,  7,  8},
        { 9, 10, 11, 12, 13, 14, 15, 16},
        {17, 18, 19, 20, 21, 22, 23, 24},
        {25, 26, 27, 28, 29, 30, 31, 32},
        {33, 34, 35, 36, 37, 38, 39, 40},
    }
end
