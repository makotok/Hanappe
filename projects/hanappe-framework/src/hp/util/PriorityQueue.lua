--------------------------------------------------------------------------------
-- 優先度付きキューです.<br>
-- comparetorによるソートを行いながらオブジェクトを追加します.<br>
--------------------------------------------------------------------------------
local class = require("hp/lang/class")

local M = class()

---------------------------------------
-- Functions
---------------------------------------

----------------------------------------
-- コンストラクタです.
-- @param comparetor
----------------------------------------
function M:init(comparetor)
    assert(comparetor, "comparetor is nil!")
    self.queue = {}
    self.comparetor = comparetor
end

----------------------------------------
-- オブジェクトを順序付けて追加します.
-- @param object オブジェクト
----------------------------------------
function M:push(object)
    self:remove(object)

    local comparetor = assert(self.comparetor)
    local index = 0
    for i, v in ipairs(self.queue) do
        index = i
        if comparetor(object, v) > 0 then
            break
        end
    end
    index = index + 1
    table.insert(self.queue, index, object)
end

----------------------------------------
-- キューの先頭オブジェクト削除してから返します.<br>
-- キューに存在しない場合はnilを返します.
-- @return object
----------------------------------------
function M:poll()
    if self:size() > 0 then
        return table.remove(self.queue, 1)
    end
    return nil
end

----------------------------------------
-- 指定したインデックスのオブジェクトを返します.
-- @param i インデックス
-- @return object
----------------------------------------
function M:get(i)
    return self.queue[i]
end


----------------------------------------
-- 指定したオブジェクトが存在する場合削除します.
-- 存在しない場合は削除しません.
-- @param object オブジェクト
-- @return 削除した場合はそのオブジェクト
----------------------------------------
function M:remove(object)
    for i, v in ipairs(self.queue) do
        if object == v then
            return table.remove(self.queue, i)
        end
    end
    return nil
end

----------------------------------------
-- キューの内容をクリアします.
----------------------------------------
function M:clear()
    self.queue = {}
end

----------------------------------------
-- for文で使用できる for each関数です.<br>
----------------------------------------
function M:each()
    return ipairs(self.queue)
end

----------------------------------------
-- キューのサイズを返します.
-- @return キューのサイズ.
----------------------------------------
function M:size()
    return #self.queue
end

return M
