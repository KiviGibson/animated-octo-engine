class_name Card

extends Node

enum type{mysterious, eldrich, monsterous, ezotheric}
@export_category("Basic Info")
@export var card_name: String = ""
@export var card_type: type
@export var cost: int = 0
@export var desc: String = ""
@export var damage: int = 1
@export var texture: Texture

@export_subgroup("Ability Connector")
@export var draw_ability: Ability
@export var ability: Ability
@export var discard_ability: Ability
@export_subgroup("Ability Condition")
@export var condition: Condition

var ui: PathFollow2D

func use(position: Vector3, caster: Unit) -> bool:
	if (!condition or condition.condition_met(caster)) and ability:
		ability.execute(position, caster)
		return true
	return false

func draw(position: Vector3, caster: Unit) -> void:
	if draw_ability:
		draw_ability.execute(position, caster)
func discard(position: Vector3, caster: Unit) -> void:
	if discard_ability:
		discard_ability.execute(position, caster)
