class_name EmbraceDarkness

extends Ability
@export var amount: int = 2

func execute(_position: Vector3, caster: Unit) -> void:
	if caster is Player:
		var targets: Array[Unit] = caster.targeting.filter(func(e): return e != null)
		for target in targets:
			var effect: Effect = Darkness.new(amount)
			target.add_effect(effect)
# ... i ma być zajebisty, to się go pytam kogo ma zajebać - Bauer 29/04/2025
