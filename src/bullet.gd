class_name Bullet
extends Area2D

@export var direction: Vector2

var speed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move the bullet based on given direction and set speed
	position += direction * speed
	pass
