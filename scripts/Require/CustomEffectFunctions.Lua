local self = require('openmw.self')
local types = require('openmw.types')



local function checkIfCustomEffectInSpell(PassedTable)
    local SelectedSpell = types.Actor.getSelectedSpell(self)
    for key,eff in pairs(SelectedSpell.effects) do
        if PassedTable.CustomEffects[SelectedSpell.effects[key].id] then
            PassedTable['CustomEffectID'] = SelectedSpell.effects[key].id
            PassedTable['CustomEffectCheck'] = true
            return PassedTable
        end
    end
    PassedTable['CustomEffectID'] = nil
    PassedTable['CustomEffectCheck'] = false
    return PassedTable
end


local function GetCustomEffectSchoolInSpell(PassedTable)
    PassedTable['CustomEffectSchool'] = PassedTable.CustomEffectSchools[checkIfCustomEffectInSpell(PassedTable).CustomEffectID]
    return PassedTable
end

return {
checkIfCustomEffectInSpell = checkIfCustomEffectInSpell,
GetCustomEffectSchoolInSpell = GetCustomEffectSchoolInSpell
}