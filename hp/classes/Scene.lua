----------------------------------------------------------------
-- Sceneはシーングラフを構築するトップレベルコンテナです.<br>
-- Sceneは複数のLayerを管理します.<br>
-- このクラスを使用して、画面を構築します.<br>
-- <br>
-- デフォルトのレイヤー（topLayer）を持ちます.<br>
-- DisplayObjectの親に直接指定された場合、実際に追加される先はtopLayerになります.<br>
-- <br>
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
local M = {}
local I = {}
local table = require("hp/lang/table")
local Application = require("hp/Application")
local Group = require("hp/classes/Group")

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:new()
    local self = Group:new({width = Application.screenWidth, height = Application.screenHeight})
    self.name = ""
    self.visible = true
    self.sceneManager = require("hp/classes/SceneManager")
    self.sceneHandler = {}
    self.touchDownFlag = false

    --self:setCenterPiv()
    self:setPiv(Application.screenWidth / 2, Application.screenHeight / 2, 0)
    self:setLeft(0)
    self:setTop(0)
    
    return table.copy(I, self)
end

----------------------------------------------------------------
-- visibleを設定します.
----------------------------------------------------------------
function I:setVisible(value)
    self.visible = value
    self.sceneManager:updateRender()
end

---------------------------------------
-- シーンを最前面に表示します.
---------------------------------------
function I:orderToFront()
    self.sceneManager:orderToFront(self)
end

---------------------------------------
-- シーンを最背面に表示します.
---------------------------------------
function I:orderToBack()
    self.sceneManager:orderToBack(self)
end

---------------------------------------
-- 描画テーブルを返します.
---------------------------------------
function I:getRenderTable()
    return self.children
end

---------------------------------------
-- シーンの生成処理時に一度だけ呼ばれます.
---------------------------------------
function I:onCreate(params)
    if self.sceneHandler.onCreate then
        self.sceneHandler.onCreate(params)
    end
end

---------------------------------------
-- シーンの開始時に一度だけ呼ばれます.
---------------------------------------
function I:onStart(params)
    if self.sceneHandler.onStart then
        self.sceneHandler.onStart(params)
    end
end

---------------------------------------
-- シーンの再開時に呼ばれます.
-- pauseした場合に、再開処理で呼ばれます.
---------------------------------------
function I:onResume(params)
    if self.sceneHandler.onResume then
        self.sceneHandler.onResume(params)
    end
end

---------------------------------------
-- シーンの一時停止時に呼ばれます.
---------------------------------------
function I:onPause()
    if self.sceneHandler.onPause then
        self.sceneHandler.onPause()
    end
end

---------------------------------------
-- シーンの停止時に呼ばれます.
-- 停止された後、他シーン遷移が完了した後に
-- onDestoryが呼ばれます.
---------------------------------------
function I:onStop()
    if self.sceneHandler.onStop then
        self.sceneHandler.onStop()
    end
end

---------------------------------------
-- シーンの破棄時に呼ばれます.
-- この時点でシーンは破棄されて使用できなくなります.
---------------------------------------
function I:onDestroy()
    if self.sceneHandler.onDestroy then
        self.sceneHandler.onDestroy()
    end
end

---------------------------------------
-- フレーム毎の処理を行います.
---------------------------------------
function I:onEnterFrame()
    if self.sceneHandler.onEnterFrame then
        self.sceneHandler.onEnterFrame()
    end
end

---------------------------------------
-- キーボード入力時の処理を行います.
---------------------------------------
function I:onKeyDown(event)
    if self.sceneHandler.onKeyDown then
        self.sceneHandler.onKeyDown(event)
    end
end

---------------------------------------
-- キーボード入力時の処理を行います.
---------------------------------------
function I:onKeyUp(event)
    if self.sceneHandler.onKeyUp then
        self.sceneHandler.onKeyUp(event)
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function I:onTouchDown(event)
    self.touchDownFlag = true
    if self.sceneHandler.onTouchDown then
        self.sceneHandler.onTouchDown(event)
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function I:onTouchUp(event)
    self.touchDownFlag = false
    if self.sceneHandler.onTouchUp then
        self.sceneHandler.onTouchUp(event)
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function I:onTouchMove(event)
    if self.sceneHandler.onTouchMove and self.touchDownFlag then
        self.sceneHandler.onTouchMove(event)
    end
end

---------------------------------------
-- 画面をタッチした時のイベント処理です.
---------------------------------------
function I:onSceneTouchCancel(event)
    if self.sceneHandler.onSceneTouchCancel then
        self.sceneHandler.onSceneTouchCancel(event)
    end
end

return M