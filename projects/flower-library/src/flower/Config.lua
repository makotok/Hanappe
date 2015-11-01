----------------------------------------------------------------------------------------------------
-- Config class.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

local Config = {}

--- default width of the window
Config.WINDOW_TITLE = "no titile"

--- default width of the window
Config.WINDOW_WIDTH = 320

--- default height of the window
Config.WINDOW_HEIGHT = 480

--- default scale of the viewport
Config.VIEWPORT_SCALE = 1

--- default y behavior; set to true to have y=0 be the bottom of the screen
Config.VIEWPORT_YFLIP = false

--- default blending mode for images
Config.BLEND_MODE = nil

--- Max width for fit size.
Config.LABEL_MAX_FIT_WIDTH = 10000000

--- Max height for fit size.
Config.LABEL_MAX_FIT_HEIGHT = 10000000

--- default fit length.
Config.LABEL_MAX_FIT_LENGTH = 10000000

--- default fit padding.
Config.LABEL_FIT_PADDING = 2

--- Whether to high quality automatically drawing the label
Config.LABEL_HIGH_QUALITY_ENABLED = false

--- Default Texture filter
Config.TEXTURE_DEFAULT_FILTER = MOAITexture.GL_LINEAR

--- Whether to fire a touch event on the desktop environment
Config.TOUCH_EVENT_ENABLED = true

--- Whether to fire a mouse event on the desktop environment
Config.MOUSE_EVENT_ENABLED = true

--- Default scene destroy enabled
Config.SCENE_CLOSED_DESTROY_ENABLED = true

--- Default font file
Config.FONT_NAME = "VL-PGothic.ttf"

--- Default font charcodes
Config.FONT_CHARCODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-"

--- Default font points
Config.FONT_POINTS = 24

--- Default font dpi
Config.FONT_DPI = 72

--- Default font filter
Config.FONT_FILTER = MOAITexture.GL_LINEAR

return Config
