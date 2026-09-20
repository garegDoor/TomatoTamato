extends Area2D
class_name splat

@export_category("Player info")
@export var enemy_stats : EnemyStats
@export var damage : int = 10

@export_category("Tomato Status")
# add sprites here

#Trigger Collider
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("Enemy entered trigger area")
		#enemy damage logic
		enemy_stats.health -= damage
		
	if body.is_in_group("Platform"):
		print("Projectile touched platform")
		queue_free()
