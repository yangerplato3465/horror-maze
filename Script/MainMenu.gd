extends Spatial

onready var start = $CanvasLayer/Fader/Control/VBoxContainer/CenterContainer/VBoxContainer/Start
onready var quit = $CanvasLayer/Fader/Control/VBoxContainer/CenterContainer/VBoxContainer/Quit
onready var fader = $CanvasLayer/Fader
onready var animation_player = $AnimationPlayer

export (PackedScene) var game_scene = null

func _ready():
	pass 


func _on_Start_pressed():
	fader.fade_in()
	animation_player.play("fade_out")

func _on_Quit_pressed():
	pass

func _on_Fader_fade_finished():
	get_tree().change_scene_to(game_scene)
