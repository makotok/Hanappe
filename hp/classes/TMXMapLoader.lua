local table = require("hp/lang/table")
local TMXMap = require("hp/classes/TMXMap")
local TMXTileset = require("hp/classes/TMXTileset")
local TMXLayer = require("hp/classes/TMXLayer")
local TMXObject = require("hp/classes/TMXObject")
local TMXObjectGroup = require("hp/classes/TMXObjectGroup")

----------------------------------------------------------------
-- TMXMapLoaderはtmxファイルを読み込んで、TMXMapを生成するクラスです。
-- 
-- @class table
-- @name TMXMapLoader
----------------------------------------------------------------
local M = {}
local I = {}

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:new()
    local obj = {
        nodeParserNames = {
            map = "parseNodeMap",
            tileset = "parseNodeTileset",
            layer = "parseNodeLayer",
            objectgroup = "parseNodeObjectGroup"
        }
    }
    return setmetatable(obj, {__index = I})
end

---------------------------------------
-- TMX形式のファイルを読み込みます。
-- 読み込んだ結果をTMXMapで返します。
---------------------------------------
function I:load(filename)
    local xml = MOAIXmlParser.parseFile(filename)
    self:parseNode(xml)
    return self.map
end

---------------------------------------
-- ノードを読み込みます。
---------------------------------------
function I:parseNode(node)
    --logger.debug("[TMXMapLoader:parseNode]", node.type)

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
function I:parseNodeMap(node)
    --logger.debug("[TMXMapLoader:parseNodeMap]")

    local map = TMXMap:new()
    self.map = map

    self:parseNodeAttributes(node, map)
    self:parseNodeProperties(node, map.properties)

end

---------------------------------------
-- ノードの属性を読み込みます。
-- 読み込んだ結果は、destに設定します。
---------------------------------------
function I:parseNodeAttributes(node, dest)
    --logger.debug("[TMXMapLoader:parseNodeAttributes]", node.type)

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
function I:parseNodeTileset(node)
    --logger.debug("[TMXMapLoader:parseNodeTileset]")
    
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
function I:parseNodeImage(node, tileset)
    --logger.debug("[TMXMapLoader:parseNodeImage]")
    
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
function I:parseNodeTile(node, tileset)
    --logger.debug("[TMXMapLoader:parseNodeTile]")

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
function I:parseNodeLayer(node)
    --logger.debug("[TMXMapLoader:parseNodeLayer]")

    local layer = TMXLayer:new(self.map)
    self.map:addLayer(layer)

    self:parseNodeAttributes(node, layer)
    self:parseNodeData(node, layer)
    self:parseNodeProperties(node, layer.properties)
end

---------------------------------------
-- dataのノードを読み込みます。
---------------------------------------
function I:parseNodeData(node, layer)
    --logger.debug("[TMXMapLoader:parseNodeData]")

    if node.children.data == nil then
        return
    end
    
    for i, data in ipairs(node.children.data) do
        for j, tile in ipairs(data.children.tile) do
            layer.tiles[j] = tonumber(tile.attributes.gid)
        end
    end
    
end

---------------------------------------
-- ObjectGroupのノードを読み込みます。
---------------------------------------
function I:parseNodeObjectGroup(node)
    --logger.debug("[TMXMapLoader:parseNodeObjectGroup]")

    local group = TMXObjectGroup:new(self.map)
    self.map:addObjectGroup(group)

    self:parseNodeAttributes(node, group)
    self:parseNodeObject(node, group)
    self:parseNodeProperties(node, group.properties)
end

---------------------------------------
-- ObjectGroup.objectのノードを読み込みます。
---------------------------------------
function I:parseNodeObject(node, group)
    --logger.debug("[TMXMapLoader:parseNodeObject]")

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
function I:parseNodeProperties(node, dest)
    --logger.debug("[TMXMapLoader:parseNodeProperties]")

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