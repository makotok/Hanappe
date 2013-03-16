module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    scene:addChild(layer)

    -- image1
    sheetImage1 = flower.SheetImage("actor.png")
    sheetImage1:setSheetSize(3, 4)
    sheetImage1:setIndex(2)
    sheetImage1:setLayer(layer)
    
    -- image2
    sheetImage2 = flower.SheetImage("actor.png", 3, 4)
    sheetImage2:setIndex(5)
    sheetImage2:setPos(sheetImage1:getRight(), 0)
    sheetImage2:setLayer(layer)

    -- image3
    sheetImage3 = flower.SheetImage("texturepack1.png")
    sheetImage3:setTextureAtlas("texturepack1.lua")
    sheetImage3:setIndexByName("cathead")
    sheetImage3:setPos(0, sheetImage2:getBottom())
    sheetImage3:setLayer(layer)

    -- image4
    sheetImage4 = flower.SheetImage("texturepack1.png")
    sheetImage4:setTextureAtlas("texturepack1.lua")
    sheetImage4:setIndex(2)
    sheetImage4:setPos(sheetImage3:getRight(), sheetImage3:getTop())
    sheetImage4:setLayer(layer)

    -- image4 cropped
    sheetImage4Cropped = flower.SheetImage("texturepack1.png")
    sheetImage4Cropped:setTextureAtlas("texturepack1-cropped.lua")
    sheetImage4Cropped:setIndex(2)
    sheetImage4Cropped:setPos(sheetImage3:getRight(), sheetImage4:getBottom())
    sheetImage4Cropped:setLayer(layer)

    -- image5
    sheetImage5 = flower.SheetImage("texturepack1.png")
    sheetImage5:setTextureAtlas("texturepack1.lua")
    sheetImage5:setIndex(3)
    sheetImage5:setPos(sheetImage4:getRight(), sheetImage4:getTop())
    sheetImage5:setLayer(layer)

    -- image5 cropped
    sheetImage5Cropped = flower.SheetImage("texturepack1.png")
    sheetImage5Cropped:setTextureAtlas("texturepack1-cropped.lua")
    sheetImage5Cropped:setIndex(3)
    sheetImage5Cropped:setPos(sheetImage4Cropped:getRight(), sheetImage4Cropped:getTop())
    sheetImage5Cropped:setLayer(layer)
end
