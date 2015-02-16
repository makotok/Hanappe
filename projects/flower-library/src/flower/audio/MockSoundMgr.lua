----------------------------------------------------------------------------------------------------
-- Mock for the environment without Sound.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local BaseSoundMgr = require "flower.audio.BaseSoundMgr"

--- class
local MockSoundMgr = class(BaseSoundMgr)

---
-- Constructor.
function MockSoundMgr:init()
end

return MockSoundMgr