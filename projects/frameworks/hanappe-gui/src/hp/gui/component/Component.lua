--------------------------------------------------------------------------------
-- 全てのComponentが継承すべきクラスです. <br>
-- GUIの基本となる機能を提供します. <br>
-- @class table
-- @name Component
--------------------------------------------------------------------------------

-- imports
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Group             = require "hp/display/Group"
local Event             = require "hp/event/Event"
local Executors         = require "hp/util/Executors"
local ThemeManager      = require "hp/gui/manager/ThemeManager"

-- class define
local M                 = class(Group)
local super             = Group
local MOAIPropInterface = MOAIProp.getInterfaceTable()

-- Events
M.EVENT_TOUCH_DOWN      = "touchDown"
M.EVENT_TOUCH_MOVE      = "touchMove"
M.EVENT_TOUCH_CANCEL    = "touchCancel"
M.EVENT_TOUCH_UP        = "touchUp"
M.EVENT_KEY_DOWN        = "keyDown"
M.EVENT_KEY_UP          = "keyUp"
M.EVENT_RESIZE          = "resize"
M.EVENT_FOCUS_IN        = "focusIn"
M.EVENT_FOCUS_OUT       = "focusOut"
M.EVENT_ENABLED_CHANGED = "enabledChanged"
M.EVENT_STATE_CHANGED   = "stateChanged"
M.EVENT_ADDED           = "added"
M.EVENT_REMOVED         = "removed"
M.EVENT_CHILD_ADDED     = "childAdded"
M.EVENT_CHILD_REMOVED   = "childRemoved"

-- States
M.STATE_NORMAL          = "normal"
M.STATE_DISABLED        = "disabled"

--------------------------------------------------------------------------------
-- コンストラクタです.
-- コンストラクタは継承しないでください.
-- 代わりに、initから始まる関数を継承してください.
--------------------------------------------------------------------------------
function M:init(params)
    super.init(self)
    self:initInternal()
    self:initEventListeners()
    self:initTheme(params and params.theme)
    self:initComponent()
    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- 内部変数の初期化処理です.
--------------------------------------------------------------------------------
function M:initInternal()
    self.__internal.enabled = true
    self.__internal.focusEnabled = false
    self.__internal.sizeChanged = true
    self.__internal.includeLayout = true
    self.__internal.theme = nil
    self.__internal.themeName = "Component"
    self.__internal.currentState = M.STATE_NORMAL
    self.__internal.styleChanged = true
    self.__internal.layout = nil
    self.__internal.layoutChanged = false
end

--------------------------------------------------------------------------------
-- イベントリスナの初期化処理を行います.
--------------------------------------------------------------------------------
function M:initEventListeners()
    self:addEventListener(M.EVENT_TOUCH_DOWN, self.touchDownHandler, self)
    self:addEventListener(M.EVENT_TOUCH_MOVE, self.touchMoveHandler, self)
    self:addEventListener(M.EVENT_TOUCH_CANCEL, self.touchCancelHandler, self)
    self:addEventListener(M.EVENT_TOUCH_UP, self.touchUpHandler, self)
    self:addEventListener(M.EVENT_KEY_DOWN, self.keyDownHandler, self)
    self:addEventListener(M.EVENT_KEY_UP, self.keyUpHandler, self)
    self:addEventListener(M.EVENT_RESIZE, self.resizeHandler, self)
    self:addEventListener(M.EVENT_FOCUS_IN, self.focusInHandler, self)
    self:addEventListener(M.EVENT_FOCUS_OUT, self.focusOutHandler, self)
    self:addEventListener(M.EVENT_STATE_CHANGED, self.stateChangedHandler, self)
    self:addEventListener(M.EVENT_ENABLED_CHANGED, self.enabledChangedHandler, self)
end

--------------------------------------------------------------------------------
-- テーマの初期化処理です.
--------------------------------------------------------------------------------
function M:initTheme(theme)
    local theme = theme or ThemeManager:getComponentTheme(self:getThemeName()) or {}
    self:setTheme(theme)
end

--------------------------------------------------------------------------------
-- コンポーネントの初期化処理を行います.
--------------------------------------------------------------------------------
function M:initComponent()
    self:createChildren()
end

--------------------------------------------------------------------------------
-- 子コンポーネントの生成処理を行います.
-- コンポーネントを実装するクラスは必要に応じてオーバーライドしてください.
--------------------------------------------------------------------------------
function M:createChildren()
end

--------------------------------------------------------------------------------
-- 子コンポーネントを追加します.
--------------------------------------------------------------------------------
function M:addChild(child)
    if super.addChild(self, child) then
        self:setLayoutChanged(true)
        child:dispatchEvent(M.EVENT_ADDED)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- 子コンポーネントを追加します.
-- Componentだけが追加できるようにします.
--------------------------------------------------------------------------------
function M:removeChild(child)
    if super.removeChild(self, child) then
        self:setLayoutChanged(true)
        child:dispatchEvent(M.EVENT_REMOVED)
    end
end


--------------------------------------------------------------------------------
-- コンポーネントの更新処理を行います.
-- 各フレーム毎に呼び出されます.
--------------------------------------------------------------------------------
function M:updateComponent()
    self:updateProperties()
    self:updateChildren()
    self:updateSize()
    self:updateLayout()
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- プロパティの更新処理を行います.
-- キャッシュしたプロパティがあればこのタイミングで更新します.
--------------------------------------------------------------------------------
function M:updateProperties()
    if self.__internal.styleChanged then
        self:updateStyles()
        self.__internal.styleChanged = false
    end
end

--------------------------------------------------------------------------------
-- スタイルが変更された時の更新を行います.
--------------------------------------------------------------------------------
function M:updateStyles()

end

--------------------------------------------------------------------------------
-- 子コンポーネントを更新します.
--------------------------------------------------------------------------------
function M:updateChildren()
    for i, child in ipairs(self:getChildren()) do
        if child.isComponent then
            child:updateComponent()
        end
    end
end

--------------------------------------------------------------------------------
-- 子コンポーネントのレイアウトを更新します.
--------------------------------------------------------------------------------
function M:updateLayout()
    if self.__internal.layoutChanged then
        local layout = self:getLayout()
        if layout then
            layout:update(self)
        end
        self:setLayoutChanged(self)
    end
end

--------------------------------------------------------------------------------
-- サイズの更新処理を行います.
-- サイズが変更されると親グループに伝播します.
--------------------------------------------------------------------------------
function M:updateSize()
    if self.__internal.sizeChanged then
        local e = Event(M.EVENT_RESIZE)
        e.oldWidth, e.oldHeight = self.__internal.oldWidth, self.__internal.oldHeight
        e.newWidth, e.newHeight = width, height
        self:dispatchEvent(e)
        
        self.__internal.oldWidth = nil
        self.__internal.oldHeight = nil
        self.__internal.sizeChanged = false
        
        -- サイズが変更された場合、親にレイアウトが変更された事を通知
        if self:getParent() then
            self:getParent():setLayoutChanged(true)
        end
    end
end

--------------------------------------------------------------------------------
-- 表示オブジェクトの更新処理を行います.
-- 必要に応じて継承してください.
--------------------------------------------------------------------------------
function M:updateDisplay()
end

--------------------------------------------------------------------------------
-- コンポーネントの状態を設定します.
--------------------------------------------------------------------------------
function M:setCurrentState(state)
    if self:getCurrentState() ~= state then
        self.__internal.currentState = state
        self.__internal.styleChanged = true
        
        local e = Event(M.EVENT_STATE_CHANGED)
        e.state = state
        self:dispatchEvent(e)
    end
end

--------------------------------------------------------------------------------
-- コンポーネントの状態を返します.
--------------------------------------------------------------------------------
function M:getCurrentState()
    return self.__internal.currentState
end

--------------------------------------------------------------------------------
-- フォーカスを描画します.
--------------------------------------------------------------------------------
function M:drawfocus(focused)
    -- TODO
end

--------------------------------------------------------------------------------
-- 関数の遅延コールを行います.
-- 内部的にはExecutors.callLater関数を呼び出すだけです.
--------------------------------------------------------------------------------
function M:callLater(func, ...)
    Executors.callLater(func, ...)
end

--------------------------------------------------------------------------------
-- Properties
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 親コンポーネントを設定します.
-- 親コンポーネントは、Componentを継承したクラスでなければなりません.
--------------------------------------------------------------------------------
function M:setParent(parent)
    if parent == self:getParent() then
        return
    end
    if parent and not parent.isComponent then
        error("Not Component Excption!")
    end
    
    -- remove
    if self:getParent() then
        self:getParent():removeChild(self)
    end
    
    -- set
    self.__internal.parent = parent
    MOAIPropInterface.setParent(self, parent)
    
    -- add
    if parent then
        parent:addChild(self)
    end
end

--------------------------------------------------------------------------------
-- 親を返します.
--------------------------------------------------------------------------------
function M:getParent()
    return self.__internal.parent
end

--------------------------------------------------------------------------------
-- 有効かどうか設定します.
--------------------------------------------------------------------------------
function M:setEnabled(value)
    if self:isEnabled() ~= value then
        self.__internal.enabled = value
        self:dispatchEvent(M.EVENT_ENABLED_CHANGED)
        
        if value then
            self:setCurrentState(M.STATE_NORMAL)
        else
            self:setCurrentState(M.STATE_DISABLED)
        end
    end
end

--------------------------------------------------------------------------------
-- 有効かどうか返します.
--------------------------------------------------------------------------------
function M:isEnabled()
    return self.__internal.enabled
end

--------------------------------------------------------------------------------
-- フォーカスをセットします.
--------------------------------------------------------------------------------
function M:setFocus(value)
    value = value or true
    
    local focusManager = self:getFocusManager()
    if focusManager then
        focusManager:setFocus(value and self or nil)
    end
end

--------------------------------------------------------------------------------
-- フォーカスがあたっているか返します.
--------------------------------------------------------------------------------
function M:isFocus()
    local focusManager = self:getFocusManager()
    if focusManager then
        return focusManager:getFocus() == self
    end
    return false
end

--------------------------------------------------------------------------------
-- FocusManagerを返します.
-- 基本的にUILayerに紐付くマネージャを返されます.
--------------------------------------------------------------------------------
function M:getFocusManager()
    if self.__internal.focusManager then
        return self.__internal.focusManager
    end
    if self:getParent() then
        return self:getParent():getFocusManager()
    end
    return nil
end

--------------------------------------------------------------------------------
-- フォーカスがセットできるか返します.
--------------------------------------------------------------------------------
function M:isFocusEnabled()
    return self.__internal.focusEnabled
end

--------------------------------------------------------------------------------
-- フォーカスがセットできるか設定します.
--------------------------------------------------------------------------------
function M:setFocusEnabled(value)
    self.__internal.focusEnabled = value
    
    if value == false and self:isFocus() then
        self:getFocusManager():setFocus(nil)
    end
end

--------------------------------------------------------------------------------
-- レイアウトを設定します.
-- レイアウトを設定すると、サイズ変更時にレイアウトクラスの更新処理が呼ばれて、
-- 自動的にコンポーネントの座標を設定されるようになります.
--------------------------------------------------------------------------------
function M:setLayout(value)
    self.__internal.layout = value
    self:setLayoutChanged(true)
end

--------------------------------------------------------------------------------
-- レイアウトを返します.
--------------------------------------------------------------------------------
function M:getLayout()
    return self.__internal.layout
end

--------------------------------------------------------------------------------
-- レイアウトが変更されたかどうか設定します.
-- trueの場合、親コンポーネントにも伝播します.
--------------------------------------------------------------------------------
function M:setLayoutChanged(value)
    self.__internal.layoutChanged = value
    if value and self:getParent() then
        self:getParent():setLayoutChanged(true)
    end
end

--------------------------------------------------------------------------------
-- レイアウトが変更されたかどうか返します.
--------------------------------------------------------------------------------
function M:isLayoutChanged()
    return self.__internal.layoutChanged
end

--------------------------------------------------------------------------------
-- レイアウトクラスによってレイアウトがセットされるかどうか設定します.
--------------------------------------------------------------------------------
function M:setIncludeLayout(value)
    self.__internal.includeLayout = value
    if self:getParent() then
        self:getParent():setLayoutChanged(true)
    end
end

--------------------------------------------------------------------------------
-- 自動的にレイアウトを設定するかどうか返します.
--------------------------------------------------------------------------------
function M:isIncludeLayout()
    self.__internal.includeLayout = value
end

--------------------------------------------------------------------------------
-- コンポーネントのサイズを変更します.
-- 変更した直後に反映されるわけではなく、updateSize関数で反映されます.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    local oldWidth, oldHeight =  self:getWidth(), self:getHeight()
    
    if oldWidth ~= width or oldHeight ~= height then
        super.setSize(self, width, height)

        if not self.__internal.sizeChanged then
            self.__internal.oldWidth = oldWidth
            self.__internal.oldHeight = oldHeight
            self.__internal.sizeChanged = true
        end
    end
end

--------------------------------------------------------------------------------
-- コンポーネントのテーマを返します.
--------------------------------------------------------------------------------
function M:getTheme()
    return self.__internal.theme
end

--------------------------------------------------------------------------------
-- コンポーネントのテーマを設定します.
-- ThemeManagerによってデフォルトのテーマが設定されています.
--------------------------------------------------------------------------------
function M:setTheme(value)
    if self.__internal.theme ~= value then
        self.__internal.theme = value
        self.__internal.styleChanged = true
    end
end

--------------------------------------------------------------------------------
-- コンポーネントのテーマ名を返します.
--------------------------------------------------------------------------------
function M:getThemeName()
    return self.__internal.themeName
end

--------------------------------------------------------------------------------
-- コンポーネントのテーマ名を設定します.
--------------------------------------------------------------------------------
function M:setThemeName(value)
    if self.__internal.themeName ~= value then
        self.__internal.themeName = value
        self.__internal.styleChanged = true
    end
end

--------------------------------------------------------------------------------
-- コンポーネントの共通テーマを設定します.
--------------------------------------------------------------------------------
function M:getStyle(name, state)
    state = state or self:getCurrentState()
    
    local theme = self:getTheme()
    local currentStyles = theme[state]
    local normalStyles = theme["normal"]
    
    if currentStyles and currentStyles[name] ~= nil then
        return currentStyles[name]
    end
    if normalStyles and normalStyles[name] ~= nil then
        return normalStyles[name]
    end
    
end

--------------------------------------------------------------------------------
-- コンポーネントかどうか返します.
-- 基本的に必ずtrueを返します.
--------------------------------------------------------------------------------
function M:isComponent()
    return true
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
end

--------------------------------------------------------------------------------
-- キーダウン時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:keyDownHandler(e)
end

--------------------------------------------------------------------------------
-- キーアップ時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:keyUpHandler(e)
end

--------------------------------------------------------------------------------
-- フォーカスイン時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:focusInHandler(e)
end

--------------------------------------------------------------------------------
-- フォーカスアウト時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:focusOutHandler(e)
end

--------------------------------------------------------------------------------
-- リサイズ時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:resizeHandler(e)
end

--------------------------------------------------------------------------------
-- ステート変更時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:stateChangedHandler(e)
end

--------------------------------------------------------------------------------
-- コンポーネントの有効状態変更時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:enabledChangedHandler(e)
end
    
return M