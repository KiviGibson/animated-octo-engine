class_name Creator

extends Ability
@export var card_perfab: PackedScene

func execute(_position: Vector3, caster:Unit) -> void:
	if caster is Player:
		var card: Card = card_perfab.instantiate()
		caster.container.add_child(card)
		caster.draw_pile.append(card)
		caster.draw()
