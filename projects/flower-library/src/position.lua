----------------------------------------------------------------------------------------------------
-- Position Library.
-- 
-- @author Justin
-- @email justinlikefish@gmail.com
----------------------------------------------------------------------------------------------------


local screenHeight = 0
local screenWidth = 0

local M = {}

M.init = function (width, height)
	screenHeight = height
	screenWidth = width
end

-- the name of top left corner position.
M.TopLeft = 0
M.TopCenter = 1
M.TopRight = 2
M.CenterLeft = 3
M.CenterCenter = 4
M.CenterRight = 5
M.BottomLeft = 6
M.BottomCenter = 7
M.BottomRight = 8

-- calc the x pixels by X percent
M.XPercent = function (width_percent)
	return width_percent * screenWidth
end

-- calc the y pixels by Y percent
M.YPercent = function (height_percent)
	return height_percent * screenHeight
end

--  calc both x and y percent
M.Percent = function (width_percent, height_percent)
	return M.XPercent(width_percent), M.YPercent(height_percent)
end

-- get position by raw_point and x,y offset
M.GetByRawPointAndOffset = function (raw_point, offset_x, offset_y)
	local offset_x = offset_x or 0
	local offset_y = offset_y or 0
	if raw_point == TopLeft then
		return offset_x, offset_y
	elseif raw_point == M.TopCenter then
		return screenWidth / 2 + offset_x, offset_y
	elseif raw_point == M.TopRight then
		return screenWidth + offset_x, offset_y
	elseif raw_point == M.CenterLeft then
		return offset_x, screenHeight / 2 + offset_y
	elseif raw_point == M.CenterCenter then
		return screenWidth / 2 + offset_x, screenHeight / 2 + offset_y
	elseif raw_point == M.CenterRight then
		return screenWidth + offset_x, screenHeight / 2 + offset_y
	elseif raw_point == M.BottomLeft then
		return offset_x, screenHeight + offset_y
	elseif raw_point == M.BottomCenter then
		return screenWidth / 2 + offset_x, screenHeight + offset_y
	elseif raw_point == M.BottomRight then
		return screenWidth + offset_x, screenHeight + offset_y
	end
	return 0, 0
end

-- get object's anchor point by point type and the object's width, height
M.GetAnchorPoint = function (raw_point, width, height)
	if raw_point == M.TopLeft then
		return 0, 0
	elseif raw_point == M.TopCenter then
		return width / 2, 0
	elseif raw_point == M.TopRight then
		return width, 0
	elseif raw_point == M.CenterLeft then
		return 0, height / 2
	elseif raw_point == M.CenterCenter then
		return width / 2, height / 2
	elseif raw_point == M.CenterRight then
		return width, height / 2
	elseif raw_point == M.BottomLeft then
		return 0, height
	elseif raw_point == M.BottomCenter then
		return width / 2, height
	elseif raw_point == M.BottomRight then
		return width, height
	end
	return 0, 0
end

return M














