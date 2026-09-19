extends Area2D
class_name death_block

@export_category("Player info")
@export var player_health : character_movement
@export var damage : int = 10

@export_category("Teleport points")
@export var teleport_point : Area2D
@export var spawn_point : Marker2D

#Trigger Collider
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered trigger area")
		
		# Damage player health
		player_health._decrease_health(damage)
	
		# Spawn player after
		if teleport_point:
			body.global_position = teleport_point.global_position
		else:
			print("[DEATH BLOCK]: No teleport point exist")
