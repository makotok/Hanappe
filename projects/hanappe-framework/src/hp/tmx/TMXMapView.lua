--------------------------------------------------------------------------------
-- View the class is to draw the TMXMap. <br>
-- You can render TMXMap by the use of this class. <br>
-- You can add your own processing can be inherited. <br>
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Layer = require("hp/display/Layer")
local MapSprite = require("hp/display/MapSprite")
local SpriteSheet = require("hp/display/SpriteSheet")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local TextureManager = require("hp/manager/TextureManager")

local M = class(EventDispatcher)

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init(resourceDirectory)
    EventDispatcher.init(self)
    self.resourceDirectory = resourceDirectory or ""
end

--------------------------------------------------------------------------------
-- Reads the map data, to generate a display object.
--------------------------------------------------------------------------------
function M:loadMap(tmxMap)
    self.tmxMap = tmxMap
    self.camera = self:createCamera()
    self.layers = self:createDisplayLayers()
    self.objectLayers = self:createDisplayObjectLayers()
    
    for i, layer in ipairs(self.layers) do
        layer:setCamera(self.camera)
    end
    for i, layer in ipairs(self.objectLayers) do
        layer:setCamera(self.camera)
    end
end

--------------------------------------------------------------------------------
-- Load the texture of the tile set that is specified.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function M:loadTexture(tileset)
    local tmxMap = self.tmxMap
    if tileset then
        if not tileset.texture then
            local path = self.resourceDirectory .. tileset.image.source
            tileset.texture = TextureManager:request(path)
        end
    end
end

--------------------------------------------------------------------------------
-- To generate a 2D camera.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function M:createCamera()
    local camera = MOAICamera.new()
    camera:setOrtho(true)
    camera:setNearPlane(1)
    camera:setFarPlane(-1)
    return camera
end


--------------------------------------------------------------------------------
-- Display to generate a tile layer.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function M:createDisplayLayers()
    local tmxMap = self.tmxMap
    local displayLayers = {}
    for i, layer in ipairs(tmxMap.layers) do
        if layer.visible ~= 0 and layer.properties.visible ~= "false" then
            table.insert(displayLayers, self:createDisplayLayer(layer))
        end
    end
    return displayLayers
end

--------------------------------------------------------------------------------
-- Display to generate a tile layer.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function M:createDisplayLayer(layer)
    local tmxMap = self.tmxMap
    local displayTilesets = self:createDisplayTilesets(layer)
    local displayLayer = Layer()
    displayLayer.mapLayer = layer
    displayLayer.tilesetRenderers = {}
    
    for key, tileset in pairs(displayTilesets) do
        if tileset.texture then
            local mapSprite = self:createDisplayLayerRenderer(displayLayer, tileset)
            table.insert(displayLayer.tilesetRenderers, mapSprite)
        end
    end
    return displayLayer
end

--------------------------------------------------------------------------------
-- To generate the object on which to draw the layer.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function M:createDisplayLayerRenderer(displayLayer, tileset)
    local tmxMap = self.tmxMap
    local mapWidth, mapHeight = tmxMap.width, tmxMap.height
    local mapLayer = displayLayer.mapLayer
    local texture = tileset.texture
    
    -- tile data
    local tw, th = texture:getSize()
    local spacing, margin = tileset.spacing, tileset.margin
    local tilewidth, tileheight = tileset.tilewidth, tileset.tileheight
    local tileCol = math.floor((tw + spacing) / tilewidth)
    local tileRow = math.floor((th + spacing) / tileheight)
    local tileSize = tileCol * tileRow
    
    -- make sprite
    local mapSprite = MapSprite({texture = texture, layer = displayLayer})
    mapSprite:setMapSize(mapWidth, mapHeight, tilewidth, tileheight)
    mapSprite:setMapSheets(tilewidth, tileheight, tileCol, tileRow, spacing, margin)
    mapSprite.tileset = tileset
    
    for y = 1, mapLayer.height do
        local rowData = {}
        for x = 1, mapLayer.width do
            local gid = mapLayer.tiles[(y - 1) * mapLayer.width + x]
            local tileNo = gid == 0 and gid or gid - tileset.firstgid + 1
            tileNo = tileNo > tileSize and 0 or tileNo
            table.insert(rowData, tileNo)
        end
        mapSprite:setRow(y, unpack(rowData))
    end
    
    return mapSprite
end

--------------------------------------------------------------------------------
-- To generate a list of tile set that is used by a given layer.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function M:createDisplayTilesets(layer)
    local tmxMap = self.tmxMap
    local tilesets = {}
    for i, gid in ipairs(layer.tiles) do
        local tileset = tmxMap:findTilesetByGid(gid)
        if tileset then
            self:loadTexture(tileset)
            tilesets[tileset.name] = tileset
        end
    end
    return tilesets
end

--------------------------------------------------------------------------------
-- To generate the object layer.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function M:createDisplayObjectLayers()
    local objectLayers = {}
    for i, objectGroup in ipairs(self.tmxMap.objectGroups) do
        local objectLayer = self:createDisplayObjectLayer(objectGroup)
        table.insert(objectLayers, objectLayer)
    end
    return objectLayers
end

--------------------------------------------------------------------------------
-- Layer to generate a display object from the object group.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function M:createDisplayObjectLayer(objectGroup)
    local objectLayer = Layer:new()
    objectLayer.objects = {}
    for j, object in ipairs(objectGroup.objects) do
        if object.gid and object.gid > 0 then
            local displayObject = self:createDisplayObject(object)
            objectLayer:insertProp(displayObject)
            table.insert(objectLayer.objects, displayObject)
        end
    end
    return objectLayer
end

--------------------------------------------------------------------------------
-- To generate a display object from the object data.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function M:createDisplayObject(object)
    local tmxMap = self.tmxMap
    local gid = object.gid
    local tileset = tmxMap:findTilesetByGid(gid)
    self:loadTexture(tileset)

    local texture = tileset.texture
    local tw, th = texture:getSize()
    local spacing, margin = tileset.spacing, tileset.margin
    local tilewidth, tileheight = tileset.tilewidth, tileset.tileheight
    local tileCol = math.floor((tw + spacing) / tilewidth)
    local tileRow = math.floor((th + spacing) / tileheight)
    
    local sprite = SpriteSheet {texture = texture}
    sprite:setTiledSheets(tilewidth, tileheight, tileCol, tileRow)
    sprite.mapObject = object
    sprite:setLeft(object.x)
    sprite:setTop(object.y - sprite:getHeight())
    sprite:setIndex(object.gid - tileset.firstgid + 1)
    
    if object.properties.sheetAnims then
        local sheetAnims = assert(loadstring("return {" .. object.properties.sheetAnims .. "}"))()
        sprite:setSheetAnims(sheetAnims)
    end
    if object.properties.playAnim then
        sprite:playAnim(object.properties.playAnim)
    end
    if object.properties.visible then
        sprite:setVisible(toboolean(object.properties.visible))
    end
    
    return sprite
end

--------------------------------------------------------------------------------
-- Set the Scene.
-- Add a layer for each Scene.
--------------------------------------------------------------------------------
function M:setScene(scene)
    self.scene = scene
    for i, layer in ipairs(self.layers) do
        scene:addChild(layer)
    end
    for i, layer in ipairs(self.objectLayers) do
        scene:addChild(layer)
    end
end

--------------------------------------------------------------------------------
-- To scroll through the camera.
-- Adjust the position so that it does not appear out-of-range region is specified.
--------------------------------------------------------------------------------
function M:scrollCamera(x, y)
    local viewWidth, viewHeight = self:getViewSize()
    local firstLayer = self.layers[1]
    local maxX, maxY = viewWidth - firstLayer:getViewWidth(), viewWidth - firstLayer:getViewHeight()
    
    x = x < 0 and 0 or x
    x = x > maxX and maxX or x
    y = y < 0 and 0 or y
    y = y > maxY and maxY or y
    
    self.camera:setLoc(x, y, 0)
end

--------------------------------------------------------------------------------
-- Scroll to the specified position in the center of the camera.
-- Adjust the position so that it does not appear out-of-range region is specified.
--------------------------------------------------------------------------------
function M:scrollCameraToCenter(x, y)
    local firstLayer = self.layers[1]
    local cx, cy = firstLayer:getViewWidth() / 2, firstLayer:getViewHeight() / 2
    self:scrollCamera(x - cx, y - cy)
end

--------------------------------------------------------------------------------
-- To return the object to find the object from the name, the first one it finds.
-- If not found, returns nil.
--------------------------------------------------------------------------------
function M:findObjectByName(name)
    for i, objectLayer in ipairs(self.objectLayers) do
        for j, object in ipairs(objectLayer.objects) do
            if object.mapObject.name == name then
                return object
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Returns all of the objects to find the object from the name, was found.
--------------------------------------------------------------------------------
function M:findObjectsByName(name)
    local objects = {}
    for i, objectLayer in ipairs(self.objectLayers) do
        for j, object in ipairs(objectLayer.objects) do
            if object.mapObject.name == name then
                table.insert(objects, object)
            end
        end
    end
    return objects
end

--------------------------------------------------------------------------------
-- Returns the layer by layer from the name search, was found.
--------------------------------------------------------------------------------
function M:findLayerByName(name)
    for i, layer in ipairs(self.layers) do
        if layer.mapLayer.name == name then
            return layer
        end
    end
end

--------------------------------------------------------------------------------
-- Search for renderer for the Tileset and Layer.
-- @param layer Display layer
-- @param tileset TMXTileset
--------------------------------------------------------------------------------
function M:findLayerRendererByTileset(layer, tileset)
    for i, renderer in ipairs(layer.tilesetRenderers) do
        if renderer.tileset == tileset then
            return renderer
        end
    end
end

--------------------------------------------------------------------------------
-- Update the GID of the specified layer.
-- @param layer The name of the layer or object
-- @param x position of x.
-- @param y position of y.
-- @param gid Global tile ID
--------------------------------------------------------------------------------
function M:updateGid(layer, x, y, gid)
    layer = type(layer) == "string" and self:findLayerByName(layer) or layer
    layer.mapLayer:setGid(x, y, gid)
    
    local tileset = self.tmxMap:findTilesetByGid(gid)
    for i, renderer in ipairs(layer.tilesetRenderers) do
        if renderer.tileset == tileset then
            local tileNo = gid == 0 and gid or gid - tileset.firstgid + 1
            renderer:setTile(x, y, tileNo)
        else
            renderer:setTile(x, y, 0)
        end
    end

    local renderer = self:findLayerRendererByTileset(layer, tileset)
    if not renderer then
        self:loadTexture(tileset)
        if tileset.texture then
            renderer = self:createDisplayLayerRenderer(layer, tileset)
            table.insert(layer.tilesetRenderers, renderer)
        end
    end
end

--------------------------------------------------------------------------------
-- Returns the size of the MapView.
--------------------------------------------------------------------------------
function M:getViewSize()
    if not self.tmxMap then
        return 0, 0
    end
    local width = self.tmxMap.width * self.tmxMap.tilewidth
    local height = self.tmxMap.height * self.tmxMap.tileheight
    return width, height
end

return M