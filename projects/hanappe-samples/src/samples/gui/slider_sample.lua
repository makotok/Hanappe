module(..., package.seeall)

Component = require "hp/gui/Component"

function onCreate(params)
    view = View {
        scene = scene,
    }
    
    outGroup = Component {
        parent = view,
        layout = VBoxLayout {
            align = {"center", "center"},
            padding = {10, 10, 10, 10},
            gap = {10, 10},
        },
        pos = {40, 80},
    }

    sliderWidth = view:getWidth() - 100

    red = createSlider(outGroup, "red", 1, 0.1, {0.5, 1})
    green = createSlider(outGroup, "green", 0.6, 0.1, {0, 1})
    blue = createSlider(outGroup, "blue", 0.2, 0.05, {0, 1})

    rect = Graphics {
        parent = outGroup,
        width = sliderWidth,
        height = 100,
        left = 0,
        top = 0,
    }
    rect:setPenColor(1, 0.6, 0.2, 1):fillRect()
    rect:setPenColor(0, 1, 0, 1):drawRect()
end

function createSlider(parent, name, value, accuracy, bounds)
    local group = Group {
        parent = parent,
    }
    local slider = Slider {
        name = name,
        size = {sliderWidth, 38},
        pos = {0, 0},
        parent = group,
        value = value,
	valueBounds = bounds,
        accuracy = accuracy,
        onSliderBeginChange = onBeginChange,
        onSliderChanged = onChanged,
        onSliderEndChange = onEndChange,
    }
    local label = TextLabel {
        parent = group,
        text = tostring(slider:getValue()),
        size = {40, 38},
        pos = {slider:getRight(), 0},
        color = {0, 0, 1, 1},
    }
    slider.label = label
    group:resizeForChildren()
    return slider
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
    if slider.label then
        slider.label:setText(tostring(slider:getValue()))
    end
end

function onEndChange(e)
    local slider = e.target
    print("Slider '" .. slider:getName() .. "' end changing: " .. tostring(e.value))
end
