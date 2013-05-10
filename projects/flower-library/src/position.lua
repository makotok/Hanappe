----------------------------------------------------------------------------------------------------
-- Position Library.
-- 
-- @author Justin
-- @email justinlikefish@gmail.com
----------------------------------------------------------------------------------------------------


local screenHeight = 0
local screenWidth = 0

function init(width, height)
	screenHeight = height
	screenWidth = width
end

-- the name of top left corner position.
TopLeft = 0
TopCenter = 1
TopRight = 2
CenterLeft = 3
CenterCenter = 4
CenterRight = 5
BottomLeft = 6
BottomCenter = 7
BottomRight = 8

-- calc the x pixels by X percent
function XPercent(width_percent)
	return width_percent * screenWidth
end

-- calc the y pixels by Y percent
function YPercent(height_percent)
	return height_percent * screenHeight
end

--  calc both x and y percent
function Percent(width_percent, height_percent)
	return XPercent(width_percent), YPercent(height_percent)
end

-- get position by raw_point and x,y offset
function GetByRawPointAndOffset(raw_point, offset_x, offset_y)
	local offset_x = offset_x or 0
	local offset_y = offset_y or 0
	if raw_point == TopLeft then
		return offset_x, offset_y
	elseif raw_point == TopCenter then
		return screenWidth / 2 + offset_x, offset_y
	elseif raw_point == TopRight then
		return screenWidth + offset_x, offset_y
	elseif raw_point == CenterLeft then
		return offset_x, screenHeight / 2 + offset_y
	elseif raw_point == CenterCenter then
		return screenWidth / 2 + offset_x, screenHeight / 2 + offset_y
	elseif raw_point == CenterRight then
		return screenWidth + offset_x, screenHeight / 2 + offset_y
	elseif raw_point == BottomLeft then
		return offset_x, screenHeight + offset_y
	elseif raw_point == BottomCenter then
		return screenWidth / 2 + offset_x, screenHeight + offset_y
	elseif raw_point == BottomRight then
		return screenWidth + offset_x, screenHeight + offset_y
	end
	return 0, 0
end

-- get object's anchor point by point type and the object's width, height
function GetAnchorPoint(raw_point, width, height)
	if raw_point == TopLeft then
		return 0, 0
	elseif raw_point == TopCenter then
		return width / 2, 0
	elseif raw_point == TopRight then
		return width, 0
	elseif raw_point == CenterLeft then
		return 0, height / 2
	elseif raw_point == CenterCenter then
		return width / 2, height / 2
	elseif raw_point == CenterRight then
		return width, height / 2
	elseif raw_point == BottomLeft then
		return 0, height
	elseif raw_point == BottomCenter then
		return width / 2, height
	elseif raw_point == BottomRight then
		return width, height
	end
	return 0, 0
end
















