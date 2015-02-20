--------------------------------------------------------------------------------
-- Easy Finite State Machine.
--
-- @author Makoto
-- @release V3.0.0
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Logger = require "flower.Logger"
local EventDispatcher = require "flower.EventDispatcher"

-- class
local StateMachine = class(EventDispatcher)

function StateMachine:init(states)
    StateMachine.__super.init(self)
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
function StateMachine:update()
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
function StateMachine:registerState(name, state)
    assert(self.states[name] == nil)
    self.states[name] = state
    state.name = name
end

---
-- 現在のステートをスタックに保存しつつ状態を変更します.
function StateMachine:pushCurrentState(stateName)
    assert(stateName)
    table.insert(self.currentStateQueue, self.currentState.name)
    self:changeCurrentState(stateName)
end

---
-- 現在のステートをスタックから取り出し状態を変更します.
function StateMachine:popCurrentState()
    if #self.currentStateQueue > 0 then
        local stateName = self.currentStateQueue[#self.currentStateQueue]
        table.remove(self.currentStateQueue, #self.currentStateQueue)
        self:changeCurrentState(stateName)
    else
        Logger.warn("Not Found State queue")
    end
end

---
-- 現在のステートを変更します.
function StateMachine:changeCurrentState(stateName)
    if self.currentState then
        self.currentState:exit(self.context)
    end
    
    Logger.debug("changeCurrentState", stateName)
    self.currentState = assert(self.states[stateName])
    
    if self.currentState then
        self.currentState:setMachine(self)
        self.currentState:enter(self.context)
    end
end

return StateMachine