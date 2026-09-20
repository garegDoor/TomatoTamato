extends Area2D
class_name enemy_damage

@export_category("Player info")
@export var player_stats : PlayerStats
@export var damage : int = 10

#Trigger Collider
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered trigger area")
		
		# Damage player health
		player_stats.health -= damage
