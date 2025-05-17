class_name BaseProjectile

extends CharacterBody3D

const JUMP_VELOCITY = 4.5
@export var max_distance: float = 7.5
@export var speed: float = 7.5
var starting_pos: Vector3
var damage: int = 1

func _physics_process(_delta: float) -> void:
	var direction := -basis.z
	velocity.x = -direction.x * speed
	velocity.z = -direction.z * speed
	var distance_vector: Vector3 = starting_pos - self.global_position
	var distance = sqrt(distance_vector.x**2+distance_vector.y**2+distance_vector.z**2)
	if max_distance <= distance:
		self.queue_free()
	move_and_slide()
