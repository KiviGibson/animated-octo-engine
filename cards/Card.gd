class_name Card

extends Node

signal throwed()
signal use_signal(position: Vector3, units:Array[Unit])
signal throw_signal(position: Vector3, rotation:Vector3, projectile:Node3D)

enum type{basic ,mysterious, eldrich, monsterous, ezotheric}

@export_category("Basic Info")
@export var card_name: String = ""
@export var card_type: type
@export var cost: int
@export var desc: String = ""
@export var damage: int

@export_category("UI stuff")
@export var texture: Texture
var projectile: PackedScene = load("res://projectiles/Projectile.tscn")
var ui_component: CardUI

@export_category("Conditions")
@export var throw_condition: Condition
@export var use_condition: Condition

@export_category("Ability")

func throw(position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, proj:BaseProjectile = projectile.instantiate()) -> bool:
	if !throw_condition or throw_condition.condition_met():
		proj.damage = damage
		throw_signal.emit(position, rotation, proj)
		if len(throw_signal.get_connections()) > 0:
			throwed.emit()
			return true
	proj.free()
	return false

func use(position:Vector3) -> bool:
	return false
