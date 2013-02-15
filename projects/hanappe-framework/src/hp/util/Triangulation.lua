--------------------------------------------------------------------------------
-- Triangulation routine is based on code by <br>
-- JOHN W. RATCLIFF (jratcliff@verant.com), July 22, 2000 <br>
--------------------------------------------------------------------------------

local M = {}

local EPSILON = 0.0000000001

local function area( contour )
    local n = #contour
    local A = 0
    
    local p = n
    local q = 1
    
    while q <= n do
        print( "n, p,q", n, p, q)
        A = A + contour[p].x * contour[q].y - contour[q].x * contour[p].y
        p = q
        q = q + 1
    end
    print("A=", .5 * A )
    return .5 * A
end

local function insideTriangle( Ax, Ay, Bx, By, Cx, Cy, Px, Py )
    local ax, ay, bx, by, cx, cy, apx, apy, bpx, bpy, cpx, cpy;
    local cCROSSap, bCROSScp, aCROSSbp;

    ax = Cx - Bx
    ay = Cy - By
    bx = Ax - Cx
    by = Ay - Cy
    cx = Bx - Ax
    cy = By - Ay
    apx= Px - Ax
    apy= Py - Ay
    bpx= Px - Bx
    bpy= Py - By
    cpx= Px - Cx
    cpy= Py - Cy
    
    aCROSSbp = ax*bpy - ay*bpx
    cCROSSap = cx*apy - cy*apx
    bCROSScp = bx*cpy - by*cpx
    
    return ( aCROSSbp >= 0 ) and ( bCROSScp >= 0 ) and ( cCROSSap >= 0 )
end

local function snip( contour, u, v, w, n, V )
	
    local Ax, Ay, Bx, By, Cx, Cy, Px, Py
    
    Ax = contour[ V[u] ].x
    Ay = contour[ V[u] ].y
    
    Bx = contour[ V[v] ].x
    By = contour[ V[v] ].y
    
    Cx = contour[ V[w] ].x
    Cy = contour[ V[w] ].y
    
    if EPSILON > (((Bx-Ax)*(Cy-Ay)) - ((By-Ay)*(Cx-Ax))) then
        return false
    end
    
    for p=1, n do
        
        if p ~= u and p ~= v and p ~= w then
            
            Px = contour[ V[p] ].x
            Py = contour[ V[p] ].y
    
            if insideTriangle( Ax, Ay, Bx, By, Cx, Cy, Px, Py ) then
                return false
            end
    
        end
    
    end
    
    return true
end

function M.process( contour )
    
    local result = {}
    
    local n = #contour
    
    local V = {}
    
    -- we want a counter-clockwise polygon in V
    if 0 < area( contour ) then
        for v = 1, n do
            V[v] = v
        end
    else
        for v = 1, n do
            V[v] = n - v + 1
        end
    end
    
    local nv = n
    
    -- remove nv-2 vertices, creating 1 triangle every time
    local count = 2 * nv
    
     --for(int m=0, v=nv-1; nv>2; )
    local v = nv
    local m = 1
    
    while nv > 2 do
        count = count - 1
        -- if we loop, probably it's a non-simple polygon
        -- (it crosses its own boundary)
        if count < 0 then
            print("ERROR: Polygon is self-intersecting. Can't triangulate.")
            --debugger.printTable( contour, "contour" )
            --debugger.printTable( result, "result" )
            return false
        end
    
        -- 3 consecutive vertices in current polygon <u,v,w>
        local u = v
        if nv < u then u = 1 end 	-- previous (all 3 were = 0)
        v = u + 1
        if nv < v then v = 1 end 	-- new v
        local w = v + 1
        if nv < w then w = 1 end 	-- next
    
    --	print("u, v, w, nv, count ", u, v, w, nv, count )
    
    
        if snip( contour, u, v, w, nv, V ) then
            local a, b, c, s, triangles
            a = V[u]
            b = V[v]
            c = V[w]
    
            -- Output triangle
            result[#result+1] = { contour[a].x, contour[a].y }
            result[#result+1] = { contour[b].x, contour[b].y }
            result[#result+1] = { contour[c].x, contour[c].y }
            table.remove( V, v )
            nv = nv - 1
            -- Reset error counter
            count = 2 * nv
        end
    
    end
    
    V = nil
    
    return result
end

return M