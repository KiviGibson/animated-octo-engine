class_name DeckBuilder

extends Node

@export var card_ui_wrapper: PackedScene
@export var deck_component_ui: PackedScene
@export var deck_side: CanvasItem
@export var card_side: CanvasItem

@export var min_deck_size: int = 5
@export var max_deck_size: int = 10

@export var deck_counter: Label

var size: int = 0 : set = _size_setter
func _ready() -> void:
	load_deck()

func load_deck() -> void:
	for child in deck_side.get_children():
		deck_side.remove_child(child)
		child.queue_free()
	for child in card_side.get_children():
		card_side.remove_child(child)
		child.queue_free()
	size = 0
	var data: Array[Dictionary] = SAVE_SYSTEM.get_deck(1)
	for datum in data:
		add(datum["path"], datum["available"], datum["in_deck"])

func save() -> void:
	if size > max_deck_size or size < min_deck_size:
		return
	var res: Array[CardData]
	for child in deck_side.get_children():
		if child is DeckComponent and child.count > 0:
			var element: CardData = CardData.new(child.path, child.count)
			res.append(element)
	SAVE_SYSTEM.save_deck(res)
	GLOBAL.player.prep_deck(res, [], [])
	print(res)

func add(path: String, count: int, in_use: int)-> void:
	var cardUI: DeckComponent = card_ui_wrapper.instantiate()
	var deckUI: DeckComponent = deck_component_ui.instantiate()
	card_side.add_child(cardUI)
	deck_side.add_child(deckUI)
	deckUI.builder = self
	cardUI.builder = self
	deckUI.scene = load(path)
	deckUI.path = path
	cardUI.scene = deckUI.scene
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
	if size > max_deck_size or size < min_deck_size:
		deck_counter.self_modulate = Color.DARK_RED
	else:
		deck_counter.self_modulate = Color.WHITE
	
func try_to_update_deck(diff: int) -> bool:
	size += diff
	return true
