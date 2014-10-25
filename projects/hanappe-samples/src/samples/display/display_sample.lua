module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene,
    }

    group = Group {
        layer = layer,
        color = {0.5, 0.5, 0.5, 1},
        scl = {2, 2, 1},
    }
    
    sprite = Sprite {
        texture = "cathead.png",
        pos = {0, 0},
        parent = group,
    }
    
    graphics = Graphics {
        size = {100, 100},
        pos = {128, 0},
        parent = group,
    }
    graphics:fillRect()
    
end
