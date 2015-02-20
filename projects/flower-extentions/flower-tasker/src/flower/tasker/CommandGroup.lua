----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local BaseCommand = require "flower.tasker.BaseCommand"
local CommandExecutor = require "flower.tasker.CommandExecutor"

-- class
local CommandGroup = class(BaseCommand)

---
-- TODO:LDoc
function CommandGroup:initInternal(properties)
    self.commands = {}
    self.abortCommands = {}
    self.commandExecutor = CommandExecutor.getInstance()
end

---
-- TODO:LDoc
function CommandGroup:executeInternal(context)
    context.status = self.commandExecutor:execute(self.commands, context)
    if context.status > 0 then
        context.abortCommand = context.currentCommand
        self.commandExecutor:execute(self.abortCommands, context)
    end
    return context.status
end

---
-- TODO:LDoc
function CommandGroup:setCommands(value)
    self.commands = value
end

---
-- TODO:LDoc
function CommandGroup:setAborts(value)
    self.abortCommands = value
end

return CommandGroup