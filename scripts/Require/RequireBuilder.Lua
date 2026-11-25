


local function grabDataFromString(stringPassed,Pattern,deleteCharacterL,deleteCharacterR)
    -- find the part of the string that we want
	local i, j = string.find(stringPassed, Pattern)


    -- string.sub cuts the other data out of the string 
    -- the g.sub statments get rid of the string identifier and separators
	local returnstring = string.gsub(string.sub(stringPassed,i,j),deleteCharacterL,"")
	local returnstring = string.gsub(returnstring,deleteCharacterR,"")
	return returnstring
end


local function dependencyInjectionFunc(stringPassed,FuncTablePassed,IndexPositionPassed)

    stringPassed =grabDataFromString(stringPassed,"DependencyInjection:[,%d]+#","DependencyInjection:","")
    local indexesForInjection ={}
    local indexer = 0
    repeat
        indexer = indexer+1
        indexesForInjection[indexer] = grabDataFromString(stringPassed,"%d+","","")
        local i,j = string.find(stringPassed,"%d+,-")
        stringPassed = string.sub(stringPassed,j+1,string.len(stringPassed))
    until string.find(stringPassed,"%d+") == nil


    local DependencyObject = FuncTablePassed[IndexPositionPassed]("DependencyInjection")

    local function injectOrParse(CurrentTable,indexesForInjection,FuncTableObject,currentIndex)

        local returnTable = {}
        for k,v in pairs(CurrentTable) do
            if(CurrentTable == FuncTableObject) then currentIndex = k end

            if type(v) == "function" and indexesForInjection[k] then
                returnTable = {}

            end

            --if the current FuncTableObject is a table, recurse and run
            if type(v) == "table" then
                
                for k, v in pairs(FuncTableObject) do
                    -- here's where the recursion happens
                    -- tables inside of the func table happen when we need to modify a function
                    passedTable=CallOrParse(v,passedTable)

                    -- this statement is what's used to break out of the current table loop 
                    -- from inside of the table we're currently iterating through
                    if passedTable["BreakCheck"] then
                        passedTable["BreakCheck"] = nil
                        break
                    end
                end

            end


        end
    end

end



function RequireBuilderFunc(scriptType,Passed)
    local FuncTable = {}
    for k,v in pairs(Passed) do

        -- checks if the table value is part of the function list we are currently constructing
        if(string.find(k,scriptType.."#"))then

            -- grabs the index position of the function
            -- without this, we can't decide the order the functions run in
            local IndexPosition = grabDataFromString(k,"#IndexPostion:%d+#","#IndexPostion:","#")

            -- get the path to the file where the function is stored
            local FunctionLoc = grabDataFromString(k,"ScriptPath:[.%w]+#","ScriptPath:","#")

            -- we require the script at the path we just found, 
            local reqTable = require(FunctionLoc)

            -- pull the function we want, 
            -- and add it to the table
            FuncTable[tonumber(IndexPosition)] = reqTable[v]
                
            if(string.find(k,"#DependencyInjection:"))then dependencyInjectionFunc(k,FuncTable,IndexPosition)end
            
        end
        
    end

    -- pass that table of functions back when we're done
    return FuncTable
end








--========================================================================================================================================================================================================
--This runs the function table after it's been assembled
--========================================================================================================================================================================================================
function CallOrParse(FuncTableObject,passedTable)
    
    --if the current FuncTableObject is a function, run it
    if type(FuncTableObject) == "function" then
        passedTable = FuncTableObject(passedTable)
    end

    --if the current FuncTableObject is a table, recurse and run
    if type(FuncTableObject) == "table" then
        
        for k, v in pairs(FuncTableObject) do
            -- here's where the recursion happens
            -- tables inside of the func table happen when we need to modify a function
            passedTable=CallOrParse(v,passedTable)

            -- this statement is what's used to break out of the current table loop 
            -- from inside of the table we're currently iterating through
            if passedTable["BreakCheck"] then
                passedTable["BreakCheck"] = nil
                break
            end
        end

    end

    return passedTable
end



return {RequireBuilder=RequireBuilderFunc,
        CallOrParse=CallOrParse
    }