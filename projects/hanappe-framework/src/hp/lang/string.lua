--------------------------------------------------------------------------------
-- modules that extend functionality of the string.
--------------------------------------------------------------------------------
local M = {}
setmetatable(M, {__index = string})
local string = M

--------------------------------------------------------------------------------
-- Converts the string to number, or returns string if fail.
--------------------------------------------------------------------------------
function string.toNumber( self )
    if type( tonumber( self ) ) =="number" then
        return tonumber( self )
    else
        return self
    end
end

--------------------------------------------------------------------------------
--  Converts number to string, filling in zeros at beginning.
--  Technically, this shouldn't really extend string class
--  because it doesn't operate on string (doesn't have a "self" )
--  Usage:  print( string.fromNumbersWithZeros( 421, 6 ) )
--          000421
--------------------------------------------------------------------------------
function string.fromNumberWithZeros( n, l )
    local s = tostring ( n )
    local sl = string.len ( s )
    if sl < l then
        -- add zeros before
        for i=1, l - sl do
            s = "0"..s
        end
    end
    return s
end

--------------------------------------------------------------------------------
--  Converts hex number to rgb (format: #FF00FF)
--------------------------------------------------------------------------------
function string.hexToRGB( s, returnAsTable )
    if returnAsTable then
        return  { tonumber ( string.sub( s, 2, 3 ),16 )/255.0,
                tonumber ( string.sub( s, 4, 5 ),16 )/255.0,
                tonumber ( string.sub( s, 6, 7 ),16 )/255.0 }
    else
        return  tonumber ( string.sub( s, 2, 3 ),16 )/255.0,
                tonumber ( string.sub( s, 4, 5 ),16 )/255.0,
                tonumber ( string.sub( s, 6, 7 ),16 )/255.0
    end
end


--------------------------------------------------------------------------------
-- Splits string into N lines, using default ("#") or custom delimiter
-- Routine separate words by spaces so make sure you have them.
-- USAGE:   For a string "width:150 height:150", or "width:150_height:150"
--          returns a table { width=150, height=150 }
--------------------------------------------------------------------------------
function string.toTable( self, delimiter )

    local t = {}

    if not delimiter then delimiter = " " end
    local kvPairs = self:split( delimiter )

    local k, v, kvPair

    for i=1, #kvPairs do
        kvPair = kvPairs[i]:split( ":" )

        if #kvPair == 2 then
            t[ kvPair[1] ] = string.toNumber( kvPair[2] )
        end

    end


    return t
end

--------------------------------------------------------------------------------
-- Splits string into a table of strings using delimiter.<br>
-- Usage: local table = a:split( ",", false )<br>
-- TODO:  Does not correspond to multi-byte.<br>
-- @param self string.
-- @param delim Delimiter.
-- @param toNumber If set to true or to be converted to a numeric value.
-- @return Split the resulting table
--------------------------------------------------------------------------------
function string.split( self, delim, toNumber )
    
    local start = 1
    local t = {}  -- results table
    local newElement
    -- find each instance of a string followed by the delimiter
    while true do
        local pos = string.find (self, delim, start, true) -- plain find
        if not pos then
            break
        end
        -- force to number
        newElement = string.sub (self, start, pos - 1)
        if toNumber then
            newElement = newElement:toNumber()
        end
        table.insert (t, newElement)
        start = pos + string.len (delim)
    end -- while

    -- insert final one (after last delimiter)
    local value =  string.sub (self, start)
    if toNumber then
        value = value:toNumber()
    end
    table.insert (t,value )
    return t
end

--------------------------------------------------------------------------------
-- Splits string into N lines, using default ("#") or custom delimiter
-- Routine separate words by spaces so make sure you have them.
-- Usage: local string = s:splitIntoLines( 3, "\n" )
--------------------------------------------------------------------------------
function string.splitToLines( self, numLines, delim )
    
    local result = ""
    delim = delim or "#"    -- Default delimiter used for display.newText

    numLines = numLines or 2
    -- break into all words.
    local allWords = self:split( " " )
    if #allWords < numLines then
        numLines = #allWords
    end

    -- Words per line
    local wordsPerLine = math.ceil( #allWords/numLines )
    local counter = wordsPerLine

    for i=1, #allWords do
        result = result..allWords[i]
        counter = counter - 1
        if counter == 0 and i<#allWords then
            counter = wordsPerLine
            result = result..delim
        else
            result = result.." "
        end
    end

    return result
end

------------------------------------------------------------------------------
--  String encryption
--------------------------------------------------------------------------------
function string.encrypt( str, code )
    code = code or math.random(3,8)
    local newString = string.char( 65 + code )
    local newChar
    for i=1, str:len() do
        newChar = str:byte(i) + code
        newString = newString..string.char(newChar)
    end
    return newString
end

------------------------------------------------------------------------------
--  String encryption
--------------------------------------------------------------------------------
function string.decrypt( str )
    local newString = ""
    local code = str:byte(1) - 65
    for i = 2, str:len() do
        newChar = str:byte(i) - code
        newString = newString..string.char(newChar)
    end
    return newString
end

return M
