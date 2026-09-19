extends Node2D

@export var levelLength: float = 500

## reference to player
@export var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = null
	player = get_tree().get_first_node_in_group("player")
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		printerr("LevelTemplate: no player detected!")
	elif (player.global_position.x < (global_position.x - (3 * levelLength))) or (player.global_position.x > (global_position.x + (3 * levelLength))):
		# The player has gotten far enough away from this template so delete
		print("A Level Template was deleted!")
		deleteTemplate()

func deleteTemplate() -> void:
	queue_free()
