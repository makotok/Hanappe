module(..., package.seeall)

local sheets = {
    {x = 0 * 32, y = 0 * 32, width = 32, height = 32},
    {x = 1 * 32, y = 0 * 32, width = 32, height = 32},
    {x = 2 * 32, y = 0 * 32, width = 32, height = 32},
    {x = 0 * 32, y = 1 * 32, width = 32, height = 32},
    {x = 1 * 32, y = 1 * 32, width = 32, height = 32},
    {x = 2 * 32, y = 1 * 32, width = 32, height = 32},
    {x = 0 * 32, y = 2 * 32, width = 32, height = 32},
    {x = 1 * 32, y = 2 * 32, width = 32, height = 32},
    {x = 2 * 32, y = 2 * 32, width = 32, height = 32},
    {x = 0 * 32, y = 3 * 32, width = 32, height = 32},
    {x = 1 * 32, y = 3 * 32, width = 32, height = 32},
    {x = 2 * 32, y = 3 * 32, width = 32, height = 32},
}

local sheetAnims = {
    {name = "walkDown", indexes = {2, 1, 2, 3, 2}, sec = 0.25},
    {name = "walkLeft", indexes = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "walkRight", indexes = {8, 7, 8, 9, 8}, sec = 0.25},
    {name = "walkUp", indexes = {11, 10, 11, 12, 11}, sec = 0.25},
}

function onCreate()
    layer = Layer:new({scene = scene})

    local spriteParams = {texture = "samples/assets/actor.png", sheets = sheets, sheetAnims = sheetAnims, layer = layer}
    sprite1 = SpriteSheet:new(spriteParams)
    sprite1:setLeft(0)
    sprite1:setTop(0)
    
    sprite2 = SpriteSheet:new(spriteParams)
    sprite2:setLeft(sprite1:getRight())
    sprite2:setTop(0)
    
    sprite3 = SpriteSheet:new(spriteParams)
    sprite3:setLeft(sprite2:getRight())
    sprite3:setTop(0)
    
    sprite4 = SpriteSheet:new(spriteParams)
    sprite4:setLeft(sprite3:getRight())
    sprite4:setTop(0)
end

function onStart()
    sprite1:playAnim("walkDown")
    sprite2:playAnim("walkLeft")
    sprite3:playAnim("walkRight")
    sprite4:playAnim("walkUp")
end

