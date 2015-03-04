--------------------------------------------------------------------------------
-- 状態そのものを表すクラスです.
-- このクラスを継承して使用する事を想定します.
--
-- @author Makoto
-- @release V3.0.0
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"

-- class
local State = class()

---
-- コンストラクタ
function State:init(params)
    params = params or {}
    self.machine = nil
    self._onEnter = params.onEnter
    self._onUpdate = params.onUpdate
    self._onExit = params.onExit
end

---
-- ステートマシンを設定します.
-- @param machine エンジン
function State:setMachine(machine)
    self.machine = machine
end

---
-- 更新時に呼ばれるイベントハンドラです.
-- デフォルトでは空実装です.
function State:update(context)
    if self._onUpdate then
        return self._onUpdate(self, context)
    end
end

---
-- 状態開始時に呼ばれるイベントハンドラです.
-- デフォルトでは空実装です.
function State:enter(context)
    if self._onEnter then
        self._onEnter(self, context)
    end
end

---
-- 状態終了時に呼ばれるイベントハンドラです.
-- デフォルトでは空実装です.
function State:exit(context)
    if self._onExit then
        self._onExit(self, context)
    end
end

return State