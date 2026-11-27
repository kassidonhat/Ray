
local function IsolateDataSectionOfstring(stringPassed,Pattern)
    -- find the part of the string that we want
    local i, j = string.find(stringPassed, Pattern)
    --return just that part
    return string.sub(stringPassed,i,j)
end



local function GrabDataFromString(stringPassed,Pattern,deleteCharacterL,deleteCharacterR)

    -- the g.sub statments get rid of the string identifier and separators
	local returnstring = string.gsub(IsolateDataSectionOfstring(stringPassed,Pattern),deleteCharacterL,"")
	local returnstring = string.gsub(returnstring,deleteCharacterR,"")
	return returnstring
end



local function GrabListFromString(stringPassed,EntryPatttern,Delimiter)

    local stringHolder = stringPassed

    -- cut off un-needed delimiters
    if string.sub(stringHolder,1,1) == Delimiter then 
        stringHolder = string.sub(stringHolder,2,string.len(stringHolder))
    end

    if string.sub(stringHolder,string.len(stringHolder),string.len(stringHolder)) == Delimiter then 
        stringHolder = string.sub(stringHolder,1,string.len(stringHolder)-1)
    end

    -- get list length
    local StringWithoutDelimiterLength = string.len(string.gsub(stringHolder,Delimiter,""))
    local StringWithDelimiterLength = string.len(stringHolder)
    local numberOfItemsInList = StringWithDelimiterLength-StringWithoutDelimiterLength+1

    -- loop through and grab each entry
    local returnList = {}
    for i=1,numberOfItemsInList, 1 do
        returnList[i] = IsolateDataSectionOfstring(stringHolder,EntryPatttern)
        stringHolder = string.gsub(stringHolder,returnList[i]..Delimiter,"")
    end

    return returnList
end


return {IsolateDataSectionOfstring=IsolateDataSectionOfstring,
        GrabDataFromString=GrabDataFromString,
        GrabListFromString=GrabListFromString
}