module(..., package.seeall)

function onCreate(params)
    widgetView = View()
    widgetView:setScene(scene)
    
    -- TODO:MOAI SDK v1.1
    -- 改行を含むテキストは、nextPageで上手くいかない.
    -- バグを回避する実装を行う予定。（ただしそのうち修正される可能性もある）
    -- また、word wrapがスペースで行っているので、日本語に対応できていない。
    -- これは、対応が難しいのでMOAISDKに修正をお願いしている。
    local text =  ""
    for i = 1, 20 do
        text = text .. "メッセージ" .. i .. "\n"
    end
    messageBox = MessageBox()
    messageBox:setTextSize(16)
    messageBox:setSize(300, 100)
    messageBox:setText(text)
    messageBox:setPos(10, 10)
    widgetView:addChild(messageBox)
    
end

function onStart()
end

function onTouchDown(e)
    messageBox.textLabel:nextPage()
end