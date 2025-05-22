class_name Health
extends Node

signal damaged
signal healed
signal death
@export var max_health: int = 100
var health: int

func _ready() -> void:
	health = max_health
	
func change_health(diff: int) -> void:
	if diff <=0:
		damaged.emit()
		health += diff
		if health <= 0:
			death.emit()
	else:
		healed.emit()
		health+= diff
