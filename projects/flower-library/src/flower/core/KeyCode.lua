----------------------------------------------------------------------------------------------------
-- Enumeration of the key on the keyboard.
----------------------------------------------------------------------------------------------------

local KeyCode = {}

--- The 0 key
KeyCode.KEY_0 = 48
--- The 1 key
KeyCode.KEY_1 = 49
--- The 2 key
KeyCode.KEY_2 = 50
--- The 3 key
KeyCode.KEY_3 = 51
--- The 4 key
KeyCode.KEY_4 = 52
--- The 5 key
KeyCode.KEY_5 = 53
--- The 6 key
KeyCode.KEY_6 = 54
--- The 7 key
KeyCode.KEY_7 = 55
--- The 8 key
KeyCode.KEY_8 = 56
--- The 9 key
KeyCode.KEY_9 = 57
--- The A key
KeyCode.KEY_A = 97
--- The B key
KeyCode.KEY_B = 98
--- The C key
KeyCode.KEY_C = 99
--- The D key
KeyCode.KEY_D = 100
--- The E key
KeyCode.KEY_E = 101
--- The F key
KeyCode.KEY_F = 102
--- The G key
KeyCode.KEY_G = 103
--- The H key
KeyCode.KEY_H = 104
--- The I key
KeyCode.KEY_I = 105
--- The J key
KeyCode.KEY_J = 106
--- The K key
KeyCode.KEY_K = 107
--- The L key
KeyCode.KEY_L = 108
--- The M key
KeyCode.KEY_M = 109
--- The N key
KeyCode.KEY_N = 110
--- The O key
KeyCode.KEY_O = 111
--- The P key
KeyCode.KEY_P = 112
--- The Q key
KeyCode.KEY_Q = 113
--- The R key
KeyCode.KEY_R = 114
--- The S key
KeyCode.KEY_S = 115
--- The T key
KeyCode.KEY_T = 116
--- The U key
KeyCode.KEY_U = 117
--- The V key
KeyCode.KEY_V = 118
--- The W key
KeyCode.KEY_W = 119
--- The X key
KeyCode.KEY_X = 120
--- The Y key
KeyCode.KEY_Y = 121
--- The Z key
KeyCode.KEY_Z = 122
--- The space key
KeyCode.KEY_SPACE = 32
--- The left shift key
KeyCode.KEY_LEFT_SHIFT = 481
--- The right shift key
KeyCode.KEY_RIGHT_SHIFT = 485
--- The left Ctrl key
KeyCode.KEY_LEFT_CTRL = 480
--- The right Ctrl key
KeyCode.KEY_RIGHT_CTRL = 484
--- The left alt key
KeyCode.KEY_LEFT_ALT = 482
--- The right alt key
KeyCode.KEY_RIGHT_ALT = 486
--- The backspace key
KeyCode.KEY_BACKSPACE = 8
--- The tab key
KeyCode.KEY_TAB = 9
--- The enter key
KeyCode.KEY_ENTER = 13
--- The insert key
KeyCode.KEY_INSERT = 329
--- The delete key
KeyCode.KEY_DELETE = 127
--- The home key
KeyCode.KEY_HOME = 330
--- The end key
KeyCode.KEY_END = 333
--- The page-up key
KeyCode.KEY_PAGE_UP = 331
--- The page-down key
KeyCode.KEY_PAGE_DOWN = 334
--- The cursor-left key
KeyCode.KEY_LEFT = 336
--- The cursor-right key
KeyCode.KEY_RIGHT = 335
--- The cursor-up key
KeyCode.KEY_UP = 338
--- The cursor-down key
KeyCode.KEY_DOWN = 337
--- The escape key
KeyCode.KEY_ESCAPE = 27
--- The F1 key
KeyCode.KEY_F1 = 314
--- The F2 key
KeyCode.KEY_F2 = 315
--- The F3 key
KeyCode.KEY_F3 = 316
--- The F4 key
KeyCode.KEY_F4 = 317
--- The F5 key
KeyCode.KEY_F5 = 318
--- The F6 key
KeyCode.KEY_F6 = 319
--- The F7 key
KeyCode.KEY_F7 = 320
--- The F8 key
KeyCode.KEY_F8 = 321
--- The F9 key
KeyCode.KEY_F9 = 322
--- The F10 key
KeyCode.KEY_F10 = 323
--- The F11 key
KeyCode.KEY_F11 = 324
--- The F12 key
KeyCode.KEY_F12 = 325
--- The print screen key
KeyCode.KEY_PRINT_SCREEN = 326
--- The scroll lock key
KeyCode.KEY_SCROLL_LOCK = 327
--- The pause key
KeyCode.KEY_PAUSE = 328
--- The caps lock key
KeyCode.KEY_CAPS_LOCK = 313
--- The num-lock key on the number pad
KeyCode.KEY_NUM_LOCK = 339
--- The divide key on the number pad
KeyCode.KEY_NUM_DIVIDE = 340
--- The times key on the number pad
KeyCode.KEY_NUM_TIMES = 341
--- The minus key on the number pad
KeyCode.KEY_NUM_MINUS = 342
--- The plus key on the number pad
KeyCode.KEY_NUM_PLUS = 343
--- The enter key on the number pad
KeyCode.KEY_NUM_ENTER = 344
--- The point key on the number pad
KeyCode.KEY_NUM_POINT = 355
--- The 0 key on the number pad
KeyCode.KEY_NUM_0 = 354
--- The 1 key on the number pad
KeyCode.KEY_NUM_1 = 345
--- The 2 key on the number pad
KeyCode.KEY_NUM_2 = 346
--- The 3 key on the number pad
KeyCode.KEY_NUM_3 = 347
--- The 4 key on the number pad
KeyCode.KEY_NUM_4 = 348
--- The 5 key on the number pad
KeyCode.KEY_NUM_5 = 349
--- The 6 key on the number pad
KeyCode.KEY_NUM_6 = 350
--- The 7 key on the number pad
KeyCode.KEY_NUM_7 = 351
--- The 8 key on the number pad
KeyCode.KEY_NUM_8 = 352
--- The 9 key on the number pad
KeyCode.KEY_NUM_9 = 353

---
-- Returns Shift Key has been pressed.
-- @param key Key code.
-- @return True if it is Shift Key.
function KeyCode.isShiftKey(key)
    return key == KeyCode.KEY_LEFT_SHIFT or key == KEY_RIGHT_SHIFT
end

---
-- Returns Ctrl Key has been pressed.
-- @param key Key code.
-- @return True if it is Ctrl Key.
function KeyCode.isCtrlKey(key)
    return key == KeyCode.KEY_LEFT_CTRL or key == KEY_RIGHT_CTRL
end

---
-- Returns Alt Key has been pressed.
-- @param key Key code.
-- @return True if it is Alt Key.
function KeyCode.isAltKey(key)
    return key == KeyCode.KEY_LEFT_ALT or key == KEY_RIGHT_ALT
end

return KeyCode