----------------------------------------------------------------
-- TMXMapFactoryはtmxファイルを読み込んで、TMXMapを生成するクラスです.
-- 
-- @class table
-- @name TMXMapFactory
----------------------------------------------------------------
local M = {}

-- classes
local TMXMapLoader
local TMXDisplay

---------------------------------------
-- TMX形式のファイルを読み込みます.
-- 読み込んだ結果をTMXMapで返します.
---------------------------------------
function M:loadMap(filename)
    TMXMapLoader = TMXMapLoader or require("hp/classes/TMXMapLoader")
    return TMXMapLoader:new():load(filename)
end

---------------------------------------
-- TMXMapから表示オブジェクトを生成します.
---------------------------------------
function M:createDisplay(tmxMap)
    TMXDisplay = TMXDisplay or require("hp/classes/TMXDisplay")
    return TMXDisplay:new(tmxMap)
end

return M