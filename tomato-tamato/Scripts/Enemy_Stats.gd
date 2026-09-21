class_name EnemyStats
extends Resource

@export var health : int = 100
@export var armor : int = 10
@export var attack : int = 10

func damage_health(damage : int):
	health -= damage
