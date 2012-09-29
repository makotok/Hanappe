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
local ThemeManager      = require "hp/manager/ThemeManager"
local FocusManager      = require "hp/manager/FocusManager"

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
    self:initComponent(params)
    self:updateComponent()
end

--------------------------------------------------------------------------------
-- 内部変数の初期化処理です.
--------------------------------------------------------------------------------
function M:initInternal()
    self._enabled = true
    self._theme = nil
    self._themeName = "Component"
    self._styles = {}
    self._layout = nil
    self._includeLayout = true
    self._initialized = false
    self._invalidDisplayFlag = true
    self._invalidLayoutFlag = true
    self._currentState = M.STATE_NORMAL
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
    self:addEventListener(M.EVENT_STATE_CHANGED, self.stateChangedHandler, self)
    self:addEventListener(M.EVENT_ENABLED_CHANGED, self.enabledChangedHandler, self)
end

--------------------------------------------------------------------------------
-- コンポーネントの初期化処理を行います.
--------------------------------------------------------------------------------
function M:initComponent(params)
    self:initTheme(params)
    self:initStyles(params)
    self:createChildren()
    self:copyParams(params)

    self._initialized = true
end

--------------------------------------------------------------------------------
-- テーマの初期化処理です.
--------------------------------------------------------------------------------
function M:initTheme(params)
    if params and params.themeName then
        if type(params.themeName) == "table" then
            self:setThemeName(unpack(params.themeName))
        else
            self:setThemeName(params.themeName)
        end
    end
    local theme = ThemeManager:getComponentTheme(self:getThemeName()) or {}
    self:setTheme(theme)
end

--------------------------------------------------------------------------------
-- コンポーネント固有のスタイル初期化処理です.
--------------------------------------------------------------------------------
function M:initStyles(params)
    if params and params.styles then
        if type(params.styles) == "table" then
            self:setStyles(unpack(params.styles))
        else
            self:setStyles(params.styles)
        end
    end
end

--------------------------------------------------------------------------------
-- 子コンポーネントの生成処理を行います.
-- コンポーネントを実装するクラスは必要に応じてオーバーライドしてください.
--------------------------------------------------------------------------------
function M:createChildren()
end

--------------------------------------------------------------------------------
-- フレーム処理を行います.
-- 親のコンポーネントから順にenterFrame関数が呼ばれます.
--------------------------------------------------------------------------------
function M:enterFrame()
    for i, child in ipairs(self:getChildren()) do
        if child.isComponent then
            child:enterFrame()
        end
    end
    self:validateAll()
end

--------------------------------------------------------------------------------
-- 表示、レイアウトの更新処理をスケジューリングします.
--------------------------------------------------------------------------------
function M:invalidateAll()
    self:invalidateDisplay()
    self:invalidateLayout()
end

--------------------------------------------------------------------------------
-- 表示処理を予約します.
-- この関数を呼び出すと、フレーム更新時にvalidateDisplay関数が呼ばれます.
--------------------------------------------------------------------------------
function M:invalidateDisplay()
    self._invalidDisplayFlag = true
end

--------------------------------------------------------------------------------
-- レイアウト処理を予約します.
-- この関数を呼び出すと、フレーム更新時にvalidateLayout関数が呼ばれます.
--------------------------------------------------------------------------------
function M:invalidateLayout()
    self._invalidLayoutFlag = true
    
    local parent = self:getParent()
    if parent and parent.invalidateLayout then
        parent:invalidateLayout()
    end
end

--------------------------------------------------------------------------------
-- 無効化された表示、レイアウトの状態を有効にします.
--------------------------------------------------------------------------------
function M:validateAll()
    self:validateDisplay()
    self:validateLayout()
end

--------------------------------------------------------------------------------
-- 表示が無効化されていた場合に更新処理を行います.
--------------------------------------------------------------------------------
function M:validateDisplay()
    if self._invalidDisplayFlag then
        self:updateDisplay()
        self._invalidDisplayFlag = false
    end
end

--------------------------------------------------------------------------------
-- レイアウトが無効化されていた場合に更新処理を行います.
--------------------------------------------------------------------------------
function M:validateLayout()
    if self._invalidLayoutFlag then
        self:updateLayout()
        self._invalidLayoutFlag = false
    end
end

--------------------------------------------------------------------------------
-- コンポーネントの全ての状態を更新します.
-- この処理はコストが高い場合が多いので、できるだけ呼ばないようにしてください.
--------------------------------------------------------------------------------
function M:updateComponent()
    self:updateDisplay()
    self:updateLayout()
end

--------------------------------------------------------------------------------
-- コンポーネントの表示を更新します.
-- コンポーネントの実装者は、このメソッドで表示の更新処理を実装してください.
--------------------------------------------------------------------------------
function M:updateDisplay()

end

--------------------------------------------------------------------------------
-- レイアウトを更新します.
--------------------------------------------------------------------------------
function M:updateLayout()
    if self._layout then
        self._layout:update(self)
    end
end

--------------------------------------------------------------------------------
-- 子コンポーネントを追加します.
--------------------------------------------------------------------------------
function M:addChild(child)
    if super.addChild(self, child) then
        child:dispatchEvent(M.EVENT_ADDED)
        self:dispatchEvent(M.EVENT_CHILD_ADDED)
        self:invalidateLayout()
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
        child:dispatchEvent(M.EVENT_REMOVED)
        self:dispatchEvent(M.EVENT_CHILD_REMOVED)
        self:invalidateLayout()
    end
end

--------------------------------------------------------------------------------
-- コンポーネントの状態を設定します.
--------------------------------------------------------------------------------
function M:setCurrentState(state)
    if self:getCurrentState() ~= state then
        self._currentState = state
        
        local e = Event(M.EVENT_STATE_CHANGED)
        e.state = state
        self:dispatchEvent(e)
        
        self:invalidateDisplay()
    end
end

--------------------------------------------------------------------------------
-- コンポーネントの状態を返します.
--------------------------------------------------------------------------------
function M:getCurrentState()
    return self._currentState
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
        
        self:invalidateDisplay()
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
    self:invalidateLayout()
end

--------------------------------------------------------------------------------
-- レイアウトを返します.
--------------------------------------------------------------------------------
function M:getLayout()
    return self._layout
end

--------------------------------------------------------------------------------
-- レイアウトクラスによってレイアウトがセットされるかどうか設定します.
--------------------------------------------------------------------------------
function M:setIncludeLayout(value)
    self._includeLayout = value
    self:invalidateLayout()
end

--------------------------------------------------------------------------------
-- 自動的にレイアウトを設定するかどうか返します.
--------------------------------------------------------------------------------
function M:isIncludeLayout()
    return self._includeLayout
end

--------------------------------------------------------------------------------
-- コンポーネントのサイズを変更します.
-- 変更した直後に全てのオブジェクトに反映されるわけではなく、updateSize関数で反映されます.
-- また、最小、最大サイズの範囲外を指定した場合は、その時点でサイズが調整されます.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    width  = width  < 0 and 0 or width
    height = height < 0 and 0 or height

    local oldWidth, oldHeight =  self:getWidth(), self:getHeight()
    
    if oldWidth ~= width or oldHeight ~= height then
        super.setSize(self, width, height)

        local e = Event(M.EVENT_RESIZE)
        e.oldWidth, e.oldHeight = oldWidth, oldHeight
        e.newWidth, e.newHeight = width, height
        self:dispatchEvent(e)
        
        self:invalidateDisplay()
        self:invalidateLayout()
    end
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
        self:invalidateDisplay()
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
    end
end

--------------------------------------------------------------------------------
-- コンポーネントが持つ全スタイルを設定します.
--------------------------------------------------------------------------------
function M:setStyles(styles)
    if self._styles ~= styles then
        self._styles = assert(styles)
        self:invalidateDisplay()
    end
end

--------------------------------------------------------------------------------
-- コンポーネントの現在のステートスタイルを返します.
--------------------------------------------------------------------------------
function M:getStyle(name, state)
    state = state or self:getCurrentState()
    
    local theme = self:getTheme()
    local componentStyles = self._styles[state]
    local currentStyles = theme[state]
    local normalStyles = theme["normal"]
    
    if componentStyles and componentStyles[name] ~= nil then
        return componentStyles[name]
    end
    if currentStyles and currentStyles[name] ~= nil then
        return currentStyles[name]
    end
    if normalStyles and normalStyles[name] ~= nil then
        return normalStyles[name]
    end
end

--------------------------------------------------------------------------------
-- コンポーネントのスタイルを設定します.
--------------------------------------------------------------------------------
function M:setStyle(state, name, value)
    if self._styles[state] then
        self._styles[state] = {}
    end
    local stateStyles = self._styles[state]
    stateStyles[name] = value
    
    self:invalidateDisplay()
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