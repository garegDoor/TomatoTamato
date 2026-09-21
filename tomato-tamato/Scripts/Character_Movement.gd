extends CharacterBody2D
class_name character_movement

@export_category("Movement")
const SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
@export var JUMP_MULTIPLIER = 0.2

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var original_collider_x : float
var facing_direction : float = 1.0


@export_category("Projectile")
@onready var main = get_tree().get_root().get_node("Platform")
@onready var projectile = load("res://Scenes/Projectile.tscn")

const MIN_POWER := 300.0
const MAX_POWER := 1200.0
const MAX_CHARGE := 2.0

const CHARGE_SPEED := 800.0
var charging := false
var charging_time := 0.0
var aim_angle := 45.0

@export_category("Spawning Points")
@export var right_muzzle: Marker2D

@export_category("Player Stats")
@export var player_stats : PlayerStats

@export_category("Timer")
@onready var damage_cooldown = $ShootCoolDown
var can_shoot : bool = true
var can_damage : bool = true

@export_category("Knock-back")
@export var speed : float = 200.0
@export var knockback_res : float = 800.0
var knockback : Vector2 = Vector2.ZERO

func _ready():
	#shoot_cooldown.timeout.connect(on_shoot_cooldown_timeout)
	damage_cooldown.timeout.connect(on_damage_cooldown_timeout)
	original_collider_x = abs(collision_shape.position.x)
	
	if original_collider_x == null:
		print("No collision or texture")
		return
	
func _process(delta : float) -> void:
		on_death()

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if player_stats.tomato == 0:
		#print("No tomatoes...")
		can_shoot = false
	else:
		#print("got some tomatoes")
		can_shoot = true
	
	# Jump input 
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Jump height
	if Input.is_action_just_released("Jump") and velocity.y < 0.0:
		velocity.y *= JUMP_MULTIPLIER
		
	# Shooting tomatoes
	if Input.is_action_just_pressed("Shoot") and can_shoot:
		charging_time = 0.0
		charging = true
		print("tomato: ", player_stats.tomato)
		
	if Input.is_action_pressed("Shoot") and can_shoot and charging:
		charging = true
		aim(delta)
		
	if Input.is_action_just_released("Shoot") and can_shoot:
		shoot()
		charging = false
		charging_time = 0.0
		
	# Movement input
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x = direction * SPEED
		facing_direction = sign(direction)
		collision_shape.scale.x = facing_direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
			
		if collision.get_collider().is_in_group("Enemy") and can_damage:
			print("Collided with enemy via movement!")
			can_damage = false
			damage_cooldown.start()
	
			collider.enemy_stats.attack *= collider.damage_multiplier
			player_stats.damage_health(collider.enemy_stats.attack)
			print("[PLAYER'S HEALTH]: ", player_stats.health)
			knockback = knockback.move_toward(Vector2.ZERO, knockback_res * delta)
			apply_knockback(collider, 10.0)
	
func aim(delta : float) -> void:
	charging_time += delta
	charging_time = min(charging_time, MAX_CHARGE)
	
func shoot():
	if projectile == null or not can_shoot:
		return
	
	var charging_percent = charging_time / MAX_CHARGE
	var shoot_power = lerp(MIN_POWER, MAX_POWER, charging_percent)
	
	var instance = projectile.instantiate()
	main.add_child.call_deferred(instance)
	instance.spawnPos = right_muzzle.global_position

	instance.velocity = Vector2(shoot_power * facing_direction, shoot_power * -1.0)
	
	player_stats.remove_tomato_count(1)
	
func on_damage_cooldown_timeout():
	can_damage = true
	
func apply_knockback(enemy_global_position : Vector2, force : float) -> void:
	print("knockback")
	var direction = (global_position - enemy_global_position).normalized()
	knockback = direction * force
	
func on_death():
	if player_stats.health <= 0:
		queue_free()
