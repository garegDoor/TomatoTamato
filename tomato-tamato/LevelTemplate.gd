extends Node2D

@export var levelLength: float = 500
@export var potentialObstacles: Array[PackedScene] = []
@export var obstacleLocations: Array[Node2D] = []

## reference to player
var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = null
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		printerr("LevelTemplate: no player detected!")
	elif (player.global_position.x < (global_position.x - (3 * levelLength))) or (player.global_position.x > (global_position.x + (3 * levelLength))):
		# The player has gotten far enough away from this template so delete
		deleteTemplate()

func genObstacles() -> void:
	print("A template was told to generate its obstacles!")
	for obstacleLoc in obstacleLocations:
		var obstacle = potentialObstacles.pick_random()
		if obstacle == null: printerr("Level Template: Null obstacle generated!")
		var obstacleInstance = obstacle.instantiate()
		if obstacleInstance == null: printerr("Level Template: obstacle gen instantiate failed!")
		add_child(obstacleInstance)
		
		obstacleInstance.global_position = Vector2(obstacleLoc.global_position.x, obstacleLoc.global_position.y)
		
		
		print("An Obstacle was generated!")

func deleteTemplate() -> void:
	print("A Level Template was deleted!")
	queue_free()
