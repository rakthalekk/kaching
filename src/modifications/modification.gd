class_name Modification
extends Sprite2D

enum COIN_TYPE {NONE, PENNY, NICKEL, DIME, QUARTER}
enum MODIFY_ATTACK_STAT {DAMAGE, SPEED, KNOCKBACK, DURATION, COOLDOWN, RELOAD_RATE, CONSERVE_CHANCE}
enum MODIFY_PLAYER_STAT {SPEED, HEALTH, INVULNERABILITY}

@export var display_name: String
@export var description: String
@export var cost: float
