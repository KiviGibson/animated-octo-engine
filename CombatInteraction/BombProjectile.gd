class_name BombProjectile

extends Projectile
signal explode(position: Vector3, caster: Unit)
@export var bounce_count: int = 2
var floor: bool = false
func _physics_process(delta: float) -> void:
	var grav := get_gravity().y
	if not is_on_floor():
		velocity.y -= grav
		if floor == true:
			bounce_count -= 1
			if bounce_count == 0:
				last_bounce()
	else:
		velocity.y = -0.7 * velocity.y
		floor = true
	var direction := -basis.z
	velocity.x = -direction.x * speed
	velocity.z = -direction.z * speed
	var distance_vector: Vector3 = starting_pos - self.global_position
	var distance = sqrt(distance_vector.x**2+distance_vector.y**2+distance_vector.z**2)
	move_and_slide()

func last_bounce() -> void:
	explode.emit(self.global_position, null)
