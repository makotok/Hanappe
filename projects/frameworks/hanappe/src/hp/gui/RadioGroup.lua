local table = require("hp/lang/table")
local class = require("hp/lang/class")

----------------------------------------------------------------
-- ラジオボタンウィジットクラスです.<br>
-- @class table
-- @name RadioButton
----------------------------------------------------------------
local M = class()

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:init()
    self:setPrivate("selectedItem", nil)
    self:setPrivate("children", {})
end

----------------------------------------------------------------
-- ラジオボタンリストを返します.
----------------------------------------------------------------
function M:getChildren()
    return self:getPrivate("children")
end

----------------------------------------------------------------
-- ラジオボタンを追加します.
----------------------------------------------------------------
function M:addChild(child)
    local children = self:getChildren()
    local added = table.insertElement(children, child)
    if added then
        child:setRadioGroup(self)
    end
end

----------------------------------------------------------------
-- ラジオボタンを削除します.
----------------------------------------------------------------
function M:removeChild(child)
    local children = self:getChildren()
    local removed = table.removeElement(children, child)
    if removed then
        child:setRadioGroup(nil)
    end
end


----------------------------------------------------------------
-- 選択済のラジオボタンを返します.
----------------------------------------------------------------
function M:getSelectedItem()
    return self:getPrivate("selectedItem")
end

----------------------------------------------------------------
-- 選択済のラジオボタンを設定します.
----------------------------------------------------------------
function M:setSelectedItem(item)
    if self:getSelectedItem() == item then
        return
    end
    
    self:setPrivate("selectedItem", item)
    item:setSelected(true)
    for i, child in ipairs(self:getChildren()) do
        if child ~= item then
            child:setSelected(false)
        end
    end
end

return M