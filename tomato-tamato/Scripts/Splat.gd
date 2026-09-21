extends Area2D
class_name splat

@export_category("Enemy info")
@export var damage : float = 10.0

@export_category("Tomato Status")
# add sprites here

#Trigger Collider
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("Enemy entered trigger area")
		#enemy damage logic
		body.enemy_stats.damage_health(damage)
		print("[ENEMY HEALTH]: ", body.enemy_stats.health)
		queue_free()
		
	if body.is_in_group("Platform"):
		print("Projectile touched platform")
		queue_free()
