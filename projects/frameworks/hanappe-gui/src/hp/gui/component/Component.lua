--------------------------------------------------------------------------------
-- 全てのGUIコンポーネントが継承すべきベースクラスです. <br>
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
local FocusManager      = require "hp/gui/manager/FocusManager"

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

-- Layout parameters
M.LAYOUT_MATCH_PARENT = "match_parent"
M.LAYOUT_WARP_CONTENT = "warp_content"

--------------------------------------------------------------------------------
-- コンストラクタです.
-- コンストラクタは継承しないでください.
-- 代わりに、initから始まる関数を継承してください.
--------------------------------------------------------------------------------
function M:init(params)
    super.init(self)
    self:initInternal()
    self:initEventListeners()
    self:initTheme(params)
    self:initComponent()
    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- 内部変数の初期化処理です.
--------------------------------------------------------------------------------
function M:initInternal()
    self._enabled = true
    self._focusEnabled = false
    self._sizeChanged = true
    self._includeLayout = true
    self._theme = nil
    self._themeName = "Component"
    self._currentState = M.STATE_NORMAL
    self._styleChanged = true
    self._layout = nil
    self._layoutChanged = false
    self._layoutWidth = nil
    self._layoutHeight = nil
    self._minWidth = 0
    self._minHeight = 0
    self._maxWidth = nil
    self._maxHeight = nil
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
function M:initTheme(params)
    if params and params.themeName then
        self:setThemeName(params.themeName)
    end
    local theme = ThemeManager:getComponentTheme(self:getThemeName()) or {}
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
    self:updateLayout()
    self:updateSize()
    self:updateDisplay()
end

--------------------------------------------------------------------------------
-- プロパティの更新処理を行います.
-- キャッシュしたプロパティがあればこのタイミングで更新します.
--------------------------------------------------------------------------------
function M:updateProperties()
    if self._styleChanged then
        self:updateStyles()
        self._styleChanged = false
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
    if self._layoutChanged then
        local layout = self:getLayout()
        if layout then
            layout:update(self)
        end
        self:setLayoutChanged(false)
    end
end

--------------------------------------------------------------------------------
-- サイズの更新処理を行います.
-- サイズが変更されると親グループに伝播します.
--------------------------------------------------------------------------------
function M:updateSize()
    if self._sizeChanged then
        local e = Event(M.EVENT_RESIZE)
        e.oldWidth, e.oldHeight = self._oldWidth, self._oldHeight
        e.newWidth, e.newHeight = self:getWidth(), self:getHeight()
        self:dispatchEvent(e)
        
        self._oldWidth = nil
        self._oldHeight = nil
        self._sizeChanged = false
        
        -- サイズが変更された場合、親にレイアウトが変更された事を通知
        local parent = self:getParent()
        if parent and parent.isComponent then
            parent:setLayoutChanged(true)
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
        self._currentState = state
        self._styleChanged = true
        
        local e = Event(M.EVENT_STATE_CHANGED)
        e.state = state
        self:dispatchEvent(e)
    end
end

--------------------------------------------------------------------------------
-- コンポーネントの状態を返します.
--------------------------------------------------------------------------------
function M:getCurrentState()
    return self._currentState
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
    
    -- remove
    if self:getParent() then
        self:getParent():removeChild(self)
    end
    
    -- set
    super.setParent(self, parent)
    
    -- add
    if parent then
        parent:addChild(self)
    end
end

--------------------------------------------------------------------------------
-- 有効かどうか設定します.
--------------------------------------------------------------------------------
function M:setEnabled(value)
    if self:isEnabled() ~= value then
        self._enabled = value
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
    return self._enabled
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
    return FocusManager
end

--------------------------------------------------------------------------------
-- フォーカスがセットできるか返します.
--------------------------------------------------------------------------------
function M:isFocusEnabled()
    return self._focusEnabled
end

--------------------------------------------------------------------------------
-- フォーカスがセットできるか設定します.
--------------------------------------------------------------------------------
function M:setFocusEnabled(value)
    self._focusEnabled = value
    
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
    self._layout = value
    self:setLayoutChanged(true)
end

--------------------------------------------------------------------------------
-- レイアウトを返します.
--------------------------------------------------------------------------------
function M:getLayout()
    return self._layout
end

--------------------------------------------------------------------------------
-- レイアウトが変更されたかどうか設定します.
-- trueの場合、親コンポーネントにも伝播します.
--------------------------------------------------------------------------------
function M:setLayoutChanged(value)
    self._layoutChanged = value
    local parent = self:getParent()
    if value and parent and parent.isComponent then
        parent:setLayoutChanged(true)
    end
end

--------------------------------------------------------------------------------
-- レイアウトが変更されたかどうか返します.
--------------------------------------------------------------------------------
function M:isLayoutChanged()
    return self._layoutChanged
end

--------------------------------------------------------------------------------
-- レイアウトクラスによってレイアウトがセットされるかどうか設定します.
--------------------------------------------------------------------------------
function M:setIncludeLayout(value)
    self._includeLayout = value
    local parent = self:getParent()
    if parent and parent.isComponent then
        parent:setLayoutChanged(true)
    end
end

--------------------------------------------------------------------------------
-- 自動的にレイアウトを設定するかどうか返します.
--------------------------------------------------------------------------------
function M:isIncludeLayout()
    self._includeLayout = value
end

--------------------------------------------------------------------------------
-- コンポーネントのサイズを変更します.
-- 変更した直後に全てのオブジェクトに反映されるわけではなく、updateSize関数で反映されます.
-- また、最小、最大サイズの範囲外を指定した場合は、その時点でサイズが調整されます.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    if self._minWidth and width < self._minWidth then
        width = self._minWidth
    end
    if self._minHeight and height < self._minHeight then
        height = self._minHeight
    end
    if self._maxWidth and width > self._maxWidth then
        width = self._maxWidth
    end
    if self._maxHeight and height > self._maxHeight then
        height = self._maxHeight
    end

    local oldWidth, oldHeight =  self:getWidth(), self:getHeight()
    
    if oldWidth ~= width or oldHeight ~= height then
        super.setSize(self, width, height)

        if not self._sizeChanged then
            self._oldWidth = oldWidth
            self._oldHeight = oldHeight
            self._sizeChanged = true
        end
    end
end

--------------------------------------------------------------------------------
-- Layoutクラスによって考慮されるサイズを設定します.
-- Layoutクラスを設定しない場合はこのプロパティは使用されません.
--------------------------------------------------------------------------------
function M:setLayoutSize(width, height)
    self._layoutWidth = width
    self._layoutHeight = height
    self:setLayoutChanged(true)
end

--------------------------------------------------------------------------------
-- Layoutクラスによって考慮されるサイズを返します.
--------------------------------------------------------------------------------
function M:getLayoutSize()
    return self._layoutWidth, self._layoutHeight
end

--------------------------------------------------------------------------------
-- Layoutクラスによって考慮されるサイズを設定します.
-- Layoutクラスを設定しない場合はこのプロパティは使用されません.
--------------------------------------------------------------------------------
function M:setLayoutWidth(width)
    self:setLayoutSize(width, self:getLayoutHeight())
end

--------------------------------------------------------------------------------
-- Layoutクラスによって考慮されるサイズを返します.
--------------------------------------------------------------------------------
function M:getLayoutWidth()
    return self._layoutWidth
end

--------------------------------------------------------------------------------
-- Layoutクラスによって考慮されるサイズを設定します.
-- Layoutクラスを設定しない場合はこのプロパティは使用されません.
--------------------------------------------------------------------------------
function M:setLayoutHeight(height)
    self:setLayoutSize(self:getLayoutWidth(), height)
end

--------------------------------------------------------------------------------
-- Layoutクラスによって考慮されるサイズを返します.
--------------------------------------------------------------------------------
function M:getLayoutHeight()
    return self._layoutHeight
end

--------------------------------------------------------------------------------
-- コンポーネントの最小サイズを設定します.
--------------------------------------------------------------------------------
function M:setMinSize(width, height)
    self._minWidth = width
    self._minHeight = height
    
    self:setSize(self:getSize())
end

--------------------------------------------------------------------------------
-- コンポーネントの最小サイズを返します.
--------------------------------------------------------------------------------
function M:getMinSize()
    return self._minWidth, self._minHeight
end


--------------------------------------------------------------------------------
-- コンポーネントの最小サイズを設定します.
--------------------------------------------------------------------------------
function M:setMinWidth(width)
    self:setMinSize(width, self:getMinHeight())
end

--------------------------------------------------------------------------------
-- コンポーネントの最小サイズを返します.
--------------------------------------------------------------------------------
function M:getMinWidth()
    return self._minWidth
end

--------------------------------------------------------------------------------
-- コンポーネントの最小サイズを設定します.
--------------------------------------------------------------------------------
function M:setMinHeight(height)
    self:setMinSize(self:getMinWidth(), height)
end

--------------------------------------------------------------------------------
-- コンポーネントの最小サイズを返します.
--------------------------------------------------------------------------------
function M:getMinHeight()
    return self._minHeight
end

--------------------------------------------------------------------------------
-- コンポーネントの最大サイズを設定します.
--------------------------------------------------------------------------------
function M:setMaxSize(width, height)
    self._maxWidth = width
    self._maxHeight = height
    
    self:setSize(self:getSize())
end

--------------------------------------------------------------------------------
-- コンポーネントの最大サイズを返します.
--------------------------------------------------------------------------------
function M:getMaxSize()
    return self._maxWidth, self._maxHeight
end

--------------------------------------------------------------------------------
-- コンポーネントの最大サイズを設定します.
--------------------------------------------------------------------------------
function M:setMaxWidth(width)
    self:setMaxSize(width, self:getMaxHeight())
end

--------------------------------------------------------------------------------
-- コンポーネントの最大サイズを返します.
--------------------------------------------------------------------------------
function M:getMaxWidth()
    return self._maxWidth
end

--------------------------------------------------------------------------------
-- コンポーネントの最大サイズを設定します.
--------------------------------------------------------------------------------
function M:setMaxHeight(height)
    self:setMaxSize(self:getMaxWidth(), height)
end

--------------------------------------------------------------------------------
-- コンポーネントの最大サイズを返します.
--------------------------------------------------------------------------------
function M:getMaxHeight()
    return self._maxHeight
end

--------------------------------------------------------------------------------
-- コンポーネントのテーマを返します.
--------------------------------------------------------------------------------
function M:getTheme()
    return self._theme
end

--------------------------------------------------------------------------------
-- コンポーネントのテーマを設定します.
-- ThemeManagerによってデフォルトのテーマが設定されています.
--------------------------------------------------------------------------------
function M:setTheme(value)
    if self._theme ~= value then
        self._theme = value
        self._styleChanged = true
    end
end

--------------------------------------------------------------------------------
-- コンポーネントのテーマ名を返します.
--------------------------------------------------------------------------------
function M:getThemeName()
    return self._themeName
end

--------------------------------------------------------------------------------
-- コンポーネントのテーマ名を設定します.
--------------------------------------------------------------------------------
function M:setThemeName(value)
    if self._themeName ~= value then
        self._themeName = value
        self._styleChanged = true
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
-- ボタンを押下したときのイベントリスナを設定します.
--------------------------------------------------------------------------------
function M:setEventListener(eventName, func)
    local propertyName = "_event_" .. eventName

    if self[propertyName] == func then
        return
    end
    
    if self[propertyName] then
        self:removeEventListener(eventName, self[propertyName])
    end

    self[propertyName] = func
    
    if self[propertyName] then
        self:addEventListener(eventName, self[propertyName])
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