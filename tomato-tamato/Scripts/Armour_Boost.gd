extends Area2D
class_name armour_boost

@export var player_stats : PlayerStats
@export var boost : int = 5

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered trigger area")
		
		# Damage player health
		player_stats.armor += boost
		print("[ARMOUR]: ", player_stats.armor)
	
		# Damage item
		queue_free()
