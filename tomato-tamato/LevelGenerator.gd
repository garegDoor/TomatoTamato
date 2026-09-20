extends Node2D


@export var playerCharacter: Node2D
@export var templates: Array[PackedScene] = []

## used to determine how close to the next template location the player needs to be before it generates it (e.g. margin = 10 means the player must be within 10 units of the next location to generate it)
@export var margin: float = 10.0 

var nextTemplateLocation: float
var currentPlayerLocation: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nextTemplateLocation = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentPlayerLocation = playerCharacter.position.x
	
	if currentPlayerLocation >= (nextTemplateLocation - margin):
		generateNextTemplate()

func generateNextTemplate() -> void:
	var template = null
	template = pickTemplate()
	if template == null:
		printerr("Level Generator: Failed to pick a template!")
		return
	
	var templateInstance = template.instantiate() # allocate memory
	add_child(templateInstance) # add it to the hierarchy
	templateInstance.global_position = Vector2(nextTemplateLocation, 0) # adjust position of new template
	templateInstance.player = playerCharacter # give the template a reference to the player (for use with garbage collection)
	
	genObstacles(templateInstance) # tell template to generate its obstacles
	
	nextTemplateLocation += templateInstance.levelLength # update nextTemplateLocation

func pickTemplate() -> PackedScene:
	var randTemplate = templates.pick_random()
	
	return randTemplate

func genObstacles(template: Node2D) -> void:
	template.genObstacles()
