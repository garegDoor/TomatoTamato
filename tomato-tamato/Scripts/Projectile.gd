extends CharacterBody2D
class_name Projectile


@export var SPEED : int = 100
var dir : float 
var spawnPos : Vector2
var direction : Vector2 = Vector2.RIGHT
var spawnRot : float
@export var gravity := 1200.0

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(delta: float) -> void:
	#velocity = Vector2(0, -SPEED).rotated(dir)
	#velocity.y += gravity * delta
	velocity += get_gravity() * delta
	move_and_slide()
