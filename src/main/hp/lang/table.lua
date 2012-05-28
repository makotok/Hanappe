--------------------------------------------------------------------------------
-- tableの機能拡張したモジュールです.
-- @class table
-- @name table
--------------------------------------------------------------------------------
local table = table
local M = {}
setmetatable(M, {__index = table})

-- Lua5.1とLua5.2の互換性を保つ実装
if unpack then
    M.unpack = unpack
end

--------------------------------------------------------------------------------
-- 配列から一致する値を検索して、見つかった位置を返します.
-- @param array 配列
-- @param value 検索する値
-- @return 見つかった場合はindex,ない場合は0
--------------------------------------------------------------------------------
function M.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return 0
end

--------------------------------------------------------------------------------
-- テーブルをコピーします.
--------------------------------------------------------------------------------
function M.copy(src, dest)
    dest = dest and dest or {}
    for i, v in pairs(src) do
        dest[i] = v
    end
    return dest
end

--------------------------------------------------------------------------------
-- テーブルをディープコピーします.
-- destを指定しない場合は新規テーブルを生成して返します.
-- @param src コピー元
-- @param dest コピー先(option)
-- @return コピー後テーブル
--------------------------------------------------------------------------------
function M.deepCopy(src, dest)
    dest = dest and dest or {}
    for i, v in pairs(src) do
        if type(v) == "table" then
            dest[i] = {}
            M.deepCopy(v, dest[i])
        else
            dest[i] = v
        end
    end
    return dest
end

--------------------------------------------------------------------------------
-- テーブルに要素を追加します.
-- 要素が存在した場合、要素は追加せずにfalseを返します.
-- 要素が存在しない場合、要素を追加してtrueを返します.
--------------------------------------------------------------------------------
function M.insertElement(t, o)
    if M.indexOf(t, o) > 0 then
        return false
    end
    M.insert(t, o)
    return true
end

--------------------------------------------------------------------------------
-- テーブルから要素を削除します.
-- 削除に成功した場合は、元のインデックスを返します.
-- 要素がない場合は、0を返します.
--------------------------------------------------------------------------------
function M.removeElement(t, o)
    local i = M.indexOf(t, o)
    if i == 0 then
        return 0
    end
    M.remove(t, o)
    return i
end

return M
