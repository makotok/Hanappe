----------------------------------------------------------------
-- スクロールするViewです.<br>
-- スクロール範囲内で、ユーザ操作によりスクロールします.<br>
-- @class table
-- @name ScrollView
----------------------------------------------------------------
-- import
local table                 = require "hp/lang/table"
local class                 = require "hp/lang/class"
local Layer                 = require "hp/display/Layer"
local Event                 = require "hp/event/Event"
local View                  = require "hp/gui/View"

-- class
local M                     = class(View)
local super                 = View

----------------------------------------------------------------
-- コンストラクタです.
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
    
end

----------------------------------------------------------------
-- コンストラクタです.
----------------------------------------------------------------
function M:createChildren()
    self._body = Scroller()
    self._header = ScrollHeader()
    self._footer = ScrollFooter()
    self._vertScrollBar = VScrollBar()
    self._horizScrollBar = HScrollBar()
end

function M:getBody()
    return self._body
end

function M:getHeader()
    return self
end

function M:setElements(value)
    self._body:setChildren(value)
end

function M:getElements()
    return self._body:getChildren()
end


return M