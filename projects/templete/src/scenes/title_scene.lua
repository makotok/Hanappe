module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------
function onCreate(params)
    layer = Layer {
        scene = scene,
    }
    
   helloLabel = TextLabel {
        text = "Hello world",
        size = {200, 30},
        pos = {10, 10},
        layer = layer,
    }
end

function onStart()
    
end

function onEnterFrame()
    
end

