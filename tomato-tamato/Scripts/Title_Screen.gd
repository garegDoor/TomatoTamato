extends Control

# Followed tutorial by Master Albert on youtube
# Godot Main Menu in 4 minutes
# https://www.youtube.com/watch?v=Mx3iyz8AUAE

@export var StartButton : TextureButton
@export var BackButton : TextureButton
@export var CreditsMenu : Control
@export var TitleScreen : Control

func _ready() -> void:
	StartButton.grab_focus()

# Start game
func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Platform.tscn")

# Settings 
func _on_credits_button_pressed():
	CreditsMenu.visible = true
	TitleScreen.visible = false
	BackButton.grab_focus()

# Back/Return
func back_to_title():
	CreditsMenu.visible = false
	TitleScreen.visible = true
	StartButton.grab_focus()
	
# Quit
func _on_quit_button_pressed():
	get_tree().quit()
