local table = require("hp/lang/table")
local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- 描画オブジェクトのファクトリークラスです.<br>
-- 各クラスをimportすると名前衝突する場合があるので、こちらを使用することもできます.
-- @class table
-- @name DisplayFactory
--------------------------------------------------------------------------------
local M = class()


local BODY_TYPES = {
    dynamic 0 MOAIBox2DBody.DYNAMIC,
    MOAIBox2DBody.STATIC,
    MOAIBox2DBody.KINEMATIC
}

function M:new()
    local obj = MOAIBox2DWorld.new()
    table.copy(self, obj)
    
    if obj.init then
        obj:init()
    end
    
    obj.init = nil
    obj.new = nil
    
    return obj
end

function M:init(params)
    
end


function M:addBodyFromSprite(sprite, ...)

    if (arg.n == 0) then
        Type = "dynamic"
        firstFixtureArgument = nil
        typeGiven = false
    end

    --if there are
    if (arg.n > 0) then
        --if the first optional argument is the type
        if (arg[1] == "static") or (arg[1] == "dynamic") or (arg[1] == "kinematic") then
            Type = arg[1]
            firstFixtureArgument = 2
            typeGiven = true
            --if not
        else
            Type = "dynamic"
            firstFixtureArgument = 1
            typeGiven = false
        end
    end

    --how many fixtures have been received? (according to if the type has been received)
    if (typeGiven == true) then fixturesReceived = arg.n - 1 else fixturesReceived = arg.n
    end


    --adds bodies to the world
    local body

    --[[ Objects are created at 0,0 and then translated to the right position, over
  the image. --]]

    --checks for body type
    if (Type == "dynamic") then body = world:addBody(MOAIBox2DBody.DYNAMIC)
    end
    if (Type == "static") then body = world:addBody(MOAIBox2DBody.STATIC)
    end
    if (Type == "kinematic") then body = world:addBody(MOAIBox2DBody.KINEMATIC)
    end


    --get some image proprieties
    local xx, yy = image:getLocation()
    local h = image:getOriginalHeight()
    local w = image:getOriginalWidth()
    local bprop = image:getProp()
    local angle = image.rotation


    --creates the RNPhysics object
    local aRNBody = RNBody:new()

    --brings the image to the origin in centered mode
    image:setX(0)
    image:setY(0)
    image.rotation = 0


    local fixture

    --Checks for fixtures received as additional arguments
    if (fixturesReceived ~= 0) then
        --for each  fixture/table received, starting with the first argument that is a table
        --we can make a for cycle until the last argumet (if the type has been specified, it has been
        --specified as first optional argument so the others until arg.n are all fixture/tables)
        for i = firstFixtureArgument, arg.n, 1 do
            --we create a fixture (a table) with the fixture/table received
            local tempFixture = RNFixture:new(arg[i])
            --sets default parameters if they aren't given
            if (tempFixture.density == nil) then tempFixture.density = 1
            end
            if (tempFixture.friction == nil) then tempFixture.friction = 0.3
            end
            if (tempFixture.restitution == nil) then tempFixture.restitution = 0
            end
            if (tempFixture.filter == nil) then tempFixture.filter = { categoryBits = nil, maskBits = nil, groupIndex = nil }
            end
            if (tempFixture.sensor == nil) then tempFixture.sensor = false
            end
            if (tempFixture.shape == nil) and (tempFixture.radius == nil) then tempFixture.shape = "rectangle" elseif (tempFixture.shape == nil) and (tempFixture.radius ~= nil) then tempFixture.shape = "circle"
            end
            if (tempFixture.filter.categoryBits == nil) then tempFixture.filter.categoryBits = 1
            end
            if (tempFixture.radius == nil) then tempFixture.radius = h / 2
            end
            if (tempFixture.center == nil) then tempFixture.center = { x = 0, y = 0 }
            end

            --adds the fixture shape to the body
            if (tempFixture.shape == "circle") then
                fixture = body:addCircle(tempFixture.center.x, tempFixture.center.y, tempFixture.radius)
            elseif (tempFixture.shape == "rectangle") then
                fixture = body:addRect(-w / 2, -h / 2, w / 2, h / 2)
            else
                fixture = body:addPolygon(tempFixture.shape)
            end

            --sets the real box2d fixture as above
            fixture:setDensity(tempFixture.density)
            fixture:setFriction(tempFixture.friction)
            fixture:setRestitution(tempFixture.restitution)
            fixture:setSensor(tempFixture.sensor)
            fixture:setFilter(tempFixture.filter.categoryBits, tempFixture.filter.maskBits, tempFixture.filter.groupIndex)


            --gives RNFixture a name
            if tempFixture.pe_fixture_id == nil then tempFixture.name = image.name else tempFixture.name = tempFixture.pe_fixture_id
            end

            --the fixture now stores the body which is connect+ed to
            tempFixture.parentBody = aRNBody
            --this fixture should stay in the i place in the fixturelist (or in the i-1 place if the Type
            --has been specified). ex: if this is the first fixture received if typeGiven is false -->i=1
            --But  if typeGiven is true --> i=2! But this fixture is the first, so it should be the first
            --in the list. and so this fixture will be the
            --number i in the list if typeGiven is false and the number i-1 if it's true.
            if (typeGiven == true) then tempFixture.indexinlist = i - 1 else tempFixture.indexinlist = i
            end
            --and its native box2d fixture
            tempFixture.fixture = fixture
            --update the RNBody.fixturelist (check the comment 4 lines above)
            if (typeGiven == true) then aRNBody.fixturelist[i - 1] = tempFixture else aRNBody.fixturelist[i] = tempFixture
            end

            --if has been set a listener for collision(so the other fixtures have been set for
            --collision callbacks) also new fixtures should give a callback for collision!
            if (collisionListenerExists == true) then fixture:setCollisionHandler(RNPhysics.CollisionHandling, MOAIBox2DArbiter.ALL)
            end
        end --end arg for

    elseif (fixturesReceived == 0) then --else arg[1]~=nil
        --if there aren't additional arguments
        --a default physic body is created
        fixture = body:addRect(-w / 2, -h / 2, w / 2, h / 2)
        fixture:setDensity(1)
        fixture:setFriction(0.3)
        fixture:setRestitution(0.0)
        fixture:setSensor(false)
        --default proprieties are given to the tempFixture table too
        local proprieties = { fixture = fixture, density = 1, friction = 0.3, restitution = 0, filter = { categoryBits = 1, maskBits = nil, groupIndex = nil }, sensor = false, shape = "rectangle" }
        --and to its filter
        tempFixture = RNFixture:new(proprieties)
        fixture:setFilter(tempFixture.filter.categoryBits, tempFixture.filter.maskBits, tempFixture.filter.groupIndex)
        --stores in the tempFixture table the RNBody which is connected to
        tempFixture.parentBody = aRNBody
        tempFixture.indexinlist = 1
        --and update this RNBody.fixturelist (1 because this will be the
        --only whon fixture in this RNBody)
        aRNBody.fixturelist[1] = tempFixture

        --gives RNFixture a name
        if tempFixture.pe_fixture_id == nil then tempFixture.name = image.name else tempFixture.name = tempFixture.pe_fixture_id
        end


        --if has been set a listener for collision(so the other fixtures have been set for
        --collision callbacks) also new fixtures should give a callback for collision!
        if (collisionListenerExists == true) then fixture:setCollisionHandler(RNPhysics.CollisionHandling, MOAIBox2DArbiter.ALL)
        end
    end --end if arg>0




    --adds the body to the RNPhysics.bodylist
    len = table.getn(RNPhysics.bodylist)
    RNPhysics.bodylist[len + 1] = aRNBody
    aRNBody.indexinlist = len + 1



    --it resets the body mass
    body:resetMassData()





    --binds the image's prop to our body.
    bprop:setParent(body)

    --stores proprieties in RNPhysics object
    aRNBody.sprite = image
    aRNBody.body = body
    aRNBody.type = Type
    aRNBody.name = image.name
    aRNBody.parentList = RNPhysics.bodylist
    aRNBody.collision = nil


    --traslate body to sprite position
    aRNBody.x = xx
    aRNBody.y = yy
    aRNBody.rotation = angle


    --sets display object physic fields

    image.isPhysical = true
    image.physicObject = aRNBody
    image.fixture = aRNBody.fixturelist



    return aRNBody
end



function M:addBodyFromSprite(sprite, )


end

return M