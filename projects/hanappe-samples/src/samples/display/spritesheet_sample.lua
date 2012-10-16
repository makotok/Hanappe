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

function onCreate(params)
    layer = Layer {scene = scene}

    sprite1 = SpriteSheet {texture = "actor.png", sheets = sheets, sheetAnims = sheetAnims, layer = layer}
    sprite1:setLeft(0)
    sprite1:setTop(0)
    
    sprite2 = SpriteSheet {texture = "actor.png", layer = layer}
    sprite2:setTiledSheets(32, 32)
    sprite2:setSheetAnims(sheetAnims)
    sprite2:setLeft(sprite1:getRight())
    sprite2:setTop(0)
    
    sprite3 = SpriteSheet {texture = "actor.png", layer = layer}
    sprite3:setTiledSheets(32, 32, 3, 4)
    sprite3:setSheetAnims(sheetAnims)
    sprite3:setLeft(sprite2:getRight())
    sprite3:setTop(0)
    
    sprite4 = SpriteSheet {texture = "actor.png", layer = layer}
    sprite4:setTiledSheets(32, 32, 3, 4, 0, 0)
    sprite4:setSheetAnims(sheetAnims)
    sprite4:setLeft(sprite3:getRight())
    sprite4:setTop(0)

    -- It supports an empty constructor.
    sprite5 = SpriteSheet()
    sprite5:setTexture("actor.png")
    sprite5:setTiledSheets(32, 32)
    sprite5:setSheetAnims(sheetAnims)
    sprite5:setPos(0, sprite4:getBottom())
    sprite5:setLayer(layer)

    -- If the first argument string, and the texture parameters.
    sprite6 = SpriteSheet("actor.png")
    sprite6:setTiledSheets(32, 32)
    sprite6:setSheetAnims(sheetAnims)
    sprite6:setIndex(4)
    sprite6:setPos(sprite5:getRight(), sprite5:getTop())
    sprite6:setLayer(layer)

end

function onStart()
    sprite1:playAnim("walkDown")
    sprite2:playAnim("walkLeft")
    sprite3:playAnim("walkRight")
    sprite4:playAnim("walkUp")
    sprite5:playAnim("walkUp")
    sprite5:stopAnim()
end
