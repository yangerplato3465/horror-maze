extends Control


func _ready():
	$AnimationPlayer.play("logo_fade_in");



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "logo_fade_in":
		$Timer.start()


func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
