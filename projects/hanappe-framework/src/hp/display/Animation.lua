--------------------------------------------------------------------------------
-- This is a class to animate the MOAIProp.
-- You can define the animation to flow.
-- If you want to achieve complex animations, will say only this class.
--------------------------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local MOAIPropUtil      = require "hp/util/MOAIPropUtil"
local Executors         = require "hp/util/Executors"
local Event             = require "hp/event/Event"
local EventDispatcher   = require "hp/event/EventDispatcher"

-- class
local M                 = class(EventDispatcher)
local super             = EventDispatcher

-- create animation context.
local function createContext(self, params)
    local context = params or {}
    context.stopped = false
    context.paused = false
    table.insert(self._contexts, context)
    return context
end

--------------------------------------------------------------------------------
-- The constructor.
-- @param targets (option)MOAIProp array. Or, MOAIProp instance.
-- @param sec (option)Animation time of each command.
-- @param easeType MOAIEaseType.
--------------------------------------------------------------------------------
function M:init(targets, sec, easeType)
    super.init(self)

    self._commands = {}
    self._targets = type(targets) == "userdata" and {targets} or targets or {}
    self._running = false
    self._second = sec and sec or 1
    self._easeType = easeType
    self._contexts = {}
    self._throttle = 1
    self._paused = false
    
end

--------------------------------------------------------------------------------
-- Returns whether the animation.
-- @return True in the case of animation.
--------------------------------------------------------------------------------
function M:isRunning()
    return self._running
end

--------------------------------------------------------------------------------
-- Returns whether the animation is paused.
-- @return boolean indicating the pause state of the current animation.
--------------------------------------------------------------------------------
function M:isPaused()
    return self._paused
end

--------------------------------------------------------------------------------
-- Sets the position of the target object.<br>
-- When they are performed is done at the time of animation.
-- @param left Left of the position.
-- @return self
--------------------------------------------------------------------------------
function M:setLeft(left)
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            MOAIPropUtil.setLeft(v, left)
        end
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
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            MOAIPropUtil.setTop(v, top)
        end
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
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            MOAIPropUtil.setRight(v, right)
        end
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
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            MOAIPropUtil.setBottom(v, bottom)
        end
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
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            MOAIPropUtil.setPos(v, left, top)
        end
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
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            v:setLoc(x, y, z)
        end
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
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            v:setRot(x, y, z)
        end
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
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            v:setScl(x, y, z)
        end
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
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            v:setAttr(attrID, value)
        end
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
    local playFunc = function(self, context)
        for i, v in ipairs(self._targets) do
            v:setIndex(index)
        end
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
    local anim = MOAIAnim.new()
    
    local playFunc = function(self, context)
        if anim and anim:isBusy() then
            anim:stop()
        end
        local tSec = sec or self._second
        local tMode = mode or MOAITimer.LOOP

        curve:reserveKeys(#indexes)
        for i = 1, #indexes do
            curve:setKey(i, tSec * (i - 1), indexes[i], MOAIEaseType.FLAT )
        end
    
        anim:setMode(tMode)
        anim:reserveLinks(#self._targets)
        for i, prop in ipairs(self._targets) do
            anim:setLink(i, curve, prop, MOAIProp.ATTR_INDEX )
        end
        anim:setCurve(curve)
        anim:start()
        
        if tMode == MOAITimer.LOOP then
            return
        end
        
        MOAICoroutine.blockOnAction(anim)
    end

    local resumeFunc = function(self, context)
        anim:pause(false)
    end

    local pauseFunc = function(self, context)
        anim:pause(true)
    end

    local stopFunc = function(self, context)
        anim:stop()
    end
    
    local command = self:newCommand(playFunc, stopFunc, resumeFunc, pauseFunc)
    command.action = anim
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
    local playFunc = function(self)
        for i, v in ipairs(self._targets) do
            v:setColor(red, green, blue, alpha)
        end
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
    local playFunc = function(self)
        for i, v in ipairs(self._targets) do
            v:setVisible(value)
        end
    end
    local command = self:newCommand(playFunc)
    self:addCommand(command)
    return self
end

--------------------------------------------------------------------------------
-- Call function.
-- @param func function object.
-- @return self
--------------------------------------------------------------------------------
function M:callFunc(func)
    local playFunc = function(self)
        func(self)
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
    local animations = {...}
    local command = self:newCommand(
        -- play
        function(self, context)
            local count = 0
            local max = #animations
            
            -- animation complete handler
            local completeHandler = function(e)
                count = count + 1
            end
            
            -- play animations
            for i, a in ipairs(animations) do
                if self._throttle ~= a:getThrottle() then
                    a:setThrottle(self._throttle)
                end
                a:play {onComplete = completeHandler}
            end
            
            -- wait animations
            while count < max do
                coroutine.yield()
                for i, a in ipairs(animations) do
                    if self._throttle ~= a:getThrottle() then
                        a:setThrottle(self._throttle)
                    end
                end
            end
        end,
        -- stop
        function(self, context)
            for i, a in ipairs(animations) do
                a:stop()
            end
        end,
        -- resume
        function(self, context)
            for i, a in ipairs(animations) do
                if a:isRunning() then
                    if self._throttle ~= a:getThrottle() then
                        a:setThrottle(self._throttle)
                    end
                    a:resume()
                end
            end
        end,
        -- pause
        function(self, context)
            for i, a in ipairs(animations) do
                if a:isRunning() then
                    a:pause()
                end
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
    local animations = {...}
    local currentAnimation = nil
    local command = self:newCommand(
        -- play
        function(self, context)
            local count = 0
            local max = #animations
            
            for i, animation in ipairs(animations) do
                if self._throttle ~= animation:getThrottle() then
                    animation:setThrottle(self._throttle)
                end
                animation:play()

                while animation:isRunning() do
                    coroutine.yield()
                    if self._throttle ~= animation:getThrottle() then
                        animation:setThrottle(self._throttle)
                    end
                end

                if context.stopped then
                    break
                end
            end
        end,
        -- stop
        function(self, context)
            for i, animation in ipairs(animations) do
                animation:stop()
            end
        end,
        -- resume
        function(self, context)
            for i, animation in ipairs(animations) do
                if animation:isRunning() then
                    if self._throttle ~= animation:getThrottle() then
                        animation:setThrottle(self._throttle)
                    end
                    animation:resume()
                end
            end
        end,
        -- pause
        function(self, context)
            for i, animation in ipairs(animations) do
                if animation:isRunning() then
                    animation:pause()
                end
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
-- @param animation Animation
-- @return self
--------------------------------------------------------------------------------
function M:loop(maxCount, animation)
    local loopFunc = type(maxCount) == "function" and maxCount
    local command = self:newCommand(
        -- play
        function(self, context)
            local count = 0
            while true do
                if self._throttle ~= animation:getThrottle() then
                    animation:setThrottle(self._throttle)
                end
                animation:play()
                
                while animation:isRunning() do
                    coroutine.yield()
                    if self._throttle ~= animation:getThrottle() then
                        animation:setThrottle(self._throttle)
                    end
                end

                if context.stopped then
                    break
                end
                
                count = count + 1
                if maxCount > 0 and count > maxCount then
                    break
                end
            end
        end,
        -- stop
        function(self, context)
            animation:stop()
        end,
        -- resume
        function(self, context)
            if self._throttle ~= animation:getThrottle() then
                animation:setThrottle(self._throttle)
            end
            animation:resume()
        end,
        -- pause
        function(self, context)
            animation:pause()
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
        -- play
        function(self, context)
            timer:start()
            MOAICoroutine.blockOnAction(timer)
        end,
        -- stop
        function(self, context)
            timer:stop()
        end,
        -- resume
        function(self, context)
            timer:pause(false)
        end,
        -- pause
        function(self, context)
            timer:pause(true)
        end
    )
    
    command.action = timer
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
    if self:isRunning() then
        -- resume, instead of to start a new context, if in pause state
        if self:isPaused() then
            self:resume()
        end
    else
        self._running = true
        local context = createContext(self, params)

        Executors.callLater(self.playInternal, self, context)
    end

    return self
end

--------------------------------------------------------------------------------
-- To execute the command.<br>
-- You will not be accessible from the outside.
--------------------------------------------------------------------------------
function M:playInternal(context)
    if context.stopped then
        return
    end
    
    local commands = table.copy(self._commands)
    for i, command in ipairs(commands) do
        context.currentCommand = command
        if command.action then
            command.action:throttle(self._throttle)
        end

        while context.paused do
            -- spinlock until animation is resumed or stopped
            if context.stopped then
                return
            end
            coroutine.yield()
        end

        context.currentCommand.play(self, context)
        
        if context.stopped then
            return
        end
    end
    
    self._running = false
    
    if context.onComplete then
        context.onComplete(self, context)
    end
    
    local e = Event(Event.COMPLETE)
    e.context = context
    self:dispatchEvent(e)
end


--------------------------------------------------------------------------------
-- Resumes the animation if it's running and in pause state.
-- @return self
--------------------------------------------------------------------------------
function M:resume()
    if self:isRunning() and self:isPaused() then
        self._paused = false

        for _, context in ipairs(self._contexts) do
            context.paused = false
        end
        for _, command in ipairs(self._commands) do
            if command.action then
                command.action:throttle(self._throttle)
            end
            command.resume(self, context)
        end
    end

    return self
end

--------------------------------------------------------------------------------
-- Pauses the animation if it's running and not in pause state.
-- @return self
--------------------------------------------------------------------------------
function M:pause()
    if self:isRunning() and not self:isPaused() then
        self._paused = true

        for _, context in ipairs(self._contexts) do
            context.paused = true
        end
        for _, command in ipairs(self._commands) do
            command.pause(self, context)
        end
    end

    return self
end

--------------------------------------------------------------------------------
-- Stop the animation.
--------------------------------------------------------------------------------
function M:stop()
    if not self:isRunning() then
        return self
    end
    
    self._running = false
    
    -- clear contexts
    for i, context in ipairs(self._contexts) do
        context.stopped = true
    end

    for _, command in ipairs(self._commands) do
        command.stop(self)
    end

    self._contexts = {}
    
    return self
end

--------------------------------------------------------------------------------
-- Clears the definition animation.
--------------------------------------------------------------------------------
function M:clear()
    if self:isRunning() then
        return self
    end
    self._commands = {}
    return self
end

--------------------------------------------------------------------------------
-- Add a command run animation.<br>
-- Usually does not need to be used.<br>
-- You can add a custom command.<br>
-- @param command play,stop,restart
--------------------------------------------------------------------------------
function M:addCommand(command)
    table.insert(self._commands, command)
    return self
end

--------------------------------------------------------------------------------
-- Command to generate the animation.<br>
-- @param playFunc playFunc(callback)
-- @param stopFunc stopFunc()
-- @param resumeFunc resumeFunc()
-- @param pauseFunc pauseFunc()
-- @return command
--------------------------------------------------------------------------------
function M:newCommand(playFunc, stopFunc, resumeFunc, pauseFunc)
    local emptyFunc = function(obj, callback) end
    playFunc = playFunc
    stopFunc = stopFunc and stopFunc or emptyFunc
    resumeFunc = resumeFunc and resumeFunc or emptyFunc
    pauseFunc = pauseFunc and pauseFunc or emptyFunc
    
    local command = {play = playFunc, stop = stopFunc, resume = resumeFunc, pause = pauseFunc}
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
    local actionGroup = MOAIAction.new()
    local command = self:newCommand(
        -- play
        function(self, context)
            if #self._targets == 0 then
                return
            end

            local tSec = sec or self._second
            local tMode = mode or self._easeType
            
            for i, target in ipairs(self._targets) do
                local action = actionFunc(target, tSec, tMode)
                actionGroup:addChild(action)
            end
            
            actionGroup:start()
            MOAICoroutine.blockOnAction(actionGroup)
        end,
        -- stop
        function(self, context)
            actionGroup:stop()
        end,
        -- resume
        function(self, context)
            actionGroup:pause(false)
        end,
        -- pause
        function(self, context)
            actionGroup:pause(true)
        end
    )
    command.action = actionGroup
    return command
end

--------------------------------------------------------------------------------
-- Changes the throttle, as defined by MOAIAction.throttle, of the animation.
-- If the animation is already running, update throttle on all commands.
-- @param newThrottle Desired new throttle value
-- @return none
--------------------------------------------------------------------------------
function M:setThrottle(newThrottle)
    if self:isRunning() then
        for _, command in ipairs(self._commands) do
            if command.action then
                command.action:throttle(newThrottle)
            end
        end
    end
    self._throttle = newThrottle
end

--------------------------------------------------------------------------------
-- Returns the current throttle value
-- @return throttle
--------------------------------------------------------------------------------
function M:getThrottle()
    return self._throttle
end

return M
