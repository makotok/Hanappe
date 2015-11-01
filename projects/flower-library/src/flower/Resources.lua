----------------------------------------------------------------------------------------------------
-- A resource management system that caches loaded resources to maximize performance.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Config = require "flower.Config"
local Font = require "flower.Font"
local Texture = require "flower.Texture"

-- class
local Resources = {}

-- variables
Resources.resourceDirectories = {}
Resources.textureCache = setmetatable({}, {__mode = "v"})
Resources.fontCache = {}

---
-- Add the resource directory path.
-- You can omit the file path by adding.
-- It is assumed that the file is switched by the resolution and the environment.
-- @param path resource directory path
function Resources.addResourceDirectory(path)
    table.insertElement(Resources.resourceDirectories, path)
end

---
-- Returns the filePath from fileName.
-- @param fileName
-- @return file path
function Resources.getResourceFilePath(fileName)
    if MOAIFileSystem.checkFileExists(fileName) then
        return fileName
    end
    for i, path in ipairs(Resources.resourceDirectories) do
        local filePath = path .. "/" .. fileName
        if MOAIFileSystem.checkFileExists(filePath) then
            return filePath
        end
    end
    return fileName
end

---
-- Loads (or obtains from its cache) a texture and returns it.
-- Textures are cached.
-- @param path The path of the texture
-- @param filter Texture filter.
-- @return Texture instance
function Resources.getTexture(path, filter)
    if type(path) == "userdata" then
        return path
    end

    local cache = Resources.textureCache
    local filepath = Resources.getResourceFilePath(path)
    local cacheKey = filepath .. "$" .. tostring(filter)
    if cache[cacheKey] == nil then
        local texture = Texture(filepath, filter)
        cache[cacheKey] = texture
    end
    return cache[cacheKey]
end

---
-- Loads (or obtains from its cache) a font and returns it.
-- @param path The path of the font.
-- @param charcodes (option)Charcodes of the font
-- @param points (option)Points of the font
-- @param dpi (option)Dpi of the font
-- @param filter (option)Filter of the font
-- @return Font instance
function Resources.getFont(path, charcodes, points, dpi, filter)
    if type(path) == "userdata" then
        return path
    end

    local cache = Resources.fontCache
    path = path or Config.FONT_NAME
    path = Resources.getResourceFilePath(path)
    charcodes = charcodes or Config.FONT_CHARCODES
    points = points or Config.FONT_POINTS
    filter = filter or Config.FONT_FILTER

    local uid = path .. "$" .. (charcodes or "") .. "$" .. (points or "") .. "$" .. (dpi or "") .. "$" .. (filter and tostring(filter) or "")
    if cache[uid] == nil then
        local font = Font(path, charcodes, points, dpi, filter)
        font.uid = uid
        cache[uid] = font
    end
    return cache[uid]
end

---
-- Returns the file data.
-- @param fileName file name
-- @return file data
function Resources.readFile(fileName)
    local path = Resources.getResourceFilePath(fileName)
    local input = assert(io.input(path))
    local data = input:read("*a")
    input:close()
    return data
end

---
-- Returns the result of executing the dofile.
-- Browse to the directory of the resource.
-- @param fileName lua file name
-- @return results of running the dofile
function Resources.dofile(fileName)
    local filePath = Resources.getResourceFilePath(fileName)
    return dofile(filePath)
end

---
-- Destroys the reference when the module.
-- @param m module
function Resources.destroyModule(m)
    if m and m._M and m._NAME and package.loaded[m._NAME] then
        package.loaded[m._NAME] = nil
        _G[m._NAME] = nil
    end
end

return Resources
