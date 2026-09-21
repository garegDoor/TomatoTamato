class_name PlayerStats
extends Resource

@export var health : int = 100
@export var armor : int = 10
@export var attack : int = 10

@export var tomato : int = 0

func damage_health(damage : int):
	health -= damage
	
func increase_armor(boost : int):
	armor += boost
	
func add_tomato_count(count : int):
	tomato += count
	
func remove_tomato_count(count : int):
	tomato -= count

# Add more variables and functions if needed
