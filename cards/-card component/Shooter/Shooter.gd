class_name Shooter
extends Node

@export var projectile_count: int

@export var max_angle: float
func _ready() -> void:
	var parent :=get_parent()
	if parent is Card:
		parent.throw_signal.connect(_on_throw_signal)

func _on_throw_signal(position:Vector3, rotation:Vector3, projectile: BaseProjectile) -> void:
	@warning_ignore("integer_division")
	var count := projectile_count / 2
	var angle := max_angle / float(count)
	var damage := projectile.damage
	projectile.starting_pos = position
	get_tree().root.get_child(0).add_child(projectile)
	projectile.global_position = position
	projectile.global_rotation = rotation
	if projectile_count <= 1:
		return
