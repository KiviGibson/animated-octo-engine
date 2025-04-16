class_name PlayerStats

extends Node

@export var health: ProgressBar
@export var mana: ProgressBar

func set_health(num: int) -> void:
	health.value = num

func set_mana(num: int) ->void:
	mana.value = num
