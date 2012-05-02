local class = require("hp/lang/class")
local MOAIPropUtil = require("hp/util/MOAIPropUtil")

----------------------------------------------------------------
-- ツゥイーンアニメーションする為のクラスです.
-- 移動、回転、拡大や、フレームアニメーションに対応します.
--
-- @class table
-- @name Animation
----------------------------------------------------------------
local M = class()

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(targets, sec, easeType)
    self.internal = {
        commands = {},
        targets = targets or {},
        running = false,
        second = sec and sec or 1,
        easeType = easeType,
        currentCommand = nil,
        currentIndex = 0,
        running = false,
    }
end

---------------------------------------
-- アニメーション中かどうか返します.
---------------------------------------
function M:isRunning()
    return self.internal.running
end

---------------------------------------
-- 対象オブジェクトを移動させます.
---------------------------------------
function M:setLeft(left)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            MOAIPropUtil.setLeft(v, left)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを移動させます.
---------------------------------------
function M:setTop(top)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            MOAIPropUtil.setTop(v, top)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを移動させます.
---------------------------------------
function M:setRight(right)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            MOAIPropUtil.setRight(v, right)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを移動させます.
---------------------------------------
function M:setBottom(bottom)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            MOAIPropUtil.setBottom(v, bottom)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを移動させます.
---------------------------------------
function M:setLoc(x, y, z)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            v:setLoc(x, y, z)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを移動させます.
---------------------------------------
function M:moveLoc(moveX, moveY, moveZ, sec, mode)
    local actionFunc = function(target, tSec, tMode)
        return target:moveLoc(moveX, moveY, moveZ, tSec, tMode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを移動させます.
---------------------------------------
function M:seekLoc(moveX, moveY, moveZ, sec, mode)
    local actionFunc = function(target, tSec, tMode)
        return target:seekLoc(moveX, moveY, moveZ, tSec, tMode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを移動させます.
---------------------------------------
function M:setRot(x, y, z)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            v:setRot(x, y, z)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを回転させます.
---------------------------------------
function M:moveRot(rx, ry, rz, sec, mode)
    local actionFunc = function(target, tSec, tMode)
        return target:moveRot(rx, ry, rz, tSec, tMode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを回転させます.
---------------------------------------
function M:seekRot(rx, ry, rz, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:seekRot(rx, ry, rz, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを拡大させます.
---------------------------------------
function M:setScl(x, y, z)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            v:setScl(x, y, z)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを拡大します.
---------------------------------------
function M:moveScl(scaleX, scaleY, scaleZ, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:moveScl(scaleX, scaleY, scaleZ, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトを拡大します.
---------------------------------------
function M:seekScl(scaleX, scaleY, scaleZ, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:seekScl(scaleX, scaleY, scaleZ, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトの属性値を設定します.
---------------------------------------
function M:setAttr(attrID, value)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            v:setAttr(attrID, value)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトの属性値を設定します.
---------------------------------------
function M:moveAttr(attrID, value, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:moveAttr(attrID, value, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトの属性値を設定します.
---------------------------------------
function M:seekAttr(attrID, value, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:seekAttr(attrID, value, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトのindex値を設定します.
---------------------------------------
function M:setIndex(index, sec, mode)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            v:setIndex(index)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトのindex値を設定します.
---------------------------------------
function M:moveIndex(indexes, sec, mode)

    local curve = MOAIAnimCurve.new()
    local anim = MOAIAnim:new()
    local onStop = function(prop)
        self:onCommandComplete()
    end
    anim:setListener(MOAIAction.EVENT_STOP, onStop)

    local playFunc = function(obj, callback)
        if anim and anim:isBusy() then
            anim:setListener(MOAIAction.EVENT_STOP, nil)
            anim:stop()
            anim:setListener(MOAIAction.EVENT_STOP, onStop)
        end
        local tSec = sec or internal.second
        local tMode = mode or MOAITimer.LOOP

        curve:reserveKeys(#indexes)
        for i = 1, #indexes do
            curve:setKey(i, tSec * (i - 1), indexes[i], MOAIEaseType.FLAT )
        end
    
        anim:reserveLinks(#self.internal.targets)
        for i, prop in ipairs(self.internal.targets) do
            anim:setMode(tMode)
            anim:setLink(i, curve, prop, MOAIProp.ATTR_INDEX )
            anim:setCurve(curve)
        end
        anim:start()
        
        if tMode == MOAITimer.LOOP then
            callback(obj)
        end
    end
    local stopFunc = function(obj)
        anim:stop()
    end
    local command = self:newCommand(playFunc, stopFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトをフェードインします.
---------------------------------------
function M:fadeIn(sec, mode)
    local actionFunc = function(target, sec, mode)
        target:setColor(0, 0, 0, 0)
        return target:seekColor(1, 1, 1, 1, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトをフェードアウトします.
---------------------------------------
function M:fadeOut(sec, mode)
    local actionFunc = function(target, sec, mode)
        target:setColor(1, 1, 1, 1)
        return target:seekColor(0, 0, 0, 0, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトの色を設定します.
---------------------------------------
function M:setColor(red, green, blue, alpha)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            v:setColor(red, green, blue, alpha)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトの色をアニメーションします.
---------------------------------------
function M:moveColor(red, green, blue, alpha, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:moveColor(red, green, blue, alpha, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトの色をアニメーションします.
---------------------------------------
function M:seekColor(red, green, blue, alpha, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:seekColor(red, green, blue, alpha, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 対象オブジェクトのvisibleを設定します.
---------------------------------------
function M:setVisible(value)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            v:setVisible(value)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

---------------------------------------
-- 指定されたアニメーションを並列実行します.
---------------------------------------
function M:parallel(...)
    local internal = self.internal
    local animations = {...}
    local command = self:newCommand(
        -- start
        function(obj, callback)
            local count = 0
            local max = #animations
            local completeHandler = function(e)
                count = count + 1
                if count >= max then
                    callback(obj)
                end
            end
            for i, a in ipairs(animations) do
                a:play({onComplete = completeHandler})
            end
        end,
        -- stop
        function(obj)
            for i, a in ipairs(animations) do
                a:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 指定されたアニメーションを順次実行します.
---------------------------------------
function M:sequence(...)
    local internal = self.internal
    local animations = {...}
    local currentAnimation = nil
    local command = self:newCommand(
        -- start
        function(obj, callback)
            local count = 0
            local max = #animations
            local completeHandler = function(e)
                count = count + 1
                if count > max then
                    currentAnimation = nil
                    callback(obj)
                else
                    currentAnimation = animations[count]
                    currentAnimation:play()
                end
            end
            
            for i, animation in ipairs(animations) do
                animation.internal.onComplete = completeHandler
            end

            completeHandler()
        end,
        -- stop
        function(obj)
            if currentAnimation then
                currentAnimation:stop()
            end
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 指定されたアニメーションを指定回数だけ実行します.
-- 0の場合は、無限にアニメーションし続けます.
-- onLoop関数がtrueを返すと、ループは終了します.
-- 
-- @param count ループ回数、もしくはループ判定関数
-- @param ... アニメーション
---------------------------------------
function M:loop(maxCount, animation)
    local internal = self.internal
    local loopFunc = type(maxCount) == "function" and maxCount
    local command = self:newCommand(
        -- start
        function(obj, callback)
            local count = 0
            local completeHandler = function(e)
                count = count + 1
                if loopFunc then
                    if not loopFunc(self) then
                        callback(obj)
                    end
                elseif maxCount > 0 and count > maxCount then
                    callback(obj)
                else 
                    animation:play()
                end
            end
            animation.internal.onComplete = completeHandler
            completeHandler()
        end,
        -- stop
        function(obj)
            animation:stop()
        end
    )
    self:addCommand(command)
    return self
end

---------------------------------------
-- 一定時間待機します.
-- @param sec 待機時間
---------------------------------------
function M:wait(sec)
    local timer = MOAITimer.new()
    timer:setTime(sec)
    
    local command = self:newCommand(
        function(obj, callback)
            timer:setListener(MOAIAction.EVENT_STOP, function() callback(obj) end)
            timer:start()
        end,
        function(obj)
            timer:stop()
        end
    )
    
    self:addCommand(command)
    return self
end

---------------------------------------
-- アニメーションを開始します.
-- 一時停止していた場合は最初から再開します.
-- 
-- 引数のparamsでいくつかの動作を制御できます.
-- params.onComplete(e)に関数を指定すると
-- 完了時に関数がコールされます.
---------------------------------------
function M:play(params)
    params = params or {}
    local internal = self.internal

    if internal.running then
        return self
    end
    if params.onComplete then
        internal.onComplete = params.onComplete
    end
    
    internal.running = true
    internal.stoped = false
    
    if #internal.commands == 0 then
        return self
    end
    
    -- execute command
    self:executeCommand(1)
    
    return self
end

---------------------------------------
-- コマンドを実行します.
---------------------------------------
function M:executeCommand(index)
    local internal = self.internal
    
    if index <= #internal.commands then
        internal.currentIndex = index
        internal.currentCommand = internal.commands[internal.currentIndex]
        internal.currentCommand.play(self, self.onCommandComplete)
    end
end

---------------------------------------
-- コマンド完了時のハンドラです.
---------------------------------------
function M:onCommandComplete()
    local internal = self.internal

    if not internal.running then
        return
    end
    -- next command
    if internal.currentIndex < #internal.commands then
        self:executeCommand(internal.currentIndex + 1)
    -- complete!
    else
        internal.running = false
        if internal.onComplete then
            internal.onComplete(self)
        end
    end
end

---------------------------------------
-- アニメーションを停止します.
---------------------------------------
function M:stop()
    local internal = self.internal

    if not internal.running then
        return self
    end
    
    internal.running = false
    internal.currentCommand.stop(self)
    return self
end

---------------------------------------
-- コマンドをクリアします.
---------------------------------------
function M:clear()
    if self.isRunning() then
        return self
    end
    self.internal.commands = {}
    return self
end

---------------------------------------
-- アニメーション実行コマンドを追加します.
-- 通常は使用する必要がありませんが、
-- カスタムコマンドを追加する事もできます.
-- @param command play,stop,restart関数
---------------------------------------
function M:addCommand(command)
    table.insert(self.internal.commands, command)
    return self
end

---------------------------------------
-- アニメーション実行コマンドを生成します.
-- 実行コマンドは単純なテーブルです.
-- 指定しなかった関数は空関数がセットされます.
-- @param playFunc 開始 playFunc(callback)
-- @param stopFunc 停止 stopFunc()
-- @return command コマンドテーブル
---------------------------------------
function M:newCommand(playFunc, stopFunc)
    local emptyFunc = function(obj, callback) end
    playFunc = playFunc
    stopFunc = stopFunc and stopFunc or emptyFunc
    
    local command = {play = playFunc, stop = stopFunc}
    return command
end

---------------------------------------
-- 非同期なアクションを伴う、
-- アニメーション実行コマンドを生成します.
-- @param funcName 関数名
-- @param args sec, modeをのぞく引数
-- @param sec 秒
-- @param mode EaseType
-- @return command コマンドテーブル
---------------------------------------
function M:newActionCommand(actionFunc, sec, mode)
    local internal = self.internal

    local actionGroup = MOAIAction.new()
    local stoped = false
    local command = self:newCommand(
        -- play
        function(obj, callback)
            if #internal.targets == 0 then
                callback(obj)
            end

            -- 対象オブジェクトの引数
            local tSec = sec or internal.second
            local tMode = mode or internal.easeType
            
            -- 完了ハンドラ
            local completeHandler = function()
                if not stoped then
                    callback(obj)
                end
            end
            
            for i, target in ipairs(internal.targets) do
                local action = actionFunc(target, tSec, tMode)
                actionGroup:addChild(action)
            end
            actionGroup:setListener(MOAIAction.EVENT_STOP, completeHandler)
            actionGroup:start()
        end,
        -- stop
        function(obj)
            stoped = true
            actionGroup:stop()
        end
    )
    return command
end

return M
