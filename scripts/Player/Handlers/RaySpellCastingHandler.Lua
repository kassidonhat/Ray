--[[]]

local input = require('openmw.input')
local async = require('openmw.async')
local types = require('openmw.types')
local self = require('openmw.self')
local anim = require('openmw.animation')
-- local RayEffects = require('scripts.enums.RayEffectsList')
local PlayerLogic = require('scripts.Player.RequiredFunctions.PlayerLogic')
local I = require('openmw.interfaces')



I.AnimationController.addTextKeyHandler('spellcast', function(groupname, key)

    local CurrentSpell = types.Actor.getSelectedSpell(self) 
    if types.Actor.getStance(self) == types.Actor.STANCE.Spell and 
        PlayerLogic.checkIfRayEffectInSpell(CurrentSpell).check then

        anim.cancel(self, 'spellcast')
        types.Actor.stats.dynamic.magicka(self).current = types.Actor.stats.dynamic.magicka(self).current + CurrentSpell.cost

        I.AnimationController.playBlendedAnimation('raycast', { startkey = 'start', stopkey = 'stop' ,
				priority = {
					 [anim.BONE_GROUP.RightArm] = anim.PRIORITY.Weapon,
					 [anim.BONE_GROUP.LeftArm] = anim.PRIORITY.Weapon,
					 [anim.BONE_GROUP.Torso] = anim.PRIORITY.Weapon,
					 [anim.BONE_GROUP.LowerBody] = anim.PRIORITY.WeaponLowerBody
					 } 
					 })        

	end
end)


--[[]]

