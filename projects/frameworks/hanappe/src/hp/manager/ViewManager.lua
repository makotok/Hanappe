--------------------------------------------------------------------------------
-- Viewの管理するマネージャです.
--------------------------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local Executors             = require "hp/util/Executors"
local FocusManager          = require "hp/manager/FocusManager"

-- module
local M                     = {}

--------------------------------------------------------------------------------
-- public functions
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ViewManagerの初期化処理を行います.
-- 一度だけ呼び出される必要があります.
--------------------------------------------------------------------------------
function M:initialize()
    if self._initialized then
        return
    end
    
    self._rootViews = {}
    self._initialized = true
    
    Executors.callLoop(self.enterFrame, self)
end

--------------------------------------------------------------------------------
-- 最上位のビューを追加します.
-- 追加したビューは、フレーム処理で更新が行われます.
--------------------------------------------------------------------------------
function M:addRootView(view)
    self:initialize()
    table.insertElement(self._rootViews, view)
end

--------------------------------------------------------------------------------
-- 最上位のビューを追加します.
-- 追加したビューは、フレーム処理で更新が行われます.
--------------------------------------------------------------------------------
function M:removeRootView(view)
    table.removeElement(self._rootViews, view)
end

--------------------------------------------------------------------------------
-- ビューを更新します.
--------------------------------------------------------------------------------
function M:enterFrame()
    local views = table.copy(self._rootViews)
    
    for i, view in ipairs(views) do
        view:enterFrame()
    end
end

return M
