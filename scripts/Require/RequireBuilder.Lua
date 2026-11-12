


function RequireBuilderFunc(scriptType,Passed)
    local FuncTable = {}
    for k,v in pairs(Passed) do

        if(string.find(k,scriptType.."#"))then
            local FunctionLoc = string.gsub(k,"ScriptType#"..scriptType.."#ScriptPath:","")
            FunctionLoc = string.gsub(FunctionLoc,"#"..v,"")
            local reqTable = require(FunctionLoc)
            FuncTable[v] = reqTable[v]

        end
        
    end
    return FuncTable
end


return {RequireBuilder=RequireBuilderFunc}