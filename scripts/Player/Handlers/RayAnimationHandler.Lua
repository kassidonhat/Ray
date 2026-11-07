local types = require('openmw.types')
local self = require('openmw.self')
local UIInter = require('openmw.interfaces').UI
local anim = require('openmw.animation')
local I = require('openmw.interfaces')
local input = require('openmw.input')
local async = require('openmw.async')




--========================================================================================================================================================================================================
--this handles the player animations
--========================================================================================================================================================================================================




input.registerActionHandler('Use', async:callback(function()

	if anim.isPlaying(self, 'raycastloop') then
		anim.cancel(self, 'raycast')
		anim.cancel(self, 'raycastloop')
		self:sendEvent('ResetSoundTimerEvent')
	end

	if anim.isPlaying(self, 'raycast') then
		anim.cancel(self, 'raycast')
		anim.cancel(self, 'raycastloop')
		self:sendEvent('ResetSoundTimerEvent')
	end

end))


I.AnimationController.addTextKeyHandler('raycast', function(groupname, key)
	if key == 'stop' then
		I.AnimationController.playBlendedAnimation('raycastloop', { startkey = 'start', stopkey = 'stop' ,
		priority = {
			 [anim.BONE_GROUP.RightArm] = anim.PRIORITY.Weapon,
			 [anim.BONE_GROUP.LeftArm] = anim.PRIORITY.Weapon,
			 [anim.BONE_GROUP.Torso] = anim.PRIORITY.Weapon,
			 [anim.BONE_GROUP.LowerBody] = anim.PRIORITY.WeaponLowerBody
			 }})
	end
end)


I.AnimationController.addTextKeyHandler('raycastloop', function(groupname, key)
	if key == 'start' then
		print('start')
	end

	if key == 'stop' then
		I.AnimationController.playBlendedAnimation('raycastloop', { startkey = 'start', stopkey = 'stop' ,
		priority = {
			 [anim.BONE_GROUP.RightArm] = anim.PRIORITY.Weapon,
			 [anim.BONE_GROUP.LeftArm] = anim.PRIORITY.Weapon,
			 [anim.BONE_GROUP.Torso] = anim.PRIORITY.Weapon,
			 [anim.BONE_GROUP.LowerBody] = anim.PRIORITY.WeaponLowerBody
			 }})
	end
end)



