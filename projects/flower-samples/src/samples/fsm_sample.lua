module(..., package.seeall)

local UIView = widget.UIView
local UIGroup = widget.UIGroup
local Button = widget.Button
local BoxLayout = widget.BoxLayout

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)

    stateMachine = fsm.StateMachine {
        move = fsm.State {
            onEnter = function(state, context)
                print("move:onEnter")
                context.moveCount = 0
            end,
            onUpdate = function(state, context)
                print("move:onUpdate")
                context.moveCount = context.moveCount + 1
                if context.moveCount > 5 then
                    state.machine:changeCurrentState("wait")
                end
            end,
            onExit = function(state, context)
                print("move:onExit")
                context.moveCount = 0
            end,
        },
        wait = fsm.State {
            onEnter = function(state, context)
                print("wait:onEnter")
                context.waitCount = 0
            end,
            onUpdate = function(state, context)
                print("wait:onUpdate")
                context.waitCount = context.waitCount + 1
                if context.waitCount > 3 then
                    state.machine:changeCurrentState("move")
                end
            end,
            onExit = function(state, context)
                print("wait:onExit")
                context.waitCount = 0
            end,
        },
    }

    stateMachine:changeCurrentState("wait")

    view = widget.UIView {
        scene = scene,
        layout = BoxLayout {
            gap = {5, 5},
            align = {"center", "center"},
        },
    }
    
    button1 = widget.Button {
        size = {200, 50},
        text = "Update state",
        parent = view,
        onClick = function(e)
            stateMachine:update()
        end,
    }
end
