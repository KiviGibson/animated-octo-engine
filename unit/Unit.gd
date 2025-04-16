class_name Unit
extends CharacterBody3D

@export var effect_node: Node3D
@export var speed: int = 5
@export var health: Health
var clones: Array[Unit]

func add_effect(effect: Effect):
	var current_state: Effect = get_effect(effect.id)
	if current_state:
		if effect.stacking:
			current_state.add_stacks(effect.count)
		else:
			current_state.update(effect)
	else:
		effect_node.add_child(effect)
		effect.on_connect()

func get_effect(id: String) -> Effect:
	for effect in effect_node.get_children():
		if effect.id == id:
			return effect
	return null
	
func throw(position: Vector3 = self.global_position, rotation: Vector3 = self.rotation, projectile: Node3D = null):
	pass
