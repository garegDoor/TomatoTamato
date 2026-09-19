extends Area2D
class_name death_block

@export_category("Player info")
@export var player_stats : PlayerStats
@export var damage : int = 10

@export_category("Teleport points")
@export var teleport_point : Area2D

#Trigger Collider
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered trigger area")
		
		# Damage player health
		player_stats.health -= damage
		print("[HEALTH]: ", player_stats.health)
	
		# Spawn player after
		if teleport_point:
			body.global_position = teleport_point.global_position
		else:
			print("[DEATH BLOCK]: No teleport point exist")
