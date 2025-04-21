class_name DeckBuilder

extends Node

@export var card_ui_wrapper: PackedScene
@export var deck_component_ui: PackedScene
@export var deck_side: CanvasItem
@export var card_side: CanvasItem
@export var max_deck_size: int = 10
@export var deck_counter: Label
var size: int = 0 : set = _size_setter
func _ready() -> void:
	load_deck()
	
func load_deck() -> void:
	# Card Storage Code for all unlocked cards
	var data: Array[Dictionary] = [{
		"card": "res://cards/cards/BlankCard.tscn",
		"count": 10,
		"in_use": 4,
		},
		{
		"card": "res://cards/cards/Wound.tscn",
		"count": 3,
		"in_use": 1,
		},
		{
		"card": "res://cards/cards/Wound.tscn",
		"count": 3,
		"in_use": 1,
		},
		{
		"card": "res://cards/cards/Wound.tscn",
		"count": 3,
		"in_use": 1,
		},
		{
		"card": "res://cards/cards/Wound.tscn",
		"count": 3,
		"in_use": 1,
		},
		{
		"card": "res://cards/cards/Wound.tscn",
		"count": 3,
		"in_use": 1,
		},
		{
		"card": "res://cards/cards/Wound.tscn",
		"count": 3,
		"in_use": 1,
		},
	]
	for datum in data:
		var card: Card = load(datum["card"]).instantiate()
		add(card, datum["count"], datum["in_use"])

func save() -> void:
	# Card Storage code for storing current deck in files
	pass
	
func add(card: Card, count: int, in_use: int)-> void:
	var cardUI: DeckComponent = card_ui_wrapper.instantiate()
	var deckUI: DeckComponent = deck_component_ui.instantiate()
	card_side.add_child(cardUI)
	deck_side.add_child(deckUI)
	deckUI.builder = self
	cardUI.builder = self
	deckUI.card = card
	cardUI.card = card
	deckUI.count = in_use
	cardUI.count = count - in_use
	deckUI.connection = cardUI
	cardUI.connection = deckUI
	deckUI.setupGUI()
	cardUI.setupGUI()
	size += in_use

func _size_setter(value: int):
	deck_counter.text = str(value) + "/" + str(max_deck_size)
	size = value
	
func try_to_update_deck(diff: int) -> bool:
	if diff + size <= max_deck_size:
		size += diff
		return true
	return false
