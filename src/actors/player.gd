class_name Player
extends Actor

### EXPORT VARS
@export var starting_modifications : Array[String]


class ModifierStruct:
	var stat_modifiers = {}
	
	func _init():
		clear_modifiers()
	
	func clear_modifiers():
		for stat in Modification.MODIFY_ATTACK_STAT.values():
			stat_modifiers[stat] = 0


### LOCAL VARS

# Current number of each coin
var pennies := 300
var nickels := 0
var dimes := 300
var quarters := 300

var dollar_fragments = 0
var dollars = 0

var modifications: Array[Modification]

var attack_modifications = {Modification.COIN_TYPE.PENNY: [], Modification.COIN_TYPE.DIME: [], Modification.COIN_TYPE.QUARTER: []}

var attack_stat_modifications = {Modification.COIN_TYPE.PENNY: ModifierStruct.new(),
		Modification.COIN_TYPE.DIME: ModifierStruct.new(),
		Modification.COIN_TYPE.QUARTER: ModifierStruct.new()}


### Constants

const VENDING_MENU = preload("res://src/ui/vending_menu.tscn")

### ONREADY VARS

# Reference to the HUD
@onready var hud = $UI/HUD as HUD
@onready var equip_menu = $UI/EquipMenu as EquipMenu

# Currently equipped 
var penny_equip: String
var dime_equip: String
var quarter_equip: String


func _ready():
	hud.show()
	hud.player = self
	hud.update_coins()
	
	hurtbox.actor = self
	equip_menu.player = self
	
	for mod in starting_modifications:
		modifications.append(ModificationDatabase.get_modification_by_name(mod))
	
	update_modifications()
	
	super()


func _physics_process(delta):
	# Get the input direction as a normalized vector
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	handle_movement(delta)


func update_modifications():
	for coin_type in attack_stat_modifications:
		var mod_struct = attack_stat_modifications[coin_type] as ModifierStruct
		mod_struct.clear_modifiers()
	
	for coin_type in attack_modifications:
		attack_modifications[coin_type].clear()
	
	for mod in modifications:
		if mod is CoinStatModification:
			var mod_struct = attack_stat_modifications[mod.coin_type] as ModifierStruct
			mod_struct.stat_modifiers[mod.MODIFY_ATTACK_STAT] = mod.amount
		elif mod is AttackModification:
			attack_modifications[mod.coin_type].append(mod.attack_name)
	
	penny_equip = attack_modifications[Modification.COIN_TYPE.PENNY][0]
	dime_equip = attack_modifications[Modification.COIN_TYPE.DIME][0]
	quarter_equip = attack_modifications[Modification.COIN_TYPE.QUARTER][0]


func add_dollar_fragment(num: int = 1):
	dollar_fragments += num
	while dollar_fragments >= 3:
		dollar_fragments -= 3
		dollars += 1
	hud.update_dollar_fragments()


func yowch(damage: int, iframe_time = 0.1):
	super(damage, iframe_time)
	$EffectsAnimation.play("hurt")


func create_attack(attack_name: String) -> Attack:
	var shoot_vector = get_global_mouse_position() - global_position
	var path = "res://src/attacks/" + attack_name + ".tscn"
	var attack = load(path).instantiate() as Attack
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
			var mods = attack_stat_modifications[Modification.COIN_TYPE.PENNY] as ModifierStruct
			
			attack.populate_modifiers(mods)
			
			if randf() > mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.CONSERVE_CHANCE]:
				pennies -= attack.cost
			
			$PennyCooldown.start(max(0.05, attack.cooldown - mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.COOLDOWN]))
		
	if Input.is_action_pressed("dime"):
		if dimes > 0 and $DimeCooldown.time_left == 0:
			var attack = create_attack(dime_equip)
			var mods = attack_stat_modifications[Modification.COIN_TYPE.DIME] as ModifierStruct
			attack.populate_modifiers(mods)
			
			if randf() > mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.CONSERVE_CHANCE]:
				dimes -= attack.cost
			
			$DimeCooldown.start(max(0.05, attack.cooldown - mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.COOLDOWN]))
		
	if Input.is_action_pressed("quarter"):
		if quarters > 0 and $QuarterCooldown.time_left == 0:
			var attack = create_attack(quarter_equip)
			var mods = attack_stat_modifications[Modification.COIN_TYPE.QUARTER] as ModifierStruct
			attack.populate_modifiers(mods)
			
			if randf() > mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.CONSERVE_CHANCE]:
				quarters -= attack.cost
			
			$QuarterCooldown.start(max(0.05, attack.cooldown - mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.COOLDOWN]))
		
	hud.update_coins()
		
	if Input.is_action_just_pressed("equip_menu"):
		equip_menu.visible = !equip_menu.visible
		equip_menu.populate_player_data()

	
	if Input.is_action_just_pressed("interact"):
		%InteractableArea.monitoring = true
		$InteractableArea/InteractTimer.start()


func _on_interactable_area_body_entered(body):
	if body is VendingMachine:
		var vending_menu = VENDING_MENU.instantiate()
		get_node("UI/HUD").add_child(vending_menu)
		get_tree().paused = true



func _on_interact_timer_timeout():
	%InteractableArea.monitoring = false
