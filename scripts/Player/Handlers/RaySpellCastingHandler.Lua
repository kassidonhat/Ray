--[[]]

local input = require('openmw.input')
local types = require('openmw.types')
local self = require('openmw.self')
local anim = require('openmw.animation')
local PlayerLogic = require('scripts.Require.CustomEffectFunctions')
local I = require('openmw.interfaces')
local core = require('openmw.core')
local SpellParseFuncLocal = require('scripts.Require.RaySpecificFunctions').RaySpellParse










--========================================================================================================================================================================================================
--this handles playing the animation and sending the event for the spell logic
--========================================================================================================================================================================================================

I.AnimationController.addTextKeyHandler('spellcast', function(groupname, key)

	-- this is needed to make the player is pressing the key and not releasing it,
	-- otherwise the animation will play when the player releases the key
	if key ~= 'target start' then return end
	
	-- start the passed table and give the spell and the custom effects for this mod
	local passedTable = {SelectedSpellID = types.Actor.getSelectedSpell(self).id,
							CustomEffects = require('scripts.enums.RayEffectsList'), 
							CustomEffectSchools = require('scripts.enums.RayEffectsSchools')}
	-- checks if the spell is a ray spell and adds an attribute to the passed table if it is
	passedTable = PlayerLogic.checkIfCustomEffectInSpell(passedTable)
	


	-- checks if the player is in the correct stance and if the spell is a ray spell
    if types.Actor.getStance(self) == types.Actor.STANCE.Spell and passedTable.CustomEffectCheck then

		-- stops the default spellcast animation
        anim.cancel(self, 'spellcast')

		-- refund magicka cost for the spell, we'll handle it later
        types.Actor.stats.dynamic.magicka(self).current = types.Actor.stats.dynamic.magicka(self).current + types.Actor.getSelectedSpell(self).cost

		-- plays the raycast animation
        I.AnimationController.playBlendedAnimation('raycast', { startkey = 'start', stopkey = 'stop' ,
				priority = {
					 [anim.BONE_GROUP.RightArm] = anim.PRIORITY.Weapon,
					 [anim.BONE_GROUP.LeftArm] = anim.PRIORITY.Weapon,
					 [anim.BONE_GROUP.Torso] = anim.PRIORITY.Weapon,
					 [anim.BONE_GROUP.LowerBody] = anim.PRIORITY.WeaponLowerBody
					 } 
					 })        
		

		passedTable = SpellParseFuncLocal(passedTable)

		
		-- sends the event to the player logic script to handle the spell logic
		passedTable["EventScript"] ='PlayerLogicScript'
		self:sendEvent('PlayerEventBulider', passedTable)
	
	end
end)


--[[]]

