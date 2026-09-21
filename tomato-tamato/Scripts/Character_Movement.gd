extends CharacterBody2D
class_name character_movement

@export_category("Movement")
const SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
@export var JUMP_MULTIPLIER = 0.2
@onready var texture_rect : TextureRect = $TextureRect

@export_category("Projectile")
@onready var main = get_tree().get_root().get_node("Platform")
@onready var projectile = load("res://Scenes/Projectile.tscn")

const MIN_POWER := 300.0
const MAX_POWER := 1200.0
const MAX_CHARGE := 1.5

const CHARGE_SPEED := 800.0
var charging := false
var charging_time := 0.0

@export_category("Spawning Points")
@export var right_muzzle: Marker2D
@export var left_muzzle: Marker2D

var facing_direction : float = 1.0

@export_category("Player Stats")
@export var player_stats : PlayerStats

@export_category("Timer")
@onready var shoot_cooldown = $ShootCoolDown
var can_shoot : bool = true

func _ready():
	shoot_cooldown.timeout.connect(on_shoot_cooldown_timeout)
	
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
		aim(delta)
		
	if Input.is_action_just_released("Shoot") and can_shoot:
		charging = false
		shoot()
		
	# Movement input
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x = direction * SPEED
		facing_direction = sign(direction)
		texture_rect.scale.x = facing_direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
			
		if collision.get_collider().is_in_group("Enemy"):
			print("Collided with enemy via movement!")
	
func aim(delta : float) -> void:
	charging_time += delta
	charging_time = min(charging_time, MAX_CHARGE)
	
func shoot():
	if projectile == null or not can_shoot:
		return
		
	#can_shoot = false
	#shoot_cooldown.start()
	
	var charging_percent = charging_time / MAX_CHARGE
	var shoot_power = lerp(MIN_POWER, MAX_POWER, charging_percent)
	
	var instance = projectile.instantiate()
	#instance.direction = Vector2(facing_direction, 0.0)
	main.add_child.call_deferred(instance)
	instance.spawnPos = right_muzzle.global_position

	instance.velocity = Vector2(shoot_power * facing_direction, shoot_power * -1.5)
	
	charging_time = 0.0
	
	player_stats.remove_tomato_count(1)
	
func on_shoot_cooldown_timeout():
	can_shoot = true
	
func on_death():
	#print("health: ", player_stats.health)
	if player_stats.health <= 0:
		queue_free()
