class_name CardUI

extends Node

@export var title: Label 
@export var cost: Label 
@export var desc: RichTextLabel 
@export var image: NinePatchRect
@export var arr: Array[CanvasItem]
var card_type: Card.type :
	set = setter

func setter(type: Card.type) -> void:
	for el in arr:
		match(type):
			Card.type.monsterous:
				el.self_modulate = Color("#00d97d")
			Card.type.ezotheric:
				el.self_modulate = Color("#ff727c")
			Card.type.eldrich:
				el.self_modulate = Color("#81b6ff")
			Card.type.mysterious:
				el.self_modulate = Color("#b6a9ff")
	card_type = type
