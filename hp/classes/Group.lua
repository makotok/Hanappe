local table = require("hp/lang/table")
local delegate = require("hp/lang/delegate")
local MOAIPropUtil = require("hp/classes/MOAIPropUtil")

----------------------------------------------------------------
-- 描画オブジェクトを生成するモジュールです.<br>
-- オブジェクトの生成を簡単に行う事ができるようになります。
-- @class table
-- @name display
----------------------------------------------------------------
local M = {}
local I = {}

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

local function copyParams(prop, params)
    if params.width then
        prop:setWidth(params.width)
    end
    if params.height then
        prop:setHeight(params.height)
    end
end

----------------------------------------------------------------
-- Groupインスタンスを生成して返します.
----------------------------------------------------------------
function M:new(params)
    params = params or {}

    -- transform, color, group
    local group = MOAITransform.new()
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
    
    -- custom functions
    table.copy(MOAIPropUtil, group)
    table.copy(I, group)
    
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
    copyParams(group, params)

    return group
end

----------------------------------------------------------------
-- 幅を設定します.
----------------------------------------------------------------
function I:setWidth(width)
    self.width = width
end

----------------------------------------------------------------
-- 幅を返します.
----------------------------------------------------------------
function I:getWidth()
    return self.width
end

----------------------------------------------------------------
-- 高さを設定します.
----------------------------------------------------------------
function I:setHeight(height)
    self.height = height
end

----------------------------------------------------------------
-- 高さを返します.
----------------------------------------------------------------
function I:getHeight()
    return self.height
end

----------------------------------------------------------------
-- visibleを設定します.
----------------------------------------------------------------
function I:setVisible(value)
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
function I:setCenterPiv()
    local pivX = self:getWidth() / 2
    local pivY = self:getHeight() / 2
    self:setPiv(pivX, pivY, 0)
end

----------------------------------------------------------------
-- 子オブジェクトを追加します.
----------------------------------------------------------------
function I:addChild(child)
    table.insert(self.children, child)
    if child.isGroup then
        child:setAttrLink(MOAITransform.INHERIT_TRANSFORM, self, MOAITransform.TRANSFORM_TRAIT)
        child.color:setAttrLink(MOAIColor.INHERIT_COLOR, self.color, MOAIColor.COLOR_TRAIT)
    else
        child:setAttrLink(MOAITransform.INHERIT_TRANSFORM, self, MOAITransform.TRANSFORM_TRAIT)
        child:setAttrLink(MOAIColor.INHERIT_COLOR, self.color, MOAIColor.COLOR_TRAIT)
    end
end

----------------------------------------------------------------
-- 子オブジェクトを削除します.
----------------------------------------------------------------
function I:removeChild(child)
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

return M