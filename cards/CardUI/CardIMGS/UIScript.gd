class_name CardUI

extends Node

@export var title: Label 
@export var cost: Label 
@export var desc: RichTextLabel 
@export var image: Sprite2D 

func _ready() -> void:
	title = %CardName
	cost = %ManaCost
	desc = %RichTextLabel
	image = %Image
