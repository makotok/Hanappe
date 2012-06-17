--------------------------------------------------------------------------------
-- This is a class to animate the MOAIProp. <br>
-- You can define the animation to flow. <br>
-- If you want to achieve complex animations, will say only this class. <br>
--
-- @auther Makoto
-- @class table
-- @name Animation
--------------------------------------------------------------------------------

local class = require("hp/lang/class")
local MOAIPropUtil = require("hp/util/MOAIPropUtil")

local M = class()

--------------------------------------------------------------------------------
-- The constructor.
-- @param targets (option)MOAIProp array. Or, MOAIProp instance.
-- @param sec (option)Animation time of each command.
-- @param easeType MOAIEaseType.
--------------------------------------------------------------------------------
function M:init(targets, sec, easeType)
    if type(targets) == "userdata" then
        targets = {targets}
    end
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

--------------------------------------------------------------------------------
-- Returns whether the animation.
-- @return True in the case of animation.
--------------------------------------------------------------------------------
function M:isRunning()
    return self.internal.running
end

--------------------------------------------------------------------------------
-- Sets the position of the target object.<br>
-- When they are performed is done at the time of animation.
-- @param left Left of the position.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Sets the position of the target object.<br>
-- When they are performed is done at the time of animation.
-- @param top Top of the position.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Sets the position of the target object.<br>
-- When they are performed is done at the time of animation.
-- @param right Right of the position.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Sets the position of the target object.<br>
-- When they are performed is done at the time of animation.
-- @param bottom Bottom of the position.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Sets the position of the target object.<br>
-- When they are performed is done at the time of animation.
-- @param left Left of the position.
-- @param top Top of the position.
-- @return self
--------------------------------------------------------------------------------
function M:setPos(left, top)
    local playFunc = function(obj, callback)
        for i, v in ipairs(self.internal.targets) do
            MOAIPropUtil.setPos(v, left, top)
        end
        callback(obj)
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Sets the position of the target object.<br>
-- When they are performed is done at the time of animation.
-- @param x X of the position.
-- @param y Y of the position.
-- @param z Z of the position.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Move the target objects.<br>
-- When they are performed is done at the time of animation.
-- @param moveX X of the position.
-- @param moveY Y of the position.
-- @param moveZ Z of the position.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:moveLoc(moveX, moveY, moveZ, sec, mode)
    local actionFunc = function(target, tSec, tMode)
        return target:moveLoc(moveX, moveY, moveZ, tSec, tMode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Seek the target objects.<br>
-- When they are performed is done at the time of animation.
-- @param x X of the position.
-- @param y Y of the position.
-- @param z Z of the position.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:seekLoc(x, y, z, sec, mode)
    local actionFunc = function(target, tSec, tMode)
        return target:seekLoc(x, y, z, tSec, tMode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Sets the rotation of the object.
-- @param x Rotation of the x-axis.
-- @param y Rotation of the y-axis.
-- @param z Rotation of the z-axis.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Move the rotation of the object.
-- @param x Rotation of the x-axis.
-- @param y Rotation of the y-axis.
-- @param z Rotation of the z-axis.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:moveRot(x, y, z, sec, mode)
    local actionFunc = function(target, tSec, tMode)
        return target:moveRot(x, y, z, tSec, tMode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Seek the rotation of the object.
-- @param x Rotation of the x-axis.
-- @param y Rotation of the y-axis.
-- @param z Rotation of the z-axis.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:seekRot(x, y, z, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:seekRot(x, y, z, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Sets the scale of the target object.
-- @param x Scale of the x-axis
-- @param y Scale of the y-axis.
-- @param z Scale of the z-axis.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Move the scale of the target object.
-- @param x Scale of the x-axis
-- @param y Scale of the y-axis.
-- @param z Scale of the z-axis.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:moveScl(x, y, z, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:moveScl(x, y, z, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Seek the scale of the target object.
-- @param x Scale of the x-axis
-- @param y Scale of the y-axis.
-- @param z Scale of the z-axis.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:seekScl(x, y, z, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:seekScl(x, y, z, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Sets the value of an attribute of the object.
-- @param attrID Attribute.
-- @param value Value.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Move the value of an attribute of the object.
-- @param attrID Attribute.
-- @param value Value.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:moveAttr(attrID, value, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:moveAttr(attrID, value, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Seek the value of an attribute of the object.
-- @param attrID Attribute.
-- @param value Value.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:seekAttr(attrID, value, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:seekAttr(attrID, value, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Sets the index.
-- @param index Index.
-- @return self
--------------------------------------------------------------------------------
function M:setIndex(index)
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

--------------------------------------------------------------------------------
-- Move the indexes.
-- @param indexes Array of indices.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- The fade in objects.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:fadeIn(sec, mode)
    local actionFunc = function(target, sec, mode)
        target:setColor(0, 0, 0, 0)
        return target:seekColor(1, 1, 1, 1, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- The fade out objects.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:fadeOut(sec, mode)
    local actionFunc = function(target, sec, mode)
        target:setColor(1, 1, 1, 1)
        return target:seekColor(0, 0, 0, 0, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Sets the color of the object.
-- @param red Red.
-- @param green Green.
-- @param blue Blue.
-- @param alpha Alpha.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Move the color of the object.
-- @param red Red.
-- @param green Green.
-- @param blue Blue.
-- @param alpha Alpha.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:moveColor(red, green, blue, alpha, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:moveColor(red, green, blue, alpha, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Seek the color of the object.
-- @param red Red.
-- @param green Green.
-- @param blue Blue.
-- @param alpha Alpha.
-- @param sec (option)Time animation.
-- @param mode (option)MOAIEaseType.
-- @return self
--------------------------------------------------------------------------------
function M:seekColor(red, green, blue, alpha, sec, mode)
    local actionFunc = function(target, sec, mode)
        return target:seekColor(red, green, blue, alpha, sec, mode)
    end
    local command = self:newActionCommand(actionFunc, sec, mode)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Sets the target object visible.
-- @param value Visible.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- The parallel execution of the animation of the argument.
-- @param ... Animations
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- The sequential execution of the animation argument.
-- @param ... Animations
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Run the specified number the animation of the argument.<br>
-- If you specify a 0 to maxCount is an infinite loop.<br>
-- If maxCount of the function, and loop until it returns the function's return value is true.<br>
-- 
-- @param maxCount Loop count, or, End judgment function.
-- @animation Animation
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Wait a specified amount of time.
-- @param sec Waiting time.
-- @return self
--------------------------------------------------------------------------------
function M:wait(sec)
    local timer = MOAITimer.new()
    timer:setSpan(sec)
    
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

--------------------------------------------------------------------------------
-- To start the animation.<br>
-- If during the start will be ignored.<br>
-- 
-- @param params (option)Parameters that control the behavior.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- To execute the command.<br>
-- You will not be accessible from the outside.
--------------------------------------------------------------------------------
function M:executeCommand(index)
    local internal = self.internal
    
    if index <= #internal.commands then
        internal.currentIndex = index
        internal.currentCommand = internal.commands[internal.currentIndex]
        internal.currentCommand.play(self, self.onCommandComplete)
    end
end

--------------------------------------------------------------------------------
-- The event handler when the command completes.<br>
-- You will not be accessible from the outside.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Stop the animation.
--------------------------------------------------------------------------------
function M:stop()
    local internal = self.internal

    if not internal.running then
        return self
    end
    
    internal.running = false
    internal.currentCommand.stop(self)
    return self
end

--------------------------------------------------------------------------------
-- Clears the definition animation.
--------------------------------------------------------------------------------
function M:clear()
    if self.isRunning() then
        return self
    end
    self.internal.commands = {}
    return self
end

--------------------------------------------------------------------------------
-- Add a command run animation.<br>
-- Usually does not need to be used.<br>
-- You can add a custom command.<br>
-- @param command play,stop,restart
--------------------------------------------------------------------------------
function M:addCommand(command)
    table.insert(self.internal.commands, command)
    return self
end

--------------------------------------------------------------------------------
-- Command to generate the animation.<br>
-- @param playFunc playFunc(callback)
-- @param stopFunc stopFunc()
-- @return command
--------------------------------------------------------------------------------
function M:newCommand(playFunc, stopFunc)
    local emptyFunc = function(obj, callback) end
    playFunc = playFunc
    stopFunc = stopFunc and stopFunc or emptyFunc
    
    local command = {play = playFunc, stop = stopFunc}
    return command
end

--------------------------------------------------------------------------------
-- To generate the asynchronous command with the action.
-- @param actionFunc 関数名
-- @param sec Time Animation.
-- @param mode MOAIEaseType.
-- @return command
--------------------------------------------------------------------------------
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
