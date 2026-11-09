local content = require('openmw.content')


--====================================
--add projectile objects
--====================================

content.activators.records.EmptyModelProjectile = {
														model = nil,
														mwscript = nil,
														name = "Empty Model Projectile"
														}



--====================================
-- Add The New Effects
--====================================


-- Destruction
content.magicEffects.records.FireRayDamage = { template = content.magicEffects.records['firedamage'], 
																									name = 'Fire Ray Damage', 
																									onSelf = false, 
																									onTouch = false,
																									icon ="Icons/Cse/fire-ray.dds"

																									}

content.magicEffects.records.ShockRayDamage = { template = content.magicEffects.records['shockdamage'], 
																									name = 'Shock Ray Damage', 
																									onSelf = false, 
																									bolt = 'VFX_DefaultBolt',
																									icon ="Icons/Cse/shock-ray.dds"
																									
																									}

content.magicEffects.records.FrostRayDamage = { template = content.magicEffects.records['frostdamage'], 
																									name = 'Frost Ray Damage', 
																									onSelf = false, 
																									onTouch = false,
																									bolt = 'VFX_DefaultBolt',
																									icon ="Icons/Cse/frost-ray.dds"

																									}

content.magicEffects.records.PoisonRayDamage = { template = content.magicEffects.records['poison'], 
																									name = 'Poison Ray Damage', 
																									onSelf = false, 
																									onTouch = false, 
																									castStatic = 'vfx_defaultcast',
																									icon ="Icons/Cse/poison-ray.dds"
																									
																									}
																									
content.magicEffects.records.DamageHealthRay = { template = content.magicEffects.records['damagehealth'], 
																									name = 'Damage Health Ray', 
																									onSelf = false, 
																									onTouch = false, 
																									icon ="Icons/Cse/damage-health-ray.dds"																									
																									}



																									
content.magicEffects.records.AbsorbHealthRay = { template = content.magicEffects.records['absorbhealth'], 
																									name = 'Absorb Health Ray', 
																									onSelf = false, 
																									onTouch = false, 
																									icon ="Icons/Cse/absorb-health-ray.dds"																									
																									}




--====================================
-- Add New Spell With Those Effects 
--====================================
content.spells.records.BurningRay = { name = 'Burning Ray', 
									type = content.spells.TYPE.Spell, 
									cost = 5, 
									starterSpellFlag = false, 
									isAutocalc = true, 
									effects = { { id = 'FireRayDamage', 
													duration = 1, 
													magnitudeMin = 2,
													magnitudeMax = 20,
													area = 5,
													range = 2
													} } }



content.spells.records.FreezingRay = { name = 'Freezing Ray', 
									type = content.spells.TYPE.Spell, 
									cost = 5, 
									starterSpellFlag = false, 
									isAutocalc = true, 
									effects = { { id = 'FrostRayDamage', 
													duration = 1, 
													magnitudeMin = 2,
													magnitudeMax = 20,
													area = 5,
													range = 2
													} } }


content.spells.records.ShockingRay = { name = 'Shocking Ray', 
									type = content.spells.TYPE.Spell, 
									cost = 7, 
									starterSpellFlag = false, 
									isAutocalc = true, 
									effects = { { id = 'ShockRayDamage', 
													duration = 1, 
													magnitudeMin = 2,
													magnitudeMax = 20,
													area = 5,
													range = 2
													} } }


content.spells.records.PoisonRay = { name = 'Poison Ray', 
									type = content.spells.TYPE.Spell, 
									cost = 9, 
									starterSpellFlag = false, 
									isAutocalc = true, 
									effects = { { id = 'PoisonRayDamage', 
													duration = 1, 
													magnitudeMin = 2,
													magnitudeMax = 20,
													area = 5,
													range = 2
													} } }






content.spells.records.HarmingRay = { name = 'Harming Ray', 
										type = content.spells.TYPE.Spell, 
										cost = 8, 
										starterSpellFlag = false, 
										isAutocalc = true, 
										effects = { { id = 'DamageHealthRay', 
														duration = 1, 
														magnitudeMin = 2,
														magnitudeMax = 20,
														area = 5,
														range = 2
														} } }






content.spells.records.VampiricRay = { name = 'Vampiric Ray', 
										type = content.spells.TYPE.Spell, 
										cost = 8, 
										starterSpellFlag = false, 
										isAutocalc = true, 
										effects = { { id = 'AbsorbHealthRay', 
														duration = 1, 
														magnitudeMin = 2,
														magnitudeMax = 20,
														area = 5,
														range = 2
														} } }















--====================================
-- DebugSpells
--====================================


content.spells.records.DebugSpellAbsorb = { name = 'Debug Spell Absorb', 
									type = content.spells.TYPE.Spell, 
									cost = 1, 
									starterSpellFlag = false,
									alwaysSucceedFlag = true,
									isAutocalc = false, 
									effects = { { id = 'spellabsorption', 
													duration = 1000, 
													magnitudeMin = 50,
													magnitudeMax = 50,
													area = 5,
													range = 2
													},
												{ id = 'spellabsorption', 
													duration = 1000, 
													magnitudeMin = 50,
													magnitudeMax = 50,
													area = 5,
													range = 2
													} } }
													
													
													
content.spells.records.DebugSpellAbsorb2 = { name = 'Debug Spell Absorb2', 
									type = content.spells.TYPE.Spell, 
									cost = 1, 
									starterSpellFlag = false,
									alwaysSucceedFlag = true,
									isAutocalc = false, 
									effects = { { id = 'spellabsorption', 
													duration = 1000, 
													magnitudeMin = 100,
													magnitudeMax = 100,
													area = 5,
													range = 2
													} }}
													
													
													
													
													
content.spells.records.DebugSpellRelfect = { name = 'DebugSpellRelfect', 
									type = content.spells.TYPE.Spell, 
									cost = 1, 
									starterSpellFlag = false,
									alwaysSucceedFlag = true,
									isAutocalc = false, 
									effects = { { id = 'reflect', 
													duration = 1000, 
													magnitudeMin = 50,
													magnitudeMax = 50,
													area = 5,
													range = 2
													},
												{ id = 'reflect', 
													duration = 1000, 
													magnitudeMin = 50,
													magnitudeMax = 50,
													area = 5,
													range = 2
													} } }
													
													
													
													
													
content.spells.records.DebugSpellRelfect2 = { name = 'DebugSpellRelfect2', 
									type = content.spells.TYPE.Spell, 
									cost = 1, 
									starterSpellFlag = false,
									alwaysSucceedFlag = true,
									isAutocalc = false, 
									effects = { { id = 'reflect', 
													duration = 1000, 
													magnitudeMin = 100,
													magnitudeMax = 100,
													area = 5,
													range = 2
													} }}