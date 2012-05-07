local table = require("hp/lang/table")
local class = require("hp/lang/class")
local TMXMap = require("hp/tmx/TMXMap")
local TMXTileset = require("hp/tmx/TMXTileset")
local TMXLayer = require("hp/tmx/TMXLayer")
local TMXObject = require("hp/tmx/TMXObject")
local TMXObjectGroup = require("hp/tmx/TMXObjectGroup")

----------------------------------------------------------------
-- TMXMapLoaderはtmxファイルを読み込んで、TMXMapを生成するクラスです.<br>
-- TODO:抽象的な入力ストリームに対応するといいかも
-- @class table
-- @name TMXMapLoader
----------------------------------------------------------------
local M = class()

-- data encoding
M.ENCODING_CSV = "csv"
M.ENCODING_BASE64 = "base64"

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init()
    self.nodeParserNames = {
        map = "parseNodeMap",
        tileset = "parseNodeTileset",
        layer = "parseNodeLayer",
        objectgroup = "parseNodeObjectGroup"
    }
end

---------------------------------------
-- TMX形式のファイルを読み込みます。
-- 読み込んだ結果をTMXMapで返します。
---------------------------------------
function M:loadFile(filename)
    local xml = MOAIXmlParser.parseFile(filename)
    self:parseNode(xml)
    return self.map
end

---------------------------------------
-- ノードを読み込みます。
---------------------------------------
function M:parseNode(node)
    local parser = self.nodeParserNames[node.type]
    if parser then
        self[parser](self, node)
    else
        return
    end
    
    if not node.children then
        return
    end
    
    for key, value in pairs(node.children) do
        for key, value in ipairs(value) do
            if type(value) == "table" then
                self:parseNode(value)
            end
        end
    end
end

---------------------------------------
-- Mapのノードを読み込みます。
---------------------------------------
function M:parseNodeMap(node)
    local map = TMXMap:new()
    self.map = map

    self:parseNodeAttributes(node, map)
    self:parseNodeProperties(node, map.properties)

end

---------------------------------------
-- ノードの属性を読み込みます。
-- 読み込んだ結果は、destに設定します。
---------------------------------------
function M:parseNodeAttributes(node, dest)
    for key, value in pairs(node.attributes) do
        if tonumber(value) ~= nil then
            dest[key] = tonumber(value)
        else
            dest[key] = value
        end
    end
end

---------------------------------------
-- tilesetのノードを読み込みます。
---------------------------------------
function M:parseNodeTileset(node)
    local tileset = TMXTileset:new(self.map)
    self.map:addTileset(tileset)

    self:parseNodeAttributes(node, tileset)
    self:parseNodeImage(node, tileset)
    self:parseNodeTile(node, tileset)
    self:parseNodeProperties(node, tileset.properties)
end

---------------------------------------
-- imageのノードを読み込みます。
---------------------------------------
function M:parseNodeImage(node, tileset)
    if not node.children.image then
        return
    end
    for key, value in pairs(node.children.image) do
        for key, value in pairs(value.attributes) do
            tileset.image[key] = value
        end
    end
end

---------------------------------------
-- tileのノードを読み込みます。
---------------------------------------
function M:parseNodeTile(node, tileset)
    if node.children.node == nil then
        return
    end
    for key, value in pairs(node.children.tile) do
        local gid = tonumber(value.attributes.id)
        if tileset.tiles[gid] == nil then
            tileset.tiles[gid] = {properties = {}}
        end
        self:parseNodeProperties(value, self.tiles[gid].properties)
    end
end

---------------------------------------
-- Layerのノードを読み込みます。
---------------------------------------
function M:parseNodeLayer(node)
    local layer = TMXLayer:new(self.map)
    self.map:addLayer(layer)

    self:parseNodeAttributes(node, layer)
    self:parseNodeData(node, layer)
    self:parseNodeProperties(node, layer.properties)
end

---------------------------------------
-- dataのノードを読み込みます。
---------------------------------------
function M:parseNodeData(node, layer)
    if node.children.data == nil or #node.children.data < 1 then
        return
    end
    
    local data = node.children.data[1]
    
    if not data.attributes or not data.attributes.encoding then
        self:parseNodeDataForPlane(node, layer, data)
    elseif data.attributes.encoding == M.ENCODING_BASE64 then
        self:parseNodeDataForBase64(node, layer, data)
    elseif data.attributes.encoding == M.ENCODING_CSV then
        self:parseNodeDataForCsv(node, layer, data)
    else
        self:parseNodeDataForPlane(node, layer, data)
    end
    
end

---------------------------------------
-- 無圧縮形式のdataのノードを読み込みます。
---------------------------------------
function M:parseNodeDataForPlane(node, layer, data)
    for j, tile in ipairs(data.children.tile) do
        layer.tiles[j] = tonumber(tile.attributes.gid)
    end
end

---------------------------------------
-- csv形式のdataのノードを読み込みます。
---------------------------------------
function M:parseNodeDataForCsv(node, layer, data)
    layer.tiles = assert(loadstring("return {" .. data.value .. "}"))()
end

---------------------------------------
-- base64形式のdataのノードを読み込みます。
---------------------------------------
function M:parseNodeDataForBase64(node, layer, data)
    local decodedData = MOAIDataBuffer.base64Decode(data.value)
    
    if data.attributes.compression then
        decodedData = MOAIDataBuffer.inflate(decodedData, 47)
    end
    
    local tileSize = #decodedData / 4
    for i = 1, tileSize do
        local start = (i - 1) * 4 + 1
        local a0, a1, a2, a3 = string.byte(decodedData, start, start + 3)
        local gid = a3 * 256 * 3 + a2 * 256 * 2 + a1 * 256 + a0
        layer.tiles[i] = gid
    end
end

---------------------------------------
-- ObjectGroupのノードを読み込みます。
---------------------------------------
function M:parseNodeObjectGroup(node)
    local group = TMXObjectGroup:new(self.map)
    self.map:addObjectGroup(group)

    self:parseNodeAttributes(node, group)
    self:parseNodeObject(node, group)
    self:parseNodeProperties(node, group.properties)
end

---------------------------------------
-- ObjectGroup.objectのノードを読み込みます。
---------------------------------------
function M:parseNodeObject(node, group)
    if node.children.object == nil then
        return
    end
    
    for i, value in ipairs(node.children.object) do
        local object = TMXObject:new(group)
        self:parseNodeAttributes(value, object)
        self:parseNodeProperties(value, object.properties)
        group:addObject(object)
    end
end

---------------------------------------
-- TMXファイルのノードを読み込みます。
---------------------------------------
function M:parseNodeProperties(node, dest)
    if not node.children then
        return
    end
    if not node.children.properties then
        return
    end

    for key, value in ipairs(node.children.properties) do
        for key, value in ipairs(value.children.property) do
            dest[value.attributes.name] = value.attributes.value
        end
    end
end

return M