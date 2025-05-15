class_name DeckComponent

extends Node

@export var card_name: Label
@export var card_count: Label
@export var card_scene: CardUI
var count: int : set = counter
@export var arr: Array[CanvasItem]
@export var in_deck: bool
var path: String
var scene: PackedScene
var card_type: Card.type : set = setter
var connection: DeckComponent
var builder: DeckBuilder
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

func counter(value: int) -> void:
	card_count.text = str(value)
	count = value
	if count == 0:
		self.visible = false
	else:
		self.visible = true

func setupGUI() -> void:
	var card: Card = scene.instantiate()
	if card_scene != null:
		card_scene.card_type = card.card_type
		card_scene.image.texture = card.texture
		card_scene.cost.text =  str(card.cost)
		card_scene.desc.text = "[center]" + card.desc
		card_scene.title.text = card.card_name
	else:
		card_name.text = str(card.card_name)
		card_type = card.card_type
	card_count.text = str(count)
	card.queue_free()

func changeQuantity(c: int = -1) -> void:
	if self.count == 0: return
	if in_deck and builder.try_to_update_deck(-1):
		self.count += c
		connection.count -= c
	elif builder.try_to_update_deck(1):
		self.count += c
		connection.count -= c
