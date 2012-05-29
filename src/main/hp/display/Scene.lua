local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Group = require("hp/display/Group")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local Application = require("hp/Application")

----------------------------------------------------------------
-- Sceneはシーングラフを構築するトップレベルコンテナです.<br>
-- このクラスを使用して、画面を構築します.<br>
-- Sceneのライフサイクルについて<br>
-- 1. onCreate()  ... 生成時に呼ばれます.<br>
-- 2. onStart()   ... 開始時に呼ばれます.<br>
-- 3. onResume()   ... 再開時に呼ばれます.<br>
-- 4. onPause()   ... 一時停止時に呼ばれます.<br>
-- 5. onStop()     ... 終了時に呼ばれます.<br>
-- 6. onDestroy() ... 破棄時に呼ばれます.<br>
-- @class table
-- @name Scene
----------------------------------------------------------------
local M = class(Group, EventDispatcher)

local ENTER_FRAME_EVENT = Event:new("enterFrame")

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:new()
    local obj = Group.new(self, {width = Application.screenWidth, height = Application.screenHeight})
    EventDispatcher.init(obj)
    
    obj.name = ""
    obj.visible = true
    obj.sceneManager = require("hp/manager/SceneManager")
    obj.sceneHandler = {}
    obj.touchDownFlag = false

    --self:setCenterPiv()
    obj:setPiv(Application.screenWidth / 2, Application.screenHeight / 2, 0)
    obj:setLeft(0)
    obj:setTop(0)
    
    return obj
end

----------------------------------------------------------------
-- visibleを設定します.
----------------------------------------------------------------
function M:setVisible(value)
    self.visible = value
    self.sceneManager:updateRender()
end

---------------------------------------
-- シーンを最前面に表示します.
---------------------------------------
function M:orderToFront()
    self.sceneManager:orderToFront(self)
end

---------------------------------------
-- シーンを最背面に表示します.
---------------------------------------
function M:orderToBack()
    self.sceneManager:orderToBack(self)
end

---------------------------------------
-- 描画テーブルを返します.
---------------------------------------
function M:getRenderTable()
    local renderTable = {}
    for i, v in ipairs(self.children) do
        if v.getRenderTable then
            table.insert(renderTable, v:getRenderTable())
        else
            table.insert(renderTable, v)
        end
    end
    return renderTable
end

---------------------------------------
-- シーンの生成処理時に一度だけ呼ばれます.
---------------------------------------
function M:onCreate(params)
    if self.sceneHandler.onCreate then
        self.sceneHandler.onCreate(params)
    end
end

---------------------------------------
-- シーンの開始時に一度だけ呼ばれます.
---------------------------------------
function M:onStart()
    if self.sceneHandler.onStart then
        self.sceneHandler.onStart()
    end
end

---------------------------------------
-- シーンの再開時に呼ばれます.
-- pauseした場合に、再開処理で呼ばれます.
---------------------------------------
function M:onResume()
    if self.sceneHandler.onResume then
        self.sceneHandler.onResume()
    end
end

---------------------------------------
-- シーンの一時停止時に呼ばれます.
---------------------------------------
function M:onPause()
    if self.sceneHandler.onPause then
        self.sceneHandler.onPause()
    end
end

---------------------------------------
-- シーンの停止時に呼ばれます.
-- 停止された後、他シーン遷移が完了した後に
-- onDestoryが呼ばれます.
---------------------------------------
function M:onStop()
    if self.sceneHandler.onStop then
        self.sceneHandler.onStop()
    end
end

---------------------------------------
-- シーンの破棄時に呼ばれます.
-- この時点でシーンは破棄されて使用できなくなります.
---------------------------------------
function M:onDestroy()
    if self.sceneHandler.onDestroy then
        self.sceneHandler.onDestroy()
    end
end

---------------------------------------
-- フレーム毎の処理を行います.
---------------------------------------
function M:onEnterFrame()
    if self.sceneHandler.onEnterFrame then
        self.sceneHandler.onEnterFrame()
    end
    if self:hasEventListener("enterFrame") then
        self:dispatchEvent(ENTER_FRAME_EVENT)
    end
end

---------------------------------------
-- キーボード入力時の処理を行います.
---------------------------------------
function M:onKeyDown(event)
    if self.sceneHandler.onKeyDown then
        self.sceneHandler.onKeyDown(event)
    end
    if self:hasEventListener(Event.KEY_DOWN) then
        self:dispatchEvent(table.copy(event, Event:new()))
    end
end

---------------------------------------
-- キーボード入力時の処理を行います.
---------------------------------------
function M:onKeyUp(event)
    if self.sceneHandler.onKeyUp then
        self.sceneHandler.onKeyUp(event)
    end
    if self:hasEventListener(Event.KEY_UP) then
        self:dispatchEvent(table.copy(event, Event:new()))
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function M:onTouchDown(event)
    self.touchDownFlag = true
    if self.sceneHandler.onTouchDown then
        self.sceneHandler.onTouchDown(event)
    end
    if self:hasEventListener(Event.TOUCH_DOWN) then
        self:dispatchEvent(table.copy(event, Event:new()))
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function M:onTouchUp(event)
    if self.sceneHandler.onTouchUp and self.touchDownFlag then
        self.touchDownFlag = false
        self.sceneHandler.onTouchUp(event)
    end
    if self:hasEventListener(Event.TOUCH_UP) then
        self:dispatchEvent(table.copy(event, Event:new()))
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function M:onTouchMove(event)
    if self.sceneHandler.onTouchMove and self.touchDownFlag then
        self.sceneHandler.onTouchMove(event)
    end
    if self:hasEventListener(Event.TOUCH_MOVE) then
        self:dispatchEvent(table.copy(event, Event:new()))
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function M:onTouchCancel(event)
    if self.sceneHandler.onTouchCancel then
        self.sceneHandler.onTouchCancel(event)
    end
    if self:hasEventListener(Event.TOUCH_CANCEL) then
        self:dispatchEvent(table.copy(event, Event:new()))
    end
end

return M