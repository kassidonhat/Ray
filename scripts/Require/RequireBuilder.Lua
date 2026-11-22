


function RequireBuilderFunc(scriptType,Passed)
    local FuncTable = {}
    for k,v in pairs(Passed) do

        -- checks if the table value is part of the function list we are currently constructing
        if(string.find(k,scriptType.."#"))then

            -- grabs the index position of the function
            -- without this, we can't decide the order the functions run in
            local i, j = string.find(k, "#%d+#")
            local IndexPosition = string.gsub(string.sub(k,i,j),"#","")

            -- these two lines delete parts of the string so we can get the path to the script where the function is stored
            local FunctionLoc = string.gsub(k,"#%d+#ScriptType#"..scriptType.."#ScriptPath:","")
            FunctionLoc = string.gsub(FunctionLoc,"#"..v,"")

            -- we require the script at the path we just found, 
            -- pull the function we want, 
            -- and add it to the table
            local reqTable = require(FunctionLoc)
            FuncTable[tonumber(IndexPosition)] = reqTable[v]


        end
        
    end

    -- pass that table of functions back when we're done
    return FuncTable
end


return {RequireBuilder=RequireBuilderFunc}