class_name Remover

extends Ability
@export var ability: Ability

func execute(_position: Vector3, _caster: Unit) -> void:
	ability.clean_up()
