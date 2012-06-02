module(..., package.seeall)

local MY_MSGBOX_THEME = {textSize = 16, width = 300, height = 100}

function onCreate(params)
    widgetView = View()
    widgetView:setScene(scene)
    
    -- TODO:MOAI SDK v1.1
    -- 改行を含むテキストは、nextPageで上手くいかない.
    -- バグを回避する実装を行う予定。（ただしそのうち修正される可能性もある）
    -- また、word wrapがスペースで行っているので、日本語に対応できていない。
    -- MEMO:Will improve in the next version of MOAI.
    local text =  ""
    for i = 1, 20 do
        text = text .. "メッセージ" .. i .. "\n"
    end
    messageBox = MessageBox(MY_MSGBOX_THEME)
    messageBox:setText(text)
    messageBox:setPos(10, 10)
    messageBox:hide()
    widgetView:addChild(messageBox)
    
end

function onStart()
    messageBox:showPopup()
end
