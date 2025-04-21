class_name Card

extends Node

@warning_ignore("unused_signal")
signal discarded(caster: Unit)

enum type{mysterious, eldrich, monsterous, ezotheric}
@export_category("Basic Info")
@export var card_name: String = ""
@export var card_type: type
@export var cost: int
@export var desc: String = ""
@export var damage: int
@export var texture: Texture

@export_category("Ability")
@export var ability: Ability
@export var condition: Condition

var ui: PathFollow2D

func use(position: Vector3, caster: Unit) -> bool:
	if (!condition or condition.condition_met()) and ability:
		ability.execute(position, caster)
		return true
	return false
