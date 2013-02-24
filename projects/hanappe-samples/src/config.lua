-- MOAISim setting
MOAISim.setStep ( 1 / 60 )
MOAISim.clearLoopFlags ()
MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_ALLOW_BOOST )
MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_LONG_DELAY )
MOAISim.setBoostThreshold ( 0 )

-- Text Label
TextLabel.DEFAULT_COLOR = {0, 0, 0, 1}

-- Application config
local config = {
    title = "Hanappe samples",
    screenWidth = MOAIEnvironment.horizontalResolution or 320,
    screenHeight = MOAIEnvironment.verticalResolution or 480,
    mainScene = "samples/sample_scene",
}

return config