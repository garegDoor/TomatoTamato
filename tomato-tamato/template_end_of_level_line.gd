@tool
extends Node2D

@export var levelTemplate: Node2D

@export var line_length: float = 100.0:
		set(value):
			line_length = value
			queue_redraw()

@export var line_color: Color = Color.RED:
		set(value):
			line_color = value
			queue_redraw()

var pos: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		#print(levelTemplate.levelLength)
		if levelTemplate.levelLength != pos:
			pos = levelTemplate.levelLength
			queue_redraw()
			print("updated line pos to be ", pos)

func _draw() -> void:
	var startPoint = Vector2(pos, 0)
	var endPoint = Vector2(pos, line_length)
	
	draw_line(startPoint, endPoint, line_color, 2.0)
