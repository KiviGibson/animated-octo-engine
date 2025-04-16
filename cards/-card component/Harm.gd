class_name Harm
extends Node

var amount: int
var player: Player

func _self_damage() -> void:
	if player.health is SuchoKlates:
		player.health.card_interaction(-amount)
	else:
		player.health.change_health(-amount)
