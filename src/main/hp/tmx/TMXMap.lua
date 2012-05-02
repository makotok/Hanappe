local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- タイルマップ形式のデータを保持するTMXMapクラスです.<br>
-- タイルマップエディタについては、以下を参照してください.<br>
-- http://www.mapeditor.org/
-- @class table
-- @name TMXMap
--------------------------------------------------------------------------------

local M = class()

-- constraints
M.ATTRIBUTE_NAMES = {
    "version", "orientation", "width", "height", "tilewidth", "tileheight"
}

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init()
    self.version = 0
    self.orientation = ""
    self.width = 0
    self.height = 0
    self.tilewidth = 0
    self.tileheight = 0
    self.layers = {}
    self.tilesets = {}
    self.objectGroups = {}
    self.properties = {}
end

---------------------------------------
-- TMXMapの情報を標準出力します.
---------------------------------------
function M:printDebug()
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
function M:addLayer(layer)
    table.insert(self.layers, layer)
end

---------------------------------------
-- レイヤーを削除します.
---------------------------------------
function M:removeLayerAt(index)
    table.remove(self.layers, index)
end

---------------------------------------
-- レイヤーを検索して返します.
---------------------------------------
function M:findLayerByName(name)
    for i, v in ipairs(self.layers) do
        if v.name == name then
            return v
        end
    end
    return nil
end

---------------------------------------
-- タイルセットを追加します.
---------------------------------------
function M:addTileset(tileset)
    table.insert(self.tilesets, tileset)
end

---------------------------------------
-- タイルセットを削除します.
---------------------------------------
function M:removeTilesetAt(index)
    table.remove(self.tilesets, index)
end

---------------------------------------
-- 指定されたGIDからタイルセットを検索して返します.
-- @param gid
-- @return TMXTileset
---------------------------------------
function M:findTilesetByGid(gid)
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
function M:addObjectGroup(objectGroup)
    table.insert(self.objectGroups, objectGroup)
end

---------------------------------------
-- タイルセットを削除します.
---------------------------------------
function M:removeObjectGroupAt(index)
    table.remove(self.objectGroups, index)
end

---------------------------------------
-- 指定したキーのプロパティを返します.
---------------------------------------
function M:getProperty(key)
    return self.properties[key]
end

return M