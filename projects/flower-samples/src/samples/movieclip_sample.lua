module(..., package.seeall)

local ANIM_DATAS = {
    {name = "walkDown", frames = {2, 1, 2, 3, 2}, sec = 0.25},
    {name = "walkLeft", frames = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "walkRight", frames = {8, 7, 8, 9, 8}, sec = 0.25},
    {name = "walkUp", frames = {11, 10, 11, 12, 11}, sec = 0.25},
}

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setTouchEnabled(true)
    scene:addChild(layer)
    
    -- background
    background = flower.Rect(flower.viewWidth, flower.viewHeight)
    background:setColor(0, 0, 0, 1)
    background:setLayer(layer)

    -- image1
    movie1 = flower.MovieClip("actor.png", 3, 4)
    movie1:setAnimDatas(ANIM_DATAS)
    movie1:setIndex(2)
    movie1:setLayer(layer)
    movie1:addEventListener("touchDown", prop_onTouchDown)
    
    -- image2
    movie2 = flower.MovieClip("actor.png", 3, 4)
    movie2:setAnimDatas(ANIM_DATAS)
    movie2:setIndex(5)
    movie2:setPos(movie1:getRight(), 0)
    movie2:setLayer(layer)
    movie2:addEventListener("touchDown", prop_onTouchDown)
    
    -- image3
    movie3 = flower.MovieClip("actor.png", 3, 4)
    movie3:setAnimDatas(ANIM_DATAS)
    movie3:setIndex(8)
    movie3:setPos(movie2:getRight(), 0)
    movie3:setLayer(layer)
    movie3:addEventListener("touchDown", prop_onTouchDown)

    -- image4
    movie4 = flower.MovieClip("actor.png", 3, 4)
    movie4:setAnimDatas(ANIM_DATAS)
    movie4:setIndex(11)
    movie4:setPos(movie3:getRight(), 0)
    movie4:setLayer(layer)
    movie4:addEventListener("touchDown", prop_onTouchDown)
end

function onStart(e)
    movie1:playAnim("walkDown")
    movie2:playAnim("walkLeft")
    movie3:playAnim("walkRight")
    movie4:playAnim("walkUp")
end

function prop_onTouchDown(e)
    local prop = e.prop
    if prop:isBusy() then
        prop:stopAnim()
    else
        prop:playAnim()
    end
end
