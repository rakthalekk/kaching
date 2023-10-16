class_name Player
extends CharacterBody2D

### EXPORT

# Player speed
@export var speed = 300


### CONSTANTS

# Different types of coins that the player can use: pennies, dimes, and quarters
const COIN_TYPES = ["P", "D", "Q"]

# Reference to penny bullet instance that player can instantiate
const PENNY_BULLET = preload("res://src/penny_bullet.tscn")

# Reference to dime bullet instance that player can instantiate
const DIME_BULLET = preload("res://src/dime_bullet.tscn")

# Reference to dime bullet instance that player can instantiate
const QUARTER_GRENADE = preload("res://src/quarter_grenade.tscn")


### LOCAL VARS

# Current direction of the player
var direction: Vector2

# Player's current active coin
var active_coin = "P"

# Current number of each coin
var pennies := 300
var nickels := 0
var dimes := 300
var quarters := 300


### ONREADY VARS

# Reference to the HUD
@onready var hud = $UI/HUD as HUD


func _ready():
	hud.player = self
	hud.update_coins()


func _physics_process(delta):
	# Get the input direction as a normalized vector
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	# Calculates velocity and applies it to player
	velocity = direction * speed
	move_and_slide()


func add_coin():
	pennies += 1
	hud.update_coins()


func _process(delta):
	# Check if the player has input the click action
	if Input.is_action_pressed("click"):
		# If this coin is a penny, attempt to shoot a penny
		if active_coin == "P":
			if pennies > 0 and $PennyCooldown.time_left == 0:
				pennies -= 1
				$PennyCooldown.start()
				
				var shoot_vector = get_global_mouse_position() - global_position
				var to_shoot = PENNY_BULLET.instantiate() as PennyBullet
				to_shoot.set_direction(shoot_vector.normalized())
				to_shoot.position = self.position
				get_parent().add_child(to_shoot)
		elif active_coin == "D":
			if dimes > 0 and $DimeCooldown.time_left == 0:
				dimes -= 1
				$DimeCooldown.start()
				
				var shoot_vector = get_global_mouse_position() - global_position
				var to_shoot = DIME_BULLET.instantiate()
				to_shoot.direction = shoot_vector.normalized()
				to_shoot.position = self.position
				get_parent().add_child(to_shoot)
		elif active_coin == "Q":
			if quarters > 0 and $QuarterCooldown.time_left == 0:
				quarters -= 1
				$QuarterCooldown.start()
				
				var to_shoot = QUARTER_GRENADE.instantiate()
				to_shoot.position = self.position
				get_parent().add_child(to_shoot)
		
		hud.update_coins()
	
	if Input.is_action_just_pressed("up_coin"):
		active_coin = COIN_TYPES[(COIN_TYPES.find(active_coin) - 1) % COIN_TYPES.size()]
		hud.update_active_coin()
	
	if Input.is_action_just_pressed("down_coin"):
		active_coin = COIN_TYPES[(COIN_TYPES.find(active_coin) + 1) % COIN_TYPES.size()]
		hud.update_active_coin()

