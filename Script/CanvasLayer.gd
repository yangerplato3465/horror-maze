extends CanvasLayer


func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_select"):
		get_tree().paused = !get_tree().paused
		$Label.visible = !$Label.visible
