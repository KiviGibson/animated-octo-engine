class_name PlayerUI

extends Node2D

@export var path_element: Array[PathFollow2D]
@export var card_uis: Array[CardUI]

var free_arr:Array[int] = [0,1,2,3,4]

func setup_ui(card: Card, ct: CardUI) -> void:
	ct.title.text = card.card_name
	ct.cost.text = str(card.cost)
	ct.desc.text = "[center]" + str(card.desc)
	ct.visible = true
	card.ui_component = ct

func set_card(card: Card, pos: int) -> void:
	var a = free_arr.pop_back()
	setup_ui(card, card_uis[a])
	path_element[a].progress_ratio = 0.20 * pos
	path_element[a].z_index = -pos
	
func remove_card(card: Card) -> void:
	var el = card_uis.find(card.ui_component)
	free_arr.append(el)
	card.ui_component.visible = false
	card.ui_component = null
