local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local FontManager = require("hp/manager/FontManager")

--------------------------------------------------------------------------------
-- テキストを描画するモジュールです.<br>
-- MOAITextBoxを生成して返します.
-- @class table
-- @name TextLabel
--------------------------------------------------------------------------------
local M = class(DisplayObject)

local interface = MOAITextBox.getInterfaceTable()

--------------------------------------------------------------------------------
-- TextLabelインスタンスを生成して返します.
--------------------------------------------------------------------------------
function M:new(params)
    params = params or {}

    -- textbox, font
    local textbox = MOAITextBox.new()
    table.copy(self, textbox)
    local font = FontManager:request(params.font)
    textbox:setFont(font)
    
    -- set params
    textbox:copyParams(params)

    return textbox
end

--------------------------------------------------------------------------------
-- パラメータを各プロパティにコピーします.
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.width and params.height then
        self:setSize(params.width, params.height)
    end
    if params.textSize then
        self:setTextSize(params.textSize)
    else
        self:setTextSize(FontManager.config.textSize)
    end
    if params.text then
        self:setString(params.text)
    end
    DisplayObject.copyParams(self, params)
end

--------------------------------------------------------------------------------
-- テキストサイズを設定します.
--------------------------------------------------------------------------------
function M:setTextSize(points, dpi)
    self:setPrivate("textSizePoints", points)
    self:setPrivate("textSizeDpi", dpi)
    interface.setTextSize(self, points, dpi)
end

--------------------------------------------------------------------------------
-- テキストサイズを返します.
--------------------------------------------------------------------------------
function M:getTextSize()
    return self:getPrivate("textSizePoints"), self:getPrivate("textSizeDpi")
end

--------------------------------------------------------------------------------
-- 幅を設定します.
--------------------------------------------------------------------------------
function M:setWidth(width)
    self:setSize(width, self:getHeight())
end

--------------------------------------------------------------------------------
-- 高さを設定します.
--------------------------------------------------------------------------------
function M:setHeight(height)
    self:setSize(self:getWidth(), height)
end

--------------------------------------------------------------------------------
-- サイズを設定します.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    width = width or self:getWidth()
    height = height or self:getHeight()
    
    local left, top = self:getLeft(), self:getTop()
    self:setRect(-width / 2, -height / 2, width / 2, height / 2)
    self:setLeft(left)
    self:setTop(top)
end

return M