local M = {}

-- 定数
M.LEVEL_NONE = 0
M.LEVEL_INFO = 1
M.LEVEL_WARN = 2
M.LEVEL_ERROR = 3
M.LEVEL_DEBUG = 4

--------------------------------------------------------------------------------
-- 指定のレベルのログを出力するか
--------------------------------------------------------------------------------
M.selector = {}
M.selector[M.LEVEL_INFO] = true
M.selector[M.LEVEL_WARN] = true
M.selector[M.LEVEL_ERROR] = true
M.selector[M.LEVEL_DEBUG] = true

--------------------------------------------------------------------------------
-- コンソールに出力するターゲットです
--------------------------------------------------------------------------------
M.CONSOLE_TARGET = function(...)
   print(...)
end

M.logTarget = M.CONSOLE_TARGET

--------------------------------------------------------------------------------
-- 通常ログを出力します.
--------------------------------------------------------------------------------
function M.info(...)
    if M.selector[M.LEVEL_INFO] then
        M.logTarget("[info]", ...)
    end
end

---------------------------------------
-- 警告ログを出力します.
---------------------------------------
function M.warn(...)
    if M.selector[M.LEVEL_WARN] then
        M.logTarget("[warn]", ...)
    end
end

---------------------------------------
-- エラーログを出力します.
---------------------------------------
function M.error(...)
    if M.selector[M.LEVEL_ERROR] then
        M.logTarget("[error]", ...)
    end
end

---------------------------------------
-- デバッグログを出力します.
---------------------------------------
function M.debug(...)
    if M.selector[M.LEVEL_DEBUG] then
        M.logTarget("[debug]", ...)
    end
end

return M