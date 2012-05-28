local class = require("hp/lang/class")
local Event = require("hp/event/Event")
local EventListener = require("hp/event/EventListener")

----------------------------------------------------------------
-- イベント処理を行うための基本クラスです.
-- イベントの発出した結果を、登録したイベントリスナがキャッチして
-- イベント処理を行います.
-- @class table
-- @name EventDispatcher
----------------------------------------------------------------
local M = class()

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init()
    self.eventlisteners = {}
end

---------------------------------------
-- イベントリスナを登録します.
-- callbackは、呼び出されるコールバック関数です.
-- sourceは、オブジェクトの関数だった場合に指定します.
-- nilの場合は、callback(event)となり、
-- 指定ありの場合、callback(self, event)で呼ばれます.
-- priorityは、優先度です.
-- 優先度が小さい値程、最初に関数が呼ばれます.
---------------------------------------
function M:addEventListener(eventType, callback, source, priority)
    if self:hasEventListener(eventType, callback, source) then
        return false
    end

    local listener = EventListener:new(eventType, callback, source, priority)

    for i, v in ipairs(self.eventlisteners) do
        if listener.priority < v.priority then
            table.insert(self.eventlisteners, i, listener)
            return true
        end
    end

    table.insert(self.eventlisteners, listener)
    return true
end

---------------------------------------
--- イベントリスナを削除します.
---------------------------------------
function M:removeEventListener(eventType, callback, source)
    for key, obj in ipairs(self.eventlisteners) do
        if obj.type == eventType and obj.callback == callback and obj.source == source then
            table.remove(self.eventlisteners, key)
            return true
        end
    end
    return false
end

---------------------------------------
-- イベントリスナが登録済か返します.
---------------------------------------
function M:hasEventListener(eventType, callback, source)
    assert(eventType)
    for key, obj in ipairs(self.eventlisteners) do
        if obj.type == eventType then
            if callback or source then
                if obj.callback == callback and obj.source == source then
                    return true
                end
            else
                return true
            end
        end
    end
    return false
end

---------------------------------------
-- イベントをディスパッチします
---------------------------------------
function M:dispatchEvent(event)
    event = type(event) == "string" and Event(event) or event
    event.stoped = false
    event.target = self.eventTarget or self
    for key, obj in ipairs(self.eventlisteners) do
        if obj.type == event.type then
            event:setListener(obj.callback, obj.source)
            obj:call(event)
            if event.stoped == true then
                break
            end
        end
    end
end

---------------------------------------
-- イベントリスナをすべて削除します.
---------------------------------------
function M:clearEventListeners()
    self.eventlisteners = {}
end

return M