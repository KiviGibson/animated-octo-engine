class_name CardStorage

extends Node

class CardData:
	var card_image: String
	var card_scene: String
	var card_name: String
	var number: int

	func _init(data: Array) -> void:
		card_image = data[0]
		card_scene = data[1]
		card_name = data[2]
		number = int(data[3])

	func _to_string() -> String:
		return card_name

func retrive_data(path:String) -> Array[CardData]:
	var res: Array[CardData] = []
	var file: FileAccess = FileAccess.open(path,FileAccess.READ)
	if file == null:
		printerr("FileNotFound!")
		return []
	var line: Array = Array(file.get_csv_line())
	while line != [""]:
		res.append(CardData.new(line))
		line = file.get_csv_line()
	file.close()
	return res
	
func save_data(deck: Array[CardData], path: String) -> bool:
	var file: FileAccess = FileAccess.open(path,FileAccess.WRITE)
	for card in deck:
		var arr: PackedStringArray = PackedStringArray([card.card_image, card.card_scene, card.card_name, card.number])
		file.store_csv_line(arr)
	file.close()
	return true
