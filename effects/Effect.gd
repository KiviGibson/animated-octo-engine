class_name Effect

extends Node

var parent: Unit = null
var stacking: bool = false
var id: String = "NO Effect"
var count: int
var icon: CompressedTexture2D

func on_connect():
	pass
	
func on_exit():
	pass
	
func add_stacks(num: int):
	count+= num
	if count <= 0:
		self.free()
	
func update(_effect: Effect):
	pass
