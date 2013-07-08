module(..., package.seeall)

function onCreate(params)
    view = View {
        scene = scene,
    }

    local sliderWidth = view:getWidth() - 20

    red = Slider {
        name = "red",
        size = {sliderWidth, 38},
        pos = {10, 80},
        parent = view,
        value = 1,
        accuracy = 0.1,
        onSliderBeginChange = onBeginChange,
        onSliderChanged = onChanged,
        onSliderEndChange = onEndChange,
    }

    green = Slider {
        name = "green",
        size = {sliderWidth, 38},
        pos = {10, 120},
        parent = view,
        value = 0.6,
        accuracy = 0.1,
        onSliderBeginChange = onBeginChange,
        onSliderChanged = onChanged,
        onSliderEndChange = onEndChange,
    }

    blue = Slider {
        name = "blue",
        size = {sliderWidth, 38},
        pos = {10, 160},
        parent = view,
        value = 0.2,
        accuracy = 0.05,
        onSliderBeginChange = onBeginChange,
        onSliderChanged = onChanged,
        onSliderEndChange = onEndChange,
    }

    rect = Graphics {
        parent = view,
        width = sliderWidth,
        height = 100,
        left = 10,
        top = 220,
    }
    rect:setPenColor(1, 0.6, 0.2, 1):fillRect()
    rect:setPenColor(0, 1, 0, 1):drawRect()
end

function onBeginChange(e)
    local slider = e.target
    print("Slider '" .. slider:getName() .. "' begin changing: " .. tostring(e.value))
end

function onChanged(e)
    local slider = e.target
    print("Slider '" .. slider:getName() .. "' changing: " .. tostring(e.value) .. ", old was " .. tostring(e.oldValue))

    -- these callbacks are fired on slider's construction
    -- so not all components may be available at that time
    -- no harm to safeguard access :)
    if rect then
        rect:setPenColor(red:getValue(), green:getValue(), blue:getValue(), 1):fillRect()    
    end
end

function onEndChange(e)
    local slider = e.target
    print("Slider '" .. slider:getName() .. "' end changing: " .. tostring(e.value))
end
