class_name Player
extends Actor

### EXPORT



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

# Player's current active coin
var active_coin = "P"

# Current number of each coin
var pennies := 300
var nickels := 0
var dimes := 300
var quarters := 300

var dollar_fragments = 0

### ONREADY VARS

# Reference to the HUD
@onready var hud = $UI/HUD as HUD

# Currently equipped 
@onready var penny_equip = PENNY_BULLET
@onready var dime_equip = DIME_BULLET
@onready var quarter_equip = QUARTER_GRENADE


func _ready():
	hud.show()
	hud.player = self
	hud.update_coins()


func _physics_process(delta):
	# Get the input direction as a normalized vector
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	handle_movement(delta)


func add_dollar_fragment(num: int = 1):
	dollar_fragments += num
	hud.update_dollar_fragments()


func yowch(damage: int):
	super(damage)
	$EffectsAnimation.play("hurt")


func _process(delta):
	# Check if the player has input the click action
	if Input.is_action_pressed("penny"):
		# If this coin is a penny, attempt to shoot a penny
		if pennies > 0 and $PennyCooldown.time_left == 0:
			var shoot_vector = get_global_mouse_position() - global_position
			var to_shoot = penny_equip.instantiate() as PennyBullet
			to_shoot.set_direction(shoot_vector.normalized())
			to_shoot.position = self.position
			get_parent().add_child(to_shoot)
			
			pennies -= to_shoot.attack_data.cost
			$PennyCooldown.start(to_shoot.attack_data.cooldown)
		
	if Input.is_action_pressed("dime"):
		if dimes > 0 and $DimeCooldown.time_left == 0:
			var shoot_vector = get_global_mouse_position() - global_position
			var to_shoot = dime_equip.instantiate()
			to_shoot.direction = shoot_vector.normalized()
			to_shoot.position = self.position
			get_parent().add_child(to_shoot)
			
			dimes -= to_shoot.attack_data.cost
			$DimeCooldown.start(to_shoot.attack_data.cooldown)
		
	if Input.is_action_pressed("quarter"):
		if quarters > 0 and $QuarterCooldown.time_left == 0:
			var to_shoot = quarter_equip.instantiate()
			to_shoot.position = self.position
			get_parent().add_child(to_shoot)
			
			quarters -= to_shoot.attack_data.cost
			$QuarterCooldown.start(to_shoot.attack_data.cooldown)
		
	hud.update_coins()
		
	if Input.is_action_pressed("equip_menu"):
		var equip_menu = preload("res://src/equip_menu.tscn").instantiate()
		get_node("UI/HUD").add_child(equip_menu)
		pass # load the equip menu "scene" as a child of camera? or player? 
