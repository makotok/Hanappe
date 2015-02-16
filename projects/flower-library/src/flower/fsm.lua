----------------------------------------------------------------------------------------------------
-- 有限オートマトンの実装です.
--
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local table = flower.table
local EventDispatcher = flower.EventDispatcher

-- classes
local StateEngine
local State

--------------------------------------------------------------------------------
-- @type StateEngine
-- 状態を遷移をさせる為のエンジンです.
--------------------------------------------------------------------------------
StateEngine = class(EventDispatcher)
M.StateEngine = StateEngine

function StateEngine:init(states)
    StateEngine.__super.init(self)
    self.currentState = State()
    self.currentState.name = "NONE"
    self.currentStateQueue = {}
    self.states = states or {}
    self.context = {}

    for name, state in pairs(self.states) do
        state.name = name
    end
end

---
-- 状態を更新します.
function StateEngine:update()
    if self.currentState then
        local nextStateName = self.currentState:update(self.context)

        if nextStateName and self.states[nextStateName] then 
            self:changeCurrentState(stateName)
        end
    end
end

---
-- ステートを登録します.既に登録済である場合はエラーとします.
-- @param name ステート名
-- @param state ステート
function StateEngine:registerState(name, state)
    assert(self.states[name] == nil)
    self.states[name] = state
    state.name = name
end

---
-- 現在のステートをスタックに保存しつつ状態を変更します.
function StateEngine:pushCurrentState(stateName)
    assert(stateName)
    table.insert(self.currentStateQueue, self.currentState.name)
    self:changeCurrentState(stateName)
end

---
-- 現在のステートをスタックから取り出し状態を変更します.
function StateEngine:popCurrentState()
    if #self.currentStateQueue > 0 then
        local stateName = self.currentStateQueue[#self.currentStateQueue]
        table.remove(self.currentStateQueue, #self.currentStateQueue)
        self:changeCurrentState(stateName)
    else
        print("Not Found State queue")
    end
end

---
-- 現在のステートを変更します.
function StateEngine:changeCurrentState(stateName)
    if self.currentState then
        self.currentState:exit(self.context)
    end
    
    print("changeCurrentState", stateName)
    self.currentState = assert(self.states[stateName])
    
    if self.currentState then
        self.currentState:setEngine(self)
        self.currentState:enter(self.context)
    end
end

--------------------------------------------------------------------------------
-- @type State
-- 状態そのものを表すクラスです.
-- このクラスを継承して使用する事を想定します.
--------------------------------------------------------------------------------
State = class()
M.State = State

---
-- コンストラクタ
function State:init(params)
    params = params or {}
    self.engine = nil
    self._onEnter = params.onEnter
    self._onUpdate = params.onUpdate
    self._onExit = params.onExit
end

---
-- ステートエンジンを設定します.
-- @param engine エンジン
function State:setEngine(engine)
    self.engine = engine
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


return M