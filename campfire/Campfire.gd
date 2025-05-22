class_name Campfire

extends Interactable
@export var card_menu: PackedScene
var instance: DeckBuilder = null;
func _on_interaction() -> void:
	if instance:
		return
	var node: Node = card_menu.instantiate()
	get_tree().root.add_child(node)
	instance = node
	GLOBAL.player.remove_deck()
	GLOBAL.current_type = GLOBAL.InputType.ui

func _close_if_not_close(node: Node3D) -> void:
	if node is Player and instance:
		close_menu(node)
		
func _process(delta: float) -> void:
	if GLOBAL.current_type != Global.InputType.ui:
		return
	if Input.is_action_just_pressed("escape"):
		close_menu(GLOBAL.player)

func close_menu(node: Player) -> void:
	instance.get_parent().remove_child(instance)
	instance.queue_free()
	instance = null
	node.draw(5)
	GLOBAL.current_type = GLOBAL.InputType.player
