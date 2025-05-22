class_name Spawner

extends Projectile
@export var next: PackedScene
@export var settings: Dictionary
@export var spread: float
func _on_collision(collider: Node3D) -> void:
	var projectile : Projectile = next.instantiate()
	projectile.setup(settings)
	get_tree().root.get_child(1).add_child(projectile)
	projectile.global_position = self.global_position
	projectile.global_rotation = self.global_rotation
	projectile.global_rotation.y += 180.0 + spread*(randf() - 0.5)
	super._on_collision(collider)
