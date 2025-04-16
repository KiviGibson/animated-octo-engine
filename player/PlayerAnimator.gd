extends Node3D

@export var player: Player
@export var animation: AnimationPlayer

func _process(_delta: float) -> void:
	match player.animation_state:
		player.states.running:
			animation.play("Running_A")
		player.states.standing:
			animation.play("Idle_B")
