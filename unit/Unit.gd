class_name Unit
extends CharacterBody3D

@export var effect_node: Node3D
@export var speed: int = 5
@export var health: Health
@export var attack_perfab: PackedScene
var clones: Array[Unit]

@export_category("Stats")
@export var vit: int = 10
@export var str: int = 10
@export var dex: int = 10
@export var fai: int = 10

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
	
func atack(projectile: BaseProjectile = attack_perfab.instantiate()):
	get_tree().root.get_child(0).add_child(projectile)
	projectile.global_position = self.global_position
	projectile.rotation = self.rotation
	projectile.damage = 3
