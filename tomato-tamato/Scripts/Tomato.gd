extends Area2D
class_name tomato

@export var count : int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered trigger area")
		
		# Damage player health
		body.player_stats.add_tomato_count(count)
		print("[TOMATO]: ", body.player_stats.tomato)
	
		# Damage item
		queue_free()
