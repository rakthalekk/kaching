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
var nickels := 300
var dimes := 300
var quarters := 300

var dollar_fragments = 0
var dollars = 1

var modifications: Array[Modification]

var attack_modifications = {Modification.COIN_TYPE.PENNY: [], Modification.COIN_TYPE.NICKEL: [], Modification.COIN_TYPE.DIME: [], Modification.COIN_TYPE.QUARTER: []}

var attack_stat_modifications = {Modification.COIN_TYPE.PENNY: ModifierStruct.new(),
		Modification.COIN_TYPE.DIME: ModifierStruct.new(),
		Modification.COIN_TYPE.QUARTER: ModifierStruct.new()}

var anim_suffix = ""

var look_direction: Vector2

### Constants

const VENDING_MENU = preload("res://src/ui/vending_menu.tscn")

const PISTOL = preload("res://assets/pistol.png")

const RIFLE = preload("res://assets/rifle.png")

const LAUNCHER = preload("res://assets/launcher.png")

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
	hud.penny_timer = $PennyCooldown
	hud.dime_timer = $DimeCooldown
	hud.quarter_timer = $QuarterCooldown
	hud.update_coins()
	hud.update_dollar_fragments()
	
	hurtbox.actor = self
	equip_menu.player = self
	
	for mod in starting_modifications:
		modifications.append(ModificationDatabase.get_modification_by_name(mod))
	
	update_modifications()
	
	super()


func _physics_process(delta):
	# Get the input direction as a normalized vector
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	look_direction = (get_global_mouse_position() - global_position).normalized()
	
	if look_direction.x > 0:
		$Sprite2D.flip_h = true
		$GunSprite.flip_h = true
	elif look_direction.x < 0:
		$Sprite2D.flip_h = false
		$GunSprite.flip_h = false
	
	if look_direction.y > 0:
		anim_suffix = ""
	elif look_direction.y < 0:
		anim_suffix = "_back"
	
	if direction.length() != 0:
		$AnimationPlayer.play("run" + anim_suffix)
	else:
		$AnimationPlayer.play("idle" + anim_suffix)
	
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
			mod_struct.stat_modifiers[mod.modify_stat] = mod.amount
		elif mod is AttackModification:
			attack_modifications[mod.coin_type].append(mod.attack_name)
	
	penny_equip = attack_modifications[Modification.COIN_TYPE.PENNY][0]
	dime_equip = attack_modifications[Modification.COIN_TYPE.DIME][0]
	quarter_equip = attack_modifications[Modification.COIN_TYPE.QUARTER][0]


func add_modification(mod: Modification):
	modifications.append(mod)
	update_modifications()


func return_coins(change: int):
	var returned_coins = [0, 0, 0, 0]
	
	# First chdck for how many quarters to give out
	while change >= 70:
		# Add quarter to player
		quarters += 1
		returned_coins[0] += 1
		change -= 25
	while change >= 35:
		dimes += 1
		returned_coins[1] += 1
		change -= 10
	if change >= 25:
		nickels += 1
		returned_coins[2] += 1
		change -= 5
	while change > 0:
		pennies += 1
		returned_coins[3] += 1
		change -= 1
	
	hud.update_coins()
	hud.update_dollar_fragments()
	return returned_coins


func add_dollar_fragment(num: int = 1):
	dollar_fragments += num
	while dollar_fragments >= 3:
		dollar_fragments -= 3
		dollars += 1
	hud.update_dollar_fragments()


func yowch(damage: int, iframe_time = 0.1):
	super(damage, iframe_time)
	$EffectsAnimation.play("hurt")
	#$AudioStreamPlayer2D.volume_db = 1.0
	$AudioStreamPlayer2D.stream = load("res://assets/Audio/Player Damage/lich-damage-%d.mp3" % randi_range(1, 4))
	$AudioStreamPlayer2D.play()
	hud.lose_heart()


func heal(amount: int = 1):
	health = max(max_health, health + amount)
	hud.gain_heart()


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
			
			$AudioStreamPlayer2D.stream = load("res://assets/Audio/Penny Hitscan/penny-hs-%d.ogg" % randi_range(1, 3))
			$AudioStreamPlayer2D.play()
			$PennyCooldown.start(max(0.05, attack.cooldown - mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.COOLDOWN]))
			
			$GunSprite.texture = PISTOL
		
	if Input.is_action_pressed("dime"):
		if dimes > 0 and $DimeCooldown.time_left == 0:
			var attack = create_attack(dime_equip)
			var mods = attack_stat_modifications[Modification.COIN_TYPE.DIME] as ModifierStruct
			attack.populate_modifiers(mods)
			
			if randf() > mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.CONSERVE_CHANCE]:
				dimes -= attack.cost
			
			$DimeCooldown.start(max(0.05, attack.cooldown - mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.COOLDOWN]))
			
			$GunSprite.texture = RIFLE
		
	if Input.is_action_pressed("quarter"):
		if quarters > 0 and $QuarterCooldown.time_left == 0:
			var attack = create_attack(quarter_equip)
			var mods = attack_stat_modifications[Modification.COIN_TYPE.QUARTER] as ModifierStruct
			attack.populate_modifiers(mods)
			
			if randf() > mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.CONSERVE_CHANCE]:
				quarters -= attack.cost
			
			$QuarterCooldown.start(max(0.05, attack.cooldown - mods.stat_modifiers[Modification.MODIFY_ATTACK_STAT.COOLDOWN]))
			
			$GunSprite.texture = LAUNCHER
		
	hud.update_coins()
	hud.update_cooldown_bars()
	
	
	if Input.is_action_just_pressed("interact"):
		%InteractableArea.monitoring = true
		$InteractableArea/InteractTimer.start()


func _on_interactable_area_body_entered(body):
	if body is VendingMachine:
		var vending_menu = VENDING_MENU.instantiate()
		vending_menu.populate_mods(body)
		get_node("UI/HUD").add_child(vending_menu)
		get_tree().paused = true



func _on_interact_timer_timeout():
	%InteractableArea.monitoring = false
