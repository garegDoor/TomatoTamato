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

@export_category("Knock-back")
@export var speed : float = 200.0
@export var knockback_res : float = 800.0
var knockback : Vector2 = Vector2.ZERO

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
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
			
		if collider.is_in_group("Player") and can_damage:
			can_damage = false
			damage_cooldown.start()
	
			enemy_stats.attack *= damage_multiplier
			collider.player_stats.damage_health(enemy_stats.attack)
			print("[PLAYER HEALTH]: ", collider.player_stats.health)
			knockback = knockback.move_toward(Vector2.ZERO, knockback_res * delta)
			apply_knockback(collider.global_position, 1000.0)
			
		if collider.is_in_group("Platform"):
			var normal := collision.get_normal()
			if abs(normal.x) > 0.5:
				face_other_way()
	
func face_other_way():
	direction = -direction
	floor_check.position.x *= -1
	
func on_damage_cooldown_timeout():
	can_damage = true

func apply_knockback(enemy_global_position : Vector2, force : float) -> void:
	print("knockback")
	var directions = (global_position - enemy_global_position).normalized()
	knockback = directions * force
	
func on_death():
	if enemy_stats.health <= 0:
		queue_free()
