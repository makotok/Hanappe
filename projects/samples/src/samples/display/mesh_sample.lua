module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})
    
    group = Group()
    group:setLayer(layer)

    ------------------------------------------------------------------
    -- Letter: "M": Finally, let's draw a real polygon
    ------------------------------------------------------------------
    
    local verticesForM = {
        { x = 0, y = 50 },
        { x = 12, y = 50 },
        { x = 12, y = 30 },
        { x = 25, y = 42 },
        { x = 37, y = 30 },
        { x = 37, y = 50 },
        { x = 50, y = 50 },
        { x = 50, y = 0 },
        { x = 25, y = 25},
        { x = 0, y = 0 }
    }
    local gradientM = Mesh.newGradient("#990000", "#FFFF00", 45)
    letterM = Mesh.newPolygon(10, 10, verticesForM, gradientM)
    group:addChild(letterM)

    ------------------------------------------------------------------
    -- Letter: "O": Create a circle using solid color
    ------------------------------------------------------------------
    
    -- Create new circle: ( centerX, centerY, radius, colorHex )
    letterO = Mesh.newCircle(letterM:getRight() + 10, 10, 25, "#FFCC00")
    group:addChild(letterO)

    ------------------------------------------------------------------
    -- Letter: "A": Simple polygon using circle with defined segments
    ------------------------------------------------------------------
    
    -- Create gradient from dark to bright blue with an angle of 0
    local gradientA = Mesh.newGradient( "#00CC00", "#0099FF", 0 )
    
    -- Now we are sending gradient as a paremeter, and number 3 = 3 segments only
    letterA = Mesh.newCircle(letterO:getRight() + 15, 12, 33, gradientA, 3 )
    group:addChild(letterA)
    
    ------------------------------------------------------------------
    -- Letter: "I": Let's draw a rectangle, each vertex different color
    ------------------------------------------------------------------
    
    local colors = { "#FF0000", "#FFCC00", "#009900", "#0099CC" }
    
    -- Parameters: left, top, width, height, colors
    letterI = Mesh.newRect(letterA:getRight() + 10, 10, 25, 50, colors )
    group:addChild(letterI)

    ------------------------------------------------------------------
    -- Change of position
    ------------------------------------------------------------------
    group:resizeForChildren()
    group:setLeft((layer:getViewWidth() - group:getWidth()) / 2)
    group:setTop((layer:getViewHeight() - group:getHeight()) / 2)
    
    letterM:addLoc(100, -50)
end

function onStart()
    Animation(group, 1):parallel(
        Animation(letterM, 3):moveLoc(-100, 50, 0),
        Animation(letterA, 3):moveRot( 0, 0, 390)
    ):parallel(
        Animation(letterM, 1):wait(0.1):seekColor(0, 0, 0, 1):seekColor(1, 1, 1, 1),
        Animation(letterO, 1):wait(0.2):seekColor(0, 0, 0, 1):seekColor(1, 1, 1, 1),
        Animation(letterA, 1):wait(0.3):seekColor(0, 0, 0, 1):seekColor(1, 1, 1, 1),
        Animation(letterI, 1):wait(0.4):seekColor(0, 0, 0, 1):seekColor(1, 1, 1, 1)
    ):play()
end
