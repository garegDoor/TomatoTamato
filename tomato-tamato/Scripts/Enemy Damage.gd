extends Area2D
class_name enemy_damage

@export_category("Player info")
@export var player_stats : PlayerStats
@export var damage : int = 10

@export var enemy_stats : EnemyStats
@export var damaged : float = 10.0

#Trigger Collider
func _on_body_entered(body: Area2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered trigger area")
		
		# Damage player health
		player_stats.health -= damage
		print("[PLAYER HEALTH]: ", player_stats.health)
		
	if body.is_in_group("Tomato"):
		print("Projectile entered trigger area")
		enemy_stats.health -= damaged
		print("[ENEMY HEALTH]: ", enemy_stats.health)
		
