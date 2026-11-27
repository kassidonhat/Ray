local StringParseLib = require('scripts.Require.StringParseFunctions')





local function grabTableFromFile(stringPassed)
    -- get the path to the file where the function is stored
    local FunctionLoc = StringParseLib.GrabDataFromString(stringPassed,"ScriptPath:[.%w]+#","ScriptPath:","#")

    -- we require the script at the path we just found and return    
    return require(FunctionLoc)
end




local function createDependencyTable(Passed)

    local DependencyTable = {}
    for k,v in pairs(Passed) do
        -- if(string.find(k,scriptType.."#") and string.find(k,"#DependencyInjection#"))then
        if v["DependencyInjection"]then
             
            -- local reqTable = grabTableFromFile(k)
            local reqTable = require(v["ScriptPath"])

            -- pass the function the string "DependencyInjection"
            -- the functions that have injectables will read this and return said injectables
            local DependencyFunc,DependencyName = reqTable[v["FunctionName"]]("DependencyInjection")

            -- store the injectable with it's name
            DependencyTable[DependencyName]=DependencyFunc
        end

    end

    return DependencyTable
end


local function DependencyInjectionFunc(OriginalFunc,StringPassed,DependencyTable)

    local wholeListString = StringParseLib.GrabDataFromString(StringPassed,"#Dependencies:[%w-,]+#","#Dependencies:","#")
    -- local FunctionOrder = StringParseLib.GrabListFromString(wholeListString,"[%w-]+",",")
    
    -- for i,v in pairs(FunctionOrder) do
    --     print(v)
    -- end
    
end


local function ParseStringIntoInstructionTable(PassedString)
    -- break up the data in the string into the data labels and data values
    local listOfDataStrips = StringParseLib.GrabListFromString(PassedString,"[^#]+","#")

    local instructionTable = {}
    for k,v in pairs(listOfDataStrips) do
        -- seperate the Labels and the data and place them in the table as key and value
        instructionTable[string.gsub(v,":[^:]+","")] = string.gsub(v,"[^:]+:","")
    end

    return instructionTable
end



local function filterPassedTableToUsedScriptType(scriptType,Passed)
    local AssemblyInstructions = {}
    
    for k,v in pairs(Passed) do
        -- checks if the table value is part of the function list we are currently constructing
        if(string.find(k,scriptType.."#"))then 
            -- send the string to get parsed into a table
            AssemblyInstructions[k] = ParseStringIntoInstructionTable(k)
        end
    end

    return AssemblyInstructions
end






function RequireBuilderFunc(scriptType,Passed)

    local AssemblyInstructions = filterPassedTableToUsedScriptType(scriptType,Passed)



    local FuncTable = {}
    -- local DependencyTable = createDependencyTable(scriptType,Passed)
    local DependencyTable = createDependencyTable(AssemblyInstructions)


    for k,v in pairs(AssemblyInstructions) do


        -- we get the table that has the function, 
        local reqTable = require(v["ScriptPath"])
        
        --check if the function needs dependency injection
        -- if(string.find(k,"#Dependencies:"))then reqTable[v] = end
        -- if(string.find(k,"#Dependencies:"))then 
        --     DependencyInjectionFunc(reqTable[v],k,DependencyTable)
        -- end

        -- pull the function we want, 
        -- and add it to the table
        FuncTable[tonumber(v["IndexPosition"])] = reqTable[v["FunctionName"]]
        
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