class_name Fleeting

extends Ability

func execute(_position: Vector3, caster: Unit) -> void:
	print("Fleeting card was discarded!")
	if caster is Player:
		caster.container.remove_child(self.get_parent())
		self.get_parent().queue_free()
