extends ColorRect

onready var animation_player = $AnimationPlayer
onready var word_animation_player = $WordAnimationPlayer
signal fade_finished

func _ready():
	pass

func fade_in():
	animation_player.play("fade_in")

func fade_out():
	animation_player.play("fade_out")

func word_fade():
	word_animation_player.play("word_fade_in")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")

func set_playback_speed(speed):
	animation_player.playback_speed = speed;
	word_animation_player.playback_speed = speed;
