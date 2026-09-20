extends CharacterBody2D
class_name enemy_movement

@export_category("Movement")
const SPEED = 75.0
var direction : int = 1
@onready var floor_check : RayCast2D = $FloorCheck

@export_category("Timer")
@onready var shoot_cooldown = $ShootCoolDown

func _ready():
	pass

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Movement input
	if is_on_wall() and (is_on_floor() and not floor_check.is_colliding()):
		direction = -direction
		#direction *= -1
		floor_check.position.x *= -1
		
	velocity.x = SPEED * direction
	move_and_slide()
