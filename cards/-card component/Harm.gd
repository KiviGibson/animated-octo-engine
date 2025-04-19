class_name Harm
extends Node

var amount: int

func _self_damage(caster: Unit) -> void:
	print("Card was discarded!")
	if caster.health is SuchoKlates:
		caster.health.card_interaction(-amount)
	else:
		caster.health.change_health(-amount)
