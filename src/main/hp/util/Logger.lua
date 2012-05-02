local M = {}

-- 定数
M.LEVEL_NONE = 0
M.LEVEL_INFO = 1
M.LEVEL_WARN = 2
M.LEVEL_ERROR = 3
M.LEVEL_DEBUG = 4

-- 変数
M.level = M.LEVEL_DEBUG

---------------------------------------
-- 通常ログを出力します.
---------------------------------------
function M.info(...)
    if M.level >= M.LEVEL_INFO then
        print("[info]", ...)
    end
end

---------------------------------------
-- 警告ログを出力します.
---------------------------------------
function M.warn(...)
    if M.level >= M.LEVEL_WARN then
        print("[warn]", ...)
    end
end

---------------------------------------
-- エラーログを出力します.
---------------------------------------
function M.error(...)
    if M.level >= M.LEVEL_ERROR then
        print("[error]", ...)
    end
end

---------------------------------------
-- デバッグログを出力します.
---------------------------------------
function M.debug(...)
    if M.level >= M.LEVEL_DEBUG then
        print("[debug]", ...)
    end
end

return M