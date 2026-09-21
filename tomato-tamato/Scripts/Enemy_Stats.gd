class_name EnemyStats
extends Resource

@export var health : float = 100.0
@export var armor : float = 10.0
@export var attack : float = 10.0

func damage_health(damage : float):
	health -= damage
