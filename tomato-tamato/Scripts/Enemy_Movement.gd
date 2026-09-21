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
@export var damage_multiplier : float = 2.0

@export_category("Timer")
@onready var damage_cooldown = $DamageCoolDown
var can_damage : bool = true

func _ready():
	damage_cooldown.timeout.connect(on_damage_cooldown_timeout)
	
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
			
		if collider.is_in_group("Player") and can_damage:
			can_damage = false
			damage_cooldown.start()
	
			enemy_stats.attack *= damage_multiplier
			collider.player_stats.damage_health(enemy_stats.attack)
			print("[PLAYER HEALTH]: ", collider.player_stats.health)
			
		elif collider.is_in_group("Platform"):
			print("Coolided with platform!")
			face_other_way()
	
func face_other_way():
	direction = -direction
	floor_check.position.x *= -1
	
func on_damage_cooldown_timeout():
	can_damage = true
	
func on_death():
	if enemy_stats.health <= 0:
		queue_free()
