extends Node2D


func _ready():
	hide()


func get_modification_by_name(nam: String):
	return get_node(nam)
