class_name CardAppender

extends Node
@export var root: bool = false
@export var number: int = 0
@export var path: String = ""


func _ready() -> void:
	if root:
		store_data()

func update_cards() -> Array[CARD_STORAGE.CardData]:
	var list: Array[CARD_STORAGE.CardData] = []
	for child in self.get_children():
		if child is Card:
			var datum := CARD_STORAGE.CardData.new(
				[child.texture.get_path(), 
				child.scene_file_path, 
				child.card_name, 
				number
			])
			list.append(datum)
	return list

func store_data() -> void:
	var list: Array[CARD_STORAGE.CardData] = []
	for child in  get_children():
		if child is CardAppender:
			list.append_array(child.update_cards())
	CARD_STORAGE.save_data(list, path)
