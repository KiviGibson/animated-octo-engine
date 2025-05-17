class_name MinimumTargets

extends Condition

@export var minimum: int = 1

func condition_met(caster: Unit) -> bool:
	if caster is Player:
		return len(caster.targeting.filter(func(elem): return elem != null)) >= minimum
	return false
