class_name PlayerUI

extends Node2D
@export var path: Path2D
var path_element: Array[PathFollow2D]
@export var card_perfab: PackedScene

func setup_card(card: Card, ct: CardUI) -> void:
	ct.title.text = card.card_name
	ct.cost.text = str(card.cost)
	ct.image.texture = card.texture
	ct.cardType = card.card_type
	ct.desc.text = "[center]" + str(card.desc)
	ct.visible = true
	card.ui = ct.get_parent()

func add_card(card: Card) -> void:
	var _card = card_perfab.instantiate()
	var root = PathFollow2D.new()
	path.add_child(root)
	root.add_child(_card)
	setup_card(card, _card)
	path_element.push_back(root)
	highlight_card()
	
func remove_card(card: Card) -> void:
	var element_index = path_element.find(card.ui)
	if element_index != -1:
		var element: PathFollow2D = path_element.pop_at(element_index)
		path.remove_child(element)
		element.queue_free()
		if len(path_element) > 0:
			highlight_card()

func swap_card(side: int) -> void:
	if side == 1:
		path_element.push_back(path_element.pop_front())
	else:
		path_element.push_front(path_element.pop_back())
	highlight_card()

func highlight_card() -> void:
	var c: int = len(path_element)
	for element in path_element:
		element.get_child(0).position.y = -190
		element.z_index = c
		c -= 1
	path_element[0].get_child(0).position.y = -230

func _process(delta: float) -> void:
	var count: float = len(path_element)
	for i in range(count):
		path_element[i].progress_ratio = move_toward(
			path_element[i].progress_ratio,
			(i) / float(max(count,5)),
			4*delta)
