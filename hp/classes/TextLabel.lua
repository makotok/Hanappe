local table = require("hp/lang/table")
local MOAIPropUtil = require("hp/classes/MOAIPropUtil")
local FontManager = require("hp/classes/FontManager")

----------------------------------------------------------------
-- 描画オブジェクトを生成するモジュールです.<br>
-- オブジェクトの生成を簡単に行う事ができるようになります。
-- @class table
-- @name display
----------------------------------------------------------------
local M = {}
local I = {}

local function copyParams(prop, params)
    if params.width and params.height then
        prop:setRectSize(params.width, params.height)
    end
    if params.textSize then
        prop:setTextSize(params.textSize)
    else
        prop:setTextSize(FontManager.config.textSize)
    end
    if params.text then
        prop:setString(params.text)
    end
    if params.layer then
        params.layer:insertProp(prop)
    end
end

----------------------------------------------------------------
-- TextLabelインスタンスを生成して返します.
----------------------------------------------------------------
function M:new(params)
    params = params or {}

    -- textbox, font
    local font = FontManager:request(params.font)
    local textbox = MOAITextBox.new()
    textbox:setFont(font)
    
    -- custom functions
    table.copy(MOAIPropUtil, textbox)
    table.copy(I, textbox)

    -- set params
    copyParams( textbox, params)

    return textbox
end

----------------------------------------------------------------
-- 四角形のサイズを設定します.
----------------------------------------------------------------
function I:setRectSize(width, height)
    width = width or self:getWidth()
    height = height or self:getHeight()
    
    self:setRect(-width / 2, -height / 2, width / 2, height / 2)
end

return M