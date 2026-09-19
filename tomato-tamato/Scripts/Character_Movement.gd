extends CharacterBody2D
class_name character_movement

@export_category("Movement")
const SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
@export var JUMP_MULTIPLIER = 0.3

@export_category("Stats")
@export var HEALTH = 100
@export var ARMOR = 10
@export var ATTACK = 10

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Jump input 
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Jump height
	if Input.is_action_just_released("Jump") and velocity.y < 0.0:
		velocity.y *= JUMP_MULTIPLIER
		
	# Movement input
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	
func _decrease_health(damage : int) -> void:
	HEALTH -= damage
	print("[HEALTH]: ", HEALTH)
