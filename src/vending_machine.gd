class_name VendingMachine
extends StaticBody2D

# List of names for each modification this machine stores
@export var modifications : Array[String]

# Map of each mod name to boolean of whether they can be purchased
var mod_availability = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for mod in modifications:
		mod_availability[mod] = true
