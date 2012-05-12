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

local COLOR_ATTRS = {
    MOAIColor.ATTR_R_COL,
    MOAIColor.ATTR_G_COL,
    MOAIColor.ATTR_B_COL,
    MOAIColor.ATTR_A_COL,
    MOAIColor.INHERIT_COLOR,
    MOAIColor.COLOR_TRAIT
}

local function hasColorAttr(attrID)
    for i, v in ipairs(COLOR_ATTRS) do
        if attrID == v then
            return true
        end
    end
    return false
end

----------------------------------------------------------------
-- Groupインスタンスを生成して返します.
----------------------------------------------------------------
function M:new(params)
    params = params or {}

    -- transform, color, group
    local group = MOAITransform.new()
    table.copy(self, group)
    local color = MOAIColor.new()
    group.color = color
    group.isGroup = true
    group.width = 0
    group.height = 0
    group.children = {}
    
    -- functions
    delegate(group, color, "moveColor")
    delegate(group, color, "seekColor")
    delegate(group, color, "setColor")
    
    -- extendes functions
    local super = {}
    
    --[[
    super.clearAttrLink = group.clearAttrLink
    group.clearAttrLink = function(self, attrID)
        super.clearAttrLink(self, attrID)
        self.color.clearAttrLink(color, attrID)
    end

    super.clearAttrLink = group.clearAttrLink
    group.clearAttrLink = function(self, attrID)
        super.clearAttrLink(self, attrID)
        self.color.clearAttrLink(color, attrID)
    end
    
    super.clearNodeLink = group.clearNodeLink
    group.clearNodeLink = function(self, attrID)
        super.clearNodeLink(self, attrID)
        self.color.clearNodeLink(color, attrID)
    end
    --]]
    
    -- set params
    group:copyParams(params)

    return group
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
-- サイズを返します.
----------------------------------------------------------------
function M:getBounds()
    local xMin, yMin, zMin = 0, 0, 0
    local xMax, yMax, zMax = self.width, self.height, 0
    return xMin, yMin, zMin, xMax, yMax, zMax
end

----------------------------------------------------------------
-- サイズを設定します.
----------------------------------------------------------------
function M:setSize(width, height)
    self:setWidth(width)
    self:setHeight(height)
end


----------------------------------------------------------------
-- サイズを返します.
----------------------------------------------------------------
function M:getSize()
    return self.width, self.height
end

----------------------------------------------------------------
-- 幅を設定します.
----------------------------------------------------------------
function M:setWidth(width)
    self.width = width
end

----------------------------------------------------------------
-- 幅を返します.
----------------------------------------------------------------
function M:getWidth()
    return self.width
end

----------------------------------------------------------------
-- 高さを設定します.
----------------------------------------------------------------
function M:setHeight(height)
    self.height = height
end

----------------------------------------------------------------
-- 高さを返します.
----------------------------------------------------------------
function M:getHeight()
    return self.height
end

----------------------------------------------------------------
-- visibleを設定します.
----------------------------------------------------------------
function M:setVisible(value)
    self.visible = value
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
    local pivX = self:getWidth() / 2
    local pivY = self:getHeight() / 2
    self:setPiv(pivX, pivY, 0)
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
    if child.isGroup then
        child:setAttrLink(MOAITransform.INHERIT_TRANSFORM, self, MOAITransform.TRANSFORM_TRAIT)
        child.color:setAttrLink(MOAIColor.INHERIT_COLOR, self.color, MOAIColor.COLOR_TRAIT)
    else
        child:setAttrLink(MOAITransform.INHERIT_TRANSFORM, self, MOAITransform.TRANSFORM_TRAIT)
        child:setAttrLink(MOAIColor.INHERIT_COLOR, self.color, MOAIColor.COLOR_TRAIT)
    end
    
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
    
    if child.isGroup then
        child:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)
        child.color:clearAttrLink(MOAIColor.INHERIT_COLOR)
    else
        child:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)
        child:clearAttrLink(MOAIColor.INHERIT_COLOR)
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

return M