module(..., package.seeall)

local ANIM_DATAS = {
    {name = "walkDown", frames = {2, 1, 2, 3, 2}, sec = 0.25},
    {name = "walkLeft", frames = {5, 4, 5, 6, 5}, sec = 0.25},
    {name = "walkRight", frames = {8, 7, 8, 9, 8}, sec = 0.25},
    {name = "walkUp", frames = {11, 10, 11, 12, 11}, sec = 0.25},
}

-- Test Condition
local TIME_SPAN = 2
local STATT_SIZE = 200
local STEP_SIZE = 200
local MAX_IMAGES_SIZE = 6000
local MULTI_TEXTURE_ENABLED = false
local ANIMATION_ENABLD = true
local UPDATE_LOC_ENABLED = true
local UPDATE_CAMERA_ENABLED = false
local LAYER_SORT_ENABLED = false

-- variables
local fpsList = {}

math.randomseed(os.time())

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setTouchEnabled(true)
    layer:setScene(scene)
    layer:setSortMode(MOAILayer.SORT_NONE)
    if LAYER_SORT_ENABLED then
        layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    end
    
    camera = flower.Camera()
    layer:setCamera(camera)
    
    createImages(STATT_SIZE)

    timer = MOAITimer.new()
    timer:setMode(MOAITimer.LOOP)
    timer:setSpan(TIME_SPAN)
    timer:setListener(MOAITimer.EVENT_TIMER_LOOP, onTimer)
    timer:start()
    print("Test Start!!!")
    
end

function onTimer()
    print("----------------------------------------------------------")
    print("SIZE:", #images)
    print("FPS:", MOAISim.getPerformance())
    print("Draw:", MOAIRenderMgr.getPerformanceDrawCount())
    
    table.insert(fpsList, MOAISim.getPerformance())

    if #images >= MAX_IMAGES_SIZE then
        timer:stop()
        onTimerEnd()
    else
        createImages(STEP_SIZE)
    end
end

function onClose(e)
    for i, image in ipairs(images) do
        image:stopAnim()
    end
    timer:stop()
end

function onUpdate(e)
    if UPDATE_LOC_ENABLED then
        for i, image in ipairs(images) do
            image:setLoc(math.random(flower.viewWidth - 32), math.random(flower.viewHeight - 32))
        end
    end
    if UPDATE_CAMERA_ENABLED then
        camera:setLoc(math.random(32), math.random(32))
    end
end

function onTimerEnd()
    print("Test End!!!")
    print("FPS:", unpack(fpsList))
    removeImages()
end

function createImages(size)
    images = images or {}
    for i = 1, size do
        if #images >= MAX_IMAGES_SIZE then
            break
        end
        local fileIndex = MULTI_TEXTURE_ENABLED and (i % 3 + 1) or 1
        local image = flower.MovieClip("actor/actor" .. fileIndex ..".png", 3, 4)
        image:setAnimDatas(ANIM_DATAS)
        image:setIndex(2)
        image:setLayer(layer)
        image:setPos(math.random(flower.viewWidth - 32), math.random(flower.viewHeight - 32))
        --image:setPriority(fileIndex)
        table.insert(images, image)
        
        if ANIMATION_ENABLD then
            image:playAnim("walkDown")
        end
    end
end

function removeImages()
    for i, image in ipairs(images) do
        image:setLayer(nil)
        image:stopAnim()
    end
end