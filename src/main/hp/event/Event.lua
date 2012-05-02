local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- Eventの基本クラスです.<br>
-- Eventのタイプ、送信元などの情報を保持します.
-- @class table
-- @name Event
--------------------------------------------------------------------------------

local M = class()

-- 定数
-- 典型的なイベントを定義
M.OPEN = "open"
M.CLOSE = "close"
M.ACTIVATE = "activate"
M.DEACTIVATE = "deactivate"
M.DOWN = "down"
M.UP = "up"
M.MOVE = "move"
M.CLICK = "click"
M.CANCEL = "cancel"
M.KEY_DOWN = "keyDown"
M.KEY_UP = "keyUp"
M.COMPLETE = "complete"
M.TOUCH_DOWN = "touchDown"
M.TOUCH_UP = "touchUp"
M.TOUCH_MOVE = "touchMove"
M.TOUCH_CANCEL = "touchCancel"

---------------------------------------
--- コンストラクタです
---------------------------------------
function M:init(eventType, target)
    self.type = eventType
    self.target = target
    self.stoped = false
end

function M:setListener(callback, source)
    self.callback = callback
    self.source = source
end

function M:stop()
    self.stoped = true
end

return M