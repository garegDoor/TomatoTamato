extends CharacterBody2D
class_name enemy_movement

@export_category("Movement")
const SPEED = 75.0
var direction : int = 1
@onready var floor_check : RayCast2D = $FloorCheck

@export_category("Timer")
@onready var shoot_cooldown = $ShootCoolDown

@export_category("Enemy Stats")
@export var enemy_stats : EnemyStats
@export var damage_multiplier : float = 1

func _ready():
	pass
	
func _process(delta : float) -> void:
	on_death()

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if floor_check == null:
		print("No floor check")
		return
		
	# Movement input
	if is_on_floor() and not floor_check.is_colliding():
		face_other_way()
		
	velocity.x = SPEED * direction
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
			
		if collider.is_in_group("Player"):
			print("Collided with player!")
			enemy_stats.attack *= damage_multiplier
			collider.player_stats.damage_health(enemy_stats.attack)
			print("[PLAYER HEALTH]: ", collider.player_stats.health)
			
		elif collider.is_in_group("Platform"):
			face_other_way()
	
func face_other_way():
	direction = -direction
	floor_check.position.x *= -1
	
func on_death():
	if enemy_stats.health <= 0:
		queue_free()
