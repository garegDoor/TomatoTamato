class_name PlayerStats
extends Resource

@export var health : float = 100.0
@export var armor : float = 10.0
@export var attack : float = 10.0

@export var tomato : int = 0

func damage_health(damage : float):
	health -= damage
	
func increase_armor(boost : float):
	armor += boost
	
func add_tomato_count(count : int):
	tomato += count
	
func remove_tomato_count(count : int):
	tomato -= count

# Add more variables and functions if needed
