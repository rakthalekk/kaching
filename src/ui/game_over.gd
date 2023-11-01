extends Control

var win

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/GameOver.text += "Win!" if win else "Lose"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	queue_free()
	get_tree().change_scene_to_file("res://src/streets.tscn")
	get_tree().paused = false


func _on_quit_button_pressed():
	get_tree().quit()
