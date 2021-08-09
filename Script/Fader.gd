extends ColorRect

onready var animation_player = $AnimationPlayer

signal fade_finished

func _ready():
	pass

func fade_in():
	animation_player.play("fade_in")

func fade_out():
	animation_player.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")

func set_playback_speed(speed):
	animation_player.playback_speed = speed;
