class_name Harm
extends Ability

@export var amount: int

func execute(_position: Vector3, caster: Unit) -> void:
	print("Harm card was discarded!")
	if caster.health is SuchoKlates:
		caster.health.card_interaction(-amount)
	else:
		caster.health.change_health(-amount)
