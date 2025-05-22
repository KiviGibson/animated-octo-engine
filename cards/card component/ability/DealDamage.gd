class_name DealDamage

extends Ability
@export var area: AreaAbility
@export var amount: int

func execute(_position: Vector3, _caster: Unit) -> void:
	for target in area.areaOfEffect.get_overlapping_bodies():
		if target is Unit:
			target.health.change_health(-amount)
