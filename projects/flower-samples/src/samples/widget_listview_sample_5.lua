---
-- Sample to set the height for each row in the ListView.

module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)

    local dataSource = {
        createLabelWidgetData(50, "left", "top"),
        createLabelWidgetData(70, "right", "bottom"),
        createLabelWidgetData(50, "center", "center"),
        createLabelWidgetData(70, "center", "center"),

        createLabelWidgetData(50, "left", "top"),
        createLabelWidgetData(70, "right", "bottom"),
        createLabelWidgetData(50, "center", "center"),
        createLabelWidgetData(70, "center", "center"),

        createGroupWidgetData(50),
        createGroupWidgetData(80),
        createGroupWidgetData(60),
        createGroupWidgetData(70),
        
        createGroupWidgetData(50),
        createGroupWidgetData(80),
        createGroupWidgetData(60),
        createGroupWidgetData(70),
    }

    widget.ListView {
        scene = scene,
        dataSource = {dataSource},
        itemRendererClass = widget.WidgetItemRenderer,
        itemProperties = {{
            rowHeightField = "rowHeight",
            widgetField = "widget",
        }},
    }
end

function createLabelWidgetData(rowHeight, hAlign, vAlign)
    return {
        rowHeight = rowHeight,
        widget = widget.UILabel {
            text = "Label ",
            textAlign = {hAlign, vAlign},
        },
    }
end

function createGroupWidgetData(rowHeight)
    return {
        rowHeight = rowHeight,
        widget = widget.UIGroup {
            layout = widget.BoxLayout {
                direction = "horizontal",
                align = {"center", "center"},
            },
            children = {{
                flower.Image("cathead.png", 24, 24),
                flower.Image("cathead.png", 24 * 2, 24 * 2),
                flower.Label("Widget"),
            }},
        },
    }
end