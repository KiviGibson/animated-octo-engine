extends Camera3D

@export var target: Node3D
@export var offset: Vector3
@export var dead_zone: float
@export var cam_speed: float
@export var special_offset: Vector3

# Called when the node enters the scene tree for the first time.1
func _ready() -> void:
	INPUT_DATA.camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if target == null:
		return
	self.global_position.x = move_toward(self.global_position.x, target.global_position.x + offset.x, cam_speed);
	self.global_position.y = move_toward(self.global_position.y, target.global_position.y + offset.y, cam_speed);
	self.global_position.z = move_toward(self.global_position.z, target.global_position.z + offset.z, cam_speed);
