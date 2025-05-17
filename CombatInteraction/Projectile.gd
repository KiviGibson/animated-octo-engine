class_name Projectile

extends CharacterBody3D

const JUMP_VELOCITY = 4.5
@export var max_distance: float = 7.5
@export var speed: float = 7.5
var starting_pos: Vector3
var damage: int = 1
var caster: Unit

func _physics_process(_delta: float) -> void:
	var direction := -basis.z
	velocity.x = -direction.x * speed
	velocity.z = -direction.z * speed
	var distance_vector: Vector3 = starting_pos - self.global_position
	var distance = sqrt(distance_vector.x**2+distance_vector.y**2+distance_vector.z**2)
	if max_distance <= distance:
		self.queue_free()
	move_and_slide()

func _on_collision(collision: Node3D) -> void:
	print(collision)
	if collision == caster:
		return
	if collision is Unit:
		collision.health.change_health(-damage)
		if caster is Player:
			caster.targeting.clear()
			caster.targeting.append(collision)
	print(collision.name)
	self.queue_free()

func setup(dict: Dictionary) -> void:
	pass
