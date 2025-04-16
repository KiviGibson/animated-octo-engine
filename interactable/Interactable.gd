class_name Interactable

extends Area3D

signal on_interaction

func close(collider:Node3D):
	if collider is Player:
		collider.interaction.connect(_interact)

func distant(collider:Node3D):
	if collider is Player:
		collider.interaction.disconnect(_interact)

func _interact() -> void:
	on_interaction.emit()
