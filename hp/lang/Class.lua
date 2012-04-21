-- import
local table = require("hs/lang/table")

--------------------------------------------------------------------------------
-- クラスベースなオブジェクト指向を簡単に実現するためのクラスです.<br>
-- クラスの基本的な機能を有します.<br>
-- setmetatableによる継承ではなく、テーブルに展開する事で<br>
-- 継承が多くなった場合でもパフォーマンスが劣化しません.<br>
-- @class table
-- @name Class
--------------------------------------------------------------------------------
local M = {I = {}}
local I = M.I

local meta = {__index = M}

----------------------------------------
-- Functions
----------------------------------------

----------------------------------------
-- クラス定義関数です.
-- @return Classのコピー
----------------------------------------
function M:__call()
    local class = {}
    table.deepCopy(self, class)
    class.__base = self
    return class
end

----------------------------------------
-- インスタンスの生成を行います.
-- @param ... コンストラクタに渡すパラメータ.
-- @return インスタンス
----------------------------------------
function M:new(...)
   local obj = {}
   obj.__index = self.I
   setmetatable(obj, obj)
   if obj.init then
      obj:init(...)
   end
   return obj
end

----------------------------------------
-- コンストラクタです.<br>
-- Classを継承した子クラスは、この関数で初期化します.
-- @param ... パラメータ
----------------------------------------
function M:init(...)
end

----------------------------------------
-- 親クラスのコンストラクタを呼びます.
-- @param obj 自身のオブジェクトを指定
-- @param ... コンストラクタに渡すパラメータ
----------------------------------------
function M:super(obj, ...)
    if self.__base then
        self.__base.init(obj, ...)
    end
end

----------------------------------------
-- インスタンスが指定したクラスのインスタンスかどうか判定を行います.
-- @param class 判定したいClassを指定.
-- @return classを継承していた場合はtrue.
----------------------------------------
function I:instanceOf(class)
    if self == class then
        return true
    end
    if self.__index == class then
        return true
    end
    if self.__base then
        return self.__base:instanceOf(class)
    end
    return false
end

----------------------------------------
-- インスタンスかクラス判定して、クラスの場合にtrueを返します.
-- @return Classの場合はtrue
----------------------------------------
function I:isClass()
    return self.__index == nil
end

----------------------------------------
-- インスタンスかクラス判定して、インスタンスの場合にtrueを返します.
-- @return Instanceの場合はtrue
----------------------------------------
function I:isInstance()
    return self.__index ~= nil
end

return M
