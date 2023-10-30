class_name Player
extends Actor

class ModifierStruct:
	var stat_modifiers = {CoinStatModification.MODIFY_STAT.DAMAGE : 0,
			CoinStatModification.MODIFY_STAT.SPEED : 0,
			CoinStatModification.MODIFY_STAT.KNOCKBACK : 0,
			CoinStatModification.MODIFY_STAT.DURATION : 0,
			CoinStatModification.MODIFY_STAT.COOLDOWN : 0,
			CoinStatModification.MODIFY_STAT.RELOAD_RATE : 0,
			CoinStatModification.MODIFY_STAT.CONSERVE_CHANCE : 0}
	
	func clear_modifiers():
		for mod in stat_modifiers:
			stat_modifiers[mod] = 0

### CONSTANTS

# Reference to penny bullet instance that player can instantiate
const PENNY_BULLET = preload("res://src/penny_bullet.tscn")

# Reference to penny bullet instance that player can instantiate
const PENNY_SHOTGUN = preload("res://src/penny_shotgun.tscn")

# Reference to dime bullet instance that player can instantiate
const DIME_BULLET = preload("res://src/dime_bullet.tscn")

# Reference to dime laser instance that player can instantiate
const DIME_LASER = preload("res://src/dime_laser.tscn")

# Reference to dime bullet instance that player can instantiate
const QUARTER_GRENADE = preload("res://src/quarter_grenade.tscn")

# Reference to quarter disk instance that player can instantiate
const QUARTER_DISK = preload("res://src/quarter_disk.tscn")


### LOCAL VARS

# Current number of each coin
var pennies := 300
var nickels := 0
var dimes := 300
var quarters := 300

var dollar_fragments = 0
var dollars = 0

var modifications: Array[Modification]

var attack_stat_modifications = {CoinModification.COIN_TYPE.PENNY: ModifierStruct.new(),
		CoinModification.COIN_TYPE.DIME: ModifierStruct.new(),
		CoinModification.COIN_TYPE.QUARTER: ModifierStruct.new()}


### ONREADY VARS

# Reference to the HUD
@onready var hud = $UI/HUD as HUD
@onready var equip_menu = $UI/EquipMenu as EquipMenu

# Currently equipped 
@onready var penny_equip = PENNY_BULLET
@onready var dime_equip = DIME_LASER
@onready var quarter_equip = QUARTER_GRENADE


func _ready():
	hud.show()
	hud.player = self
	hud.update_coins()
	
	hurtbox.actor = self
	equip_menu.player = self
	
	modifications.append(ModificationDatabase.get_modification_by_name("Jimmy"))
	
	update_modifications()
	
	super()


func _physics_process(delta):
	# Get the input direction as a normalized vector
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	handle_movement(delta)


func update_modifications():
	for stat_mod in attack_stat_modifications:
		var mod_struct = attack_stat_modifications[stat_mod] as ModifierStruct
		mod_struct.clear_modifiers()
	
	for mod in modifications:
		if mod is CoinStatModification:
			var mod_struct = attack_stat_modifications[mod.coin_type] as ModifierStruct
			mod_struct.stat_modifiers[mod.modify_stat] = mod.amount


func add_dollar_fragment(num: int = 1):
	dollar_fragments += num
	while dollar_fragments >= 3:
		dollar_fragments -= 3
		dollars += 1
	hud.update_dollar_fragments()


func yowch(damage: int, iframe_time = 0.1):
	super(damage, iframe_time)
	$EffectsAnimation.play("hurt")


func create_attack(ATTACK: PackedScene) -> Attack:
	var shoot_vector = get_global_mouse_position() - global_position
	var attack = ATTACK.instantiate() as Attack
	attack.set_direction(shoot_vector.normalized())
	attack.position = self.position
	get_parent().add_child(attack)
	return attack


func _process(delta):
	# Check if the player has input the click action
	if Input.is_action_pressed("penny"):
		# If this coin is a penny, attempt to shoot a penny
		if pennies > 0 and $PennyCooldown.time_left == 0:
			var attack = create_attack(penny_equip)
			var mods = attack_stat_modifications[CoinModification.COIN_TYPE.PENNY] as ModifierStruct
			
			attack.populate_modifiers(mods)
			
			if randf() > mods.stat_modifiers[CoinStatModification.MODIFY_STAT.CONSERVE_CHANCE]:
				pennies -= attack.cost
			
			$PennyCooldown.start(max(0.05, attack.cooldown - mods.stat_modifiers[CoinStatModification.MODIFY_STAT.COOLDOWN]))
		
	if Input.is_action_pressed("dime"):
		if dimes > 0 and $DimeCooldown.time_left == 0:
			var attack = create_attack(dime_equip)
			var mods = attack_stat_modifications[CoinModification.COIN_TYPE.DIME] as ModifierStruct
			attack.populate_modifiers(mods)
			
			if randf() > mods.stat_modifiers[CoinStatModification.MODIFY_STAT.CONSERVE_CHANCE]:
				dimes -= attack.cost
			
			$DimeCooldown.start(max(0.05, attack.cooldown - mods.stat_modifiers[CoinStatModification.MODIFY_STAT.COOLDOWN]))
		
	if Input.is_action_pressed("quarter"):
		if quarters > 0 and $QuarterCooldown.time_left == 0:
			var attack = create_attack(quarter_equip)
			var mods = attack_stat_modifications[CoinModification.COIN_TYPE.QUARTER] as ModifierStruct
			attack.populate_modifiers(mods)
			
			if randf() > mods.stat_modifiers[CoinStatModification.MODIFY_STAT.CONSERVE_CHANCE]:
				quarters -= attack.cost
			
			$QuarterCooldown.start(max(0.05, attack.cooldown - mods.stat_modifiers[CoinStatModification.MODIFY_STAT.COOLDOWN]))
		
	hud.update_coins()
		
	if Input.is_action_just_pressed("equip_menu"):
		equip_menu.visible = !equip_menu.visible
		equip_menu.populate_player_data()

	
	if Input.is_action_just_pressed("interact"):
		%InteractableArea.monitoring = true
		$InteractableArea/InteractTimer.start()


func _on_interactable_area_body_entered(body):
	if body is VendingMachine:
		var vending_menu = preload("res://src/vending_menu.tscn").instantiate()
		get_node("UI/HUD").add_child(vending_menu)
		get_tree().paused = true



func _on_interact_timer_timeout():
	%InteractableArea.monitoring = false
