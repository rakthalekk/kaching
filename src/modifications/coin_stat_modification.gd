class_name CoinStatModification
extends CoinModification

enum MODIFY_STAT {DAMAGE, SPEED, KNOCKBACK, DURATION, COOLDOWN, RELOAD_RATE, CONSERVE_CHANCE}

@export var modify_stat: MODIFY_STAT
@export var amount: float
