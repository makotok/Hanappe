--------------------------------------------------------------------------------
-- TMXMapLoader is a class that reads the file format tmx, to create a TMXMap.
-- Some functions, please do not see from the outside.
-- Dare, leaving for the inheritance.
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local TMXMap = require("hp/tmx/TMXMap")
local TMXTileset = require("hp/tmx/TMXTileset")
local TMXLayer = require("hp/tmx/TMXLayer")
local TMXObject = require("hp/tmx/TMXObject")
local TMXObjectGroup = require("hp/tmx/TMXObjectGroup")
local ResourceManager = require("hp/manager/ResourceManager")

local M = class()

M.ENCODING_CSV = "csv"
M.ENCODING_BASE64 = "base64"

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init()
    self.nodeParserNames = {
        map = "parseNodeMap",
        tileset = "parseNodeTileset",
        layer = "parseNodeLayer",
        objectgroup = "parseNodeObjectGroup"
    }
end

--------------------------------------------------------------------------------
-- Read the file format of TMX. <br>
-- Returns TMXMap a result of reading.
-- @param filename
-- @return TMXMap instance.
--------------------------------------------------------------------------------
function M:loadFile(filename)
    local data = ResourceManager:readFile(filename)
    return self:loadString(data)

    -- TODO:Windowsだとpackage.pathを使用した場合に動作しない
    -- MEMO:Moai1.3 Build160以降で修正されたかもしれない
    --[[
    local xml = MOAIXmlParser.parseFile(filename)
    self:parseNode(xml)
    return assert(self.map)
    --]]
end

--------------------------------------------------------------------------------
-- Read the string format of TMX. <br>
-- Returns TMXMap a result of reading.
-- @param data string data
-- @return TMXMap instance.
--------------------------------------------------------------------------------
function M:loadString(data)
    local xml = MOAIXmlParser.parseString(data)
    self:parseNode(xml)
    return assert(self.map)
end

--------------------------------------------------------------------------------
-- Reads the node. <br>
-- Has been left for inheritance. <br>
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function M:parseNodeMap(node)
    print("parseNodeMap")
    local map = TMXMap:new()
    self.map = map

    self:parseNodeAttributes(node, map)
    self:parseNodeProperties(node, map.properties)
end

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function M:parseNodeAttributes(node, dest)
    for key, value in pairs(node.attributes) do
        if tonumber(value) ~= nil then
            dest[key] = tonumber(value)
        else
            dest[key] = value
        end
    end
end

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function M:parseNodeTileset(node)
    local tileset = TMXTileset:new(self.map)
    self.map:addTileset(tileset)

    self:parseNodeAttributes(node, tileset)
    self:parseNodeImage(node, tileset)
    self:parseNodeTile(node, tileset)
    self:parseNodeProperties(node, tileset.properties)
end

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function M:parseNodeTile(node, tileset)
    if not node.children.tile then
        return
    end
    for key, value in pairs(node.children.tile) do
        local id = tonumber(value.attributes.id) + 1
        if tileset.tiles[id] == nil then
            tileset.tiles[id] = {properties = {}}
        end
        self:parseNodeProperties(value, tileset.tiles[id].properties)
    end
end

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function M:parseNodeLayer(node)
    local layer = TMXLayer:new(self.map)
    self.map:addLayer(layer)

    self:parseNodeAttributes(node, layer)
    self:parseNodeData(node, layer)
    self:parseNodeProperties(node, layer.properties)
end

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
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
        error("Not supported encoding!")
    end

end

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function M:parseNodeDataForPlane(node, layer, data)
    for j, tile in ipairs(data.children.tile) do
        layer.tiles[j] = tonumber(tile.attributes.gid)
    end
end

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function M:parseNodeDataForCsv(node, layer, data)
    layer.tiles = assert(loadstring("return {" .. data.value .. "}"))()
end

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function M:parseNodeObjectGroup(node)
    local group = TMXObjectGroup:new(self.map)
    self.map:addObjectGroup(group)

    self:parseNodeAttributes(node, group)
    self:parseNodeObject(node, group)
    self:parseNodeProperties(node, group.properties)
end

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
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
