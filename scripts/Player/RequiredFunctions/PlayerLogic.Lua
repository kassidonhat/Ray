local types = require('openmw.types')
local self = require('openmw.self')
local RayEffects = require('scripts.enums.RayEffectsList')
local RayEffectsSchools = require('scripts.enums.RayEffectsSchools')




--========================================================================================================================================================================================================
--this checks if the player has enough magicka to cast a spell, it does not take any magicka from the player, just checks if they have enough
--========================================================================================================================================================================================================


local function checkMagickaFunc(cost, Cost_SCALE)
    -- Check magicka
    local magickaCost = (cost or 1) * Cost_SCALE
    if types.Actor.stats.dynamic.magicka(self).current < magickaCost then 
        return false 
    end
    return true 
end


local function checkIfRayEffectInSpell(spell)
    for key,eff in pairs(spell.effects) do
        if RayEffects[spell.effects[key].id] then
            return {check=true,RayEffectID=spell.effects[key].id}
        end
    end
    return {check=false,RayEffectID=nil}
end


local function GetRayEffectSchoolInSpell(spell)
    return RayEffectsSchools[checkIfRayEffectInSpell(spell).RayEffectID]
end




return {checkMagicka = checkMagickaFunc,
checkIfRayEffectInSpell = checkIfRayEffectInSpell,
GetRayEffectSchoolInSpell = GetRayEffectSchoolInSpell
}