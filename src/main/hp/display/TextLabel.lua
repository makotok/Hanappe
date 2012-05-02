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
        self:setRectSize(params.width, params.height)
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
-- 四角形のサイズを設定します.
--------------------------------------------------------------------------------
function M:setRectSize(width, height)
    width = width or self:getWidth()
    height = height or self:getHeight()
    
    self:setRect(-width / 2, -height / 2, width / 2, height / 2)
end

return M