--------------------------------------------------------------------------------
-- タイルマップ形式のデータを保持するTMXMapクラスです.<br>
-- タイルマップエディタについては、以下を参照してください.<br>
-- http://www.mapeditor.org/
-- @class table
-- @name TMXMap
--------------------------------------------------------------------------------

local M = {}
local I = {}

-- constraints
M.ATTRIBUTE_NAMES = {
    "version", "orientation", "width", "height", "tilewidth", "tileheight"
}

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:new()
    local obj = {
        version = 0,
        orientation = "",
        width = 0,
        height = 0,
        tilewidth = 0,
        tileheight = 0,
        resourceDirectory = "",
        layers = {},
        tilesets = {},
        objectGroups = {},
        properties = {},
    }
    return setmetatable(obj, {__index = I})
end

---------------------------------------
-- TMXMapの情報を標準出力します.
---------------------------------------
function I:printDebug()
    -- header
    print("<TMXMap>")
    
    -- attributes
    for i, attr in ipairs(self.ATTRIBUTE_NAMES) do
        local value = self[attr]
        value = value and value or ""
        print(attr .. " = " .. value)
    end
    print("</TMXMap>")

end

---------------------------------------
-- レイヤーを追加します.
---------------------------------------
function I:addLayer(layer)
    table.insert(self.layers, layer)
end

---------------------------------------
-- レイヤーを削除します.
---------------------------------------
function I:removeLayerAt(index)
    table.remove(self.layers, index)
end

---------------------------------------
-- タイルセットを追加します.
---------------------------------------
function I:addTileset(tileset)
    table.insert(self.tilesets, tileset)
end

---------------------------------------
-- タイルセットを削除します.
---------------------------------------
function I:removeTilesetAt(index)
    table.remove(self.tilesets, index)
end

---------------------------------------
-- 指定されたGIDからタイルセットを検索して返します.
-- @param gid
-- @return TMXTileset
---------------------------------------
function I:findTilesetByGid(gid)
    local matchTileset = nil
    for i, tileset in ipairs(self.tilesets) do
        if gid >= tileset.firstgid then
            matchTileset = tileset
        end
    end
    return matchTileset
end

---------------------------------------
-- タイルセットを追加します.
---------------------------------------
function I:addObjectGroup(objectGroup)
    table.insert(self.objectGroups, objectGroup)
end

---------------------------------------
-- タイルセットを削除します.
---------------------------------------
function I:removeObjectGroupAt(index)
    table.remove(self.objectGroups, index)
end

---------------------------------------
-- 指定したキーのプロパティを返します.
---------------------------------------
function I:getProperty(key)
    return self.properties[key]
end

return M

