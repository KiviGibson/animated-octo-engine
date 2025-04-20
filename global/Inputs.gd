extends Node

var player_direction: Vector3
var mouse_pos: Vector3
var camera: Camera3D

func get_mouse_world_position() -> Vector3:
	if !camera: return Vector3.ZERO
	var word_space = camera.get_world_3d().direct_space_state
	var mouse = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse)
	var end = origin + camera.project_ray_normal(mouse) * 1000
	var rayArray := word_space.intersect_ray(PhysicsRayQueryParameters3D.create(origin, end))
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3.ZERO

func _process(_delta: float) -> void:
	mouse_pos = get_mouse_world_position() * Vector3(1,0,1)
	player_direction = Vector3(Input.get_axis("right", "left"), 0, Input.get_axis("up", "down"))
