local table = require("hp/lang/table")
local class = require("hp/lang/class")
local delegate = require("hp/lang/delegate")
local DisplayObject = require("hp/display/DisplayObject")

----------------------------------------------------------------
-- MOAIPropをグループ化にクラスです.<br>
-- @class table
-- @name Group
----------------------------------------------------------------
local M = class(DisplayObject)

local MOAIPropInterface = MOAIProp.getInterfaceTable()

----------------------------------------------------------------
-- Groupインスタンスを生成して返します.
----------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)

    params = params or {}

    self.children = {}

    self:setPrivate("width", 0)
    self:setPrivate("height", 0)

    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- パラメータを各プロパティにコピーします.
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.width then
        self:setWidth(params.width)
    end
    if params.height then
        self:setHeight(params.height)
    end

    DisplayObject.copyParams(self, params)
end

----------------------------------------------------------------
-- オブジェクトの境界を返します.
----------------------------------------------------------------
function M:getBounds()
    local xMin, yMin, zMin = 0, 0, 0
    local xMax, yMax, zMax = self:getWidth(), self:getHeight(), 0
    return xMin, yMin, zMin, xMax, yMax, zMax
end

--------------------------------------------------------------------------------
-- 幅を設定します.
--------------------------------------------------------------------------------
function M:setWidth(width)
    self:setSize(width, self:getHeight())
end

----------------------------------------------------------------
-- 幅を返します.
----------------------------------------------------------------
function M:getWidth()
    return self:getPrivate("width")
end

--------------------------------------------------------------------------------
-- 高さを設定します.
--------------------------------------------------------------------------------
function M:setHeight(height)
    self:setSize(self:getWidth(), height)
end

----------------------------------------------------------------
-- 高さを返します.
----------------------------------------------------------------
function M:getHeight()
    return self:getPrivate("height")
end

--------------------------------------------------------------------------------
--サイズを設定します.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    self:setPrivate("width", width)
    self:setPrivate("height", height)
end

----------------------------------------------------------------
-- visibleを設定します.
----------------------------------------------------------------
function M:setVisible(value)
    MOAIPropInterface.setVisible(self, value)
    
    for i, v in ipairs(self.children) do
        if v.setVisible then
            v:setVisible(value)
        end
    end
end

----------------------------------------------------------------
-- pivをサイズの中央に設定します.
----------------------------------------------------------------
function M:setCenterPiv()
    local left, top = self:getPos()
    local pivX = self:getWidth() / 2
    local pivY = self:getHeight() / 2
    self:setPiv(pivX, pivY, 0)
    self:setPos(left, top)
end

----------------------------------------------------------------
-- 子オブジェクトを返します.
----------------------------------------------------------------
function M:getChildren()
    return self.children
end

----------------------------------------------------------------
-- 子オブジェクトを追加します.
----------------------------------------------------------------
function M:addChild(child)
    local index = table.indexOf(self.children, child)
    if index > 0 then
        return
    end
    
    table.insert(self.children, child)
    child:setParent(self)
    
    if self.layer then
        if child.setLayer then
            child:setLayer(self.layer)
        end
    end
end

----------------------------------------------------------------
-- 子オブジェクトを削除します.
----------------------------------------------------------------
function M:removeChild(child)
    local children = self.children
    local index = table.indexOf(children, child)
    if index <= 0 then
        return
    end
    
    child:setParent(nil)
    
    if self.layer then
        if child.setLayer then
            child:setLayer(nil)
        end
    end
    
    table.remove(children, index)
end

--------------------------------------------------------------------------------
-- レイヤーを設定します.
--------------------------------------------------------------------------------
function M:setLayer(layer)
    self.layer = layer
    for i, child in ipairs(self.children) do
        if child.setLayer then
            child:setLayer(layer)
        end
    end
end

--------------------------------------------------------------------------------
-- グループかどうか返します.
-- 内部判定で使用されます.
--------------------------------------------------------------------------------
function M:isGroup()
    return true
end

--------------------------------------------------------------------------------
-- If the object will collide with the screen, it returns true.<br>
-- @param screenX x of screen
-- @param screenY y of screen
-- @param screenZ (option)z of screen
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestScreen(screenX, screenY, screenZ)
    assert(self.layer)
    screenZ = screenZ or 0
    
    for i, child in ipairs(self.children) do
        if child.hitTestScreen then
            if child:hitTestScreen(screenX, screenY, screenZ) then
                return true
            end
        else
            local worldX, worldY, worldZ = self.layer:wndToWorld(screenX, screenY, screenZ)
            if child:inside(worldX, worldY, worldZ) then
                return true
            end
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- If the object will collide with the world, it returns true.<br>
-- @param worldX world x of layer
-- @param worldY world y of layer
-- @param worldZ (option)world z of layer
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestWorld(worldX, worldY, worldZ)
    worldZ = worldZ or 0
    
    for i, child in ipairs(self.children) do
        if child.hitTestWorld then
            if child:hitTestWorld(worldX, worldY, worldZ) then
                return true
            end
        else
            if child:inside(worldX, worldY, worldZ) then
                return true
            end
        end
    end
    return false
end

return M