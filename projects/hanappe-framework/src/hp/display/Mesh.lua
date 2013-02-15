--------------------------------------------------------------------------------
-- This is a class to draw a gradient mesh. <br>
-- This source has been implemented by Nenad Katic. <br>
-- Has been partially modified. <br>
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local string = require("hp/lang/string")
local DisplayObject = require("hp/display/DisplayObject")
local ShaderManager = require("hp/manager/ShaderManager")
local Triangulation = require("hp/util/Triangulation")

local M = class(DisplayObject)

local DEFAULT_COLOR = "#FF00FF"

--------------------------------------------------------------------------------
-- Creates and returns a mesh.
--------------------------------------------------------------------------------
local function createMesh( vcoords, colors, primType )
    primType = primType or MOAIMesh.GL_TRIANGLE_FAN
    if vcoords and colors then
        local numVertices = #vcoords

        local vertexFormat = MOAIVertexFormat.new ()
        vertexFormat:declareCoord ( 1, MOAIVertexFormat.GL_FLOAT, 2 )
        -- Commented line below because we're not going to use UV coordinates
        -- vertexFormat:declareUV ( 2, MOAIVertexFormat.GL_FLOAT, 2 )
        vertexFormat:declareColor ( 2, MOAIVertexFormat.GL_UNSIGNED_BYTE )

        local vbo = MOAIVertexBuffer.new ()
        vbo:setFormat ( vertexFormat )
        vbo:reserveVerts ( #vcoords )

        for i=1, numVertices do
            vbo:writeFloat ( vcoords[i][1], vcoords[i][2] )                  -- write vertex position
            vbo:writeColor32 ( colors[i][1], colors[i][2], colors[i][3] )    -- write RGB value
        end

        vbo:bless ()

        local mesh = MOAIMesh.new ()
        mesh:setVertexBuffer ( vbo )
        mesh:setPrimType ( primType )

        return mesh
    end
    return nil
end

--------------------------------------------------------------------------------
-- Returns the color to calculate the gradient.
--------------------------------------------------------------------------------
local function calculateGradient( color1, color2, angle, gradAngle )

    local perc =.5 * ( 1 + math.cos( math.rad( angle-gradAngle) ) )
    
    local color = {}
    for i=1,3 do
        color[i] = color1[i] + perc * ( color2[i] - color1[i] )
    end
    return color

end

--------------------------------------------------------------------------------
-- Returns the color to calculate the gradient.
--------------------------------------------------------------------------------
local function calculateDetailedGradient( points, angle, col1, col2 )
    
    local colors = {}
    local projectedX = {}

    local ang = math.rad ( angle )
    local s = math.sin ( ang )
    local c = math.cos ( ang )

    local x, y

    local minX = 0
    local maxX = 0

    local projX, xprim

    for i=1, #points do
            
        x = points[i][1] 
        y = points[i][2]

        xprim = ( math.abs( c ) > 0.001 ) and ( x/c ) or 0

        -- a little of trigonometry gymnastics
        projX = xprim + s * ( y - s * xprim )

        projectedX[ #projectedX+1 ] = projX

        if projX < minX then
            minX = projX
        elseif projX > maxX then
            maxX = projX
        end
    end

    -- now calculate percents
    local perc, color
    local dX = maxX - minX
    for i=1, #projectedX do
        perc = ( projectedX[i] - minX ) / dX
        color = {}
        for i=1,3 do
            color[i] = col1[i] + perc * ( col2[i] - col1[i] )
        end
        colors[#colors+1] = color
    end

    return colors
end

--------------------------------------------------------------------------------
-- Returns an array of colors.
--------------------------------------------------------------------------------
local function isColorOrGradient( col )
    -- if no argument, just use default color
    col = col or { DEFAULT_COLOR }
    -- if a string has been forwaded, convert to table for later use
    if type(col) == "string" then
        col = { string.hexToRGB( col, true ) }
    else
        col ={ string.hexToRGB( col[1], true ), string.hexToRGB( col[2], true ) , col[3] }
    end
    return col
end

--------------------------------------------------------------------------------
-- Creates and returns a gradient array.<br>
-- Example: ( "#003300", "#CCFF00", 90 )
-- @param col1 fromColor.
-- @param col2 toColor.
-- @param angle gradientAngle.
-- @return gradient array
--------------------------------------------------------------------------------
function M.newGradient( col1, col2, angle )
    angle = angle or 90
    return { col1, col2, angle }
end

--------------------------------------------------------------------------------
-- Creates and returns a mesh of the rectangle.<br>
-- Mesh is the class that inherits from the DisplayObject.
-- @param left Position of the left.
-- @param top Position of the top.
-- @param width width.
-- @param height height.
-- @param col Color of the gradient.
-- @return Rectangle object
--------------------------------------------------------------------------------
function M.newRect( left, top, width, height, col )

    -- Check what's sent for colors argument
    local colors

    -- Should we paint every vertice in its own color ?
    -- To do this, we use a table of 4 elements, like { "#FF0000", "#FFCC00", "#009900", "#0099CC" }

    local everyVertice = type(col)=="table" and #col == 4

    if everyVertice then
        colors = {}
        for i=1, 4 do
            colors[i] = string.hexToRGB( col[i], true )  -- using extended string table, in lang.lua
        end

    else
        -- nope, so it's going to be either solid color or gradient.
        colors = isColorOrGradient( col )
    end


    local isGradient = ( #colors == 3 )

    ------------------------------------------------------------
    -- Prepare vertex coordinates and vertex colors for vbo
    ------------------------------------------------------------
    local vcoords, colorCoords = {}, {}

    -- vertex coordinates
    vcoords[1] = { 0, 0 }
    vcoords[2] = { width, 0 }
    vcoords[3] = { width, height }
    vcoords[4] = { 0, height }
    
    -- vertex colors
    if isGradient then
        colorCoords = calculateDetailedGradient(  vcoords, colors[3], colors[1], colors[2]  )
    elseif everyVertice then
        -- just assign vertex colors in the same order we forwarded it to the function
        for i = 1, 4 do
            colorCoords[i] = colors[i]
        end
    else
        -- if using solid color, just copy it for every vertex
        for i = 1, 4 do
            colorCoords[i] = colors[1]
        end
    end

    local prop = M(vcoords, colorCoords, MOAIMesh.GL_TRIANGLE_FAN)
    prop:setPos(left, top)
    return prop
end


--------------------------------------------------------------------------------
-- Creates and returns a mesh of the circle.<br>
-- Mesh is the class that inherits from the DisplayObject.
-- @param left Position of the left.
-- @param top Position of the top.
-- @param r Radius.
-- @param col color(s).
-- @param seg segments.
-- @return Circle object
--------------------------------------------------------------------------------
function M.newCircle(left, top, r, col, seg)

    -- Check if we're skipping col argument
    if type(col) == "number" then
        seg = col
        col = nil
    end

    -- So what do we have here?
    local colors = isColorOrGradient( col )
    local isGradient = #colors == 3

    -- number of segments
    if not seg then
        seg = 12 * math.ceil ( r / 20 )
        if seg > 128 then
            seg = 128
        end
    end

    -- coordinates
    local vcoords, colorCoords = {}, {}

    local vx, vy, angle
    local angleInc = 360 / seg

    for i=1, seg do
        angle = angleInc*(i-1) 
        vy = r * math.sin( math.rad( angle ) )
        vx = r * math.cos( math.rad( angle ) )
        vcoords[i] = { vx, vy }

        if not isGradient then
            colorCoords[i] = colors[1]
        else
            --colorCoords[i] = calculateGradient( colors[1], colors[2], angle, colors[3] )
        end
    end

    if isGradient then
        colorCoords = calculateDetailedGradient(  vcoords, colors[3], colors[1], colors[2]  )
    end

    local prop = M(vcoords, colorCoords, MOAIMesh.GL_TRIANGLE_FAN)
    prop:setPos(left, top)
    return prop
end

--------------------------------------------------------------------------------
-- Creates and returns a mesh of the polygon.<br>
-- Mesh is the class that inherits from the DisplayObject.
-- @param left Position of the left.
-- @param top Position of the top.
-- @param vertices Vertex array.
-- @param col Color gradient.
-- @return Polygon object
--------------------------------------------------------------------------------
function M.newPolygon( left, top, vertices, col )

    -- create gradient if needed
    local colors = isColorOrGradient( col )
    local isGradient = #colors == 3

    -- get triangulated points
    local triangulatedPoints = Triangulation.process( vertices ) --delaunay( vertices )

    -- get color coordinates
    local  colorCoords = {}

    if isGradient then
        colorCoords = calculateDetailedGradient(  triangulatedPoints, colors[3], colors[1], colors[2]  )
    else
        for i = 1, #triangulatedPoints do
            colorCoords[ #colorCoords + 1 ] = colors[1]
        end
    end

    local prop = M(triangulatedPoints, colorCoords, MOAIMesh.GL_TRIANGLES)
    prop:setPos(left, top)
    return prop
end

--------------------------------------------------------------------------------
-- The constructor.
-- @param vcoords vcoords
-- @param colors colors
-- @param primType primType
--------------------------------------------------------------------------------
function M:init(vcoords, colors, primType)
    DisplayObject.init(self)

    local mesh =  createMesh(vcoords, colors, primType)
    local shader = ShaderManager:getShader(ShaderManager.BASIC_COLOR_SHADER)
    self:setDeck(mesh)
    self:setShader(shader)
end

return M