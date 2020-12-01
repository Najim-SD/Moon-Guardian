extends Control


func _ready():
	pass


func _on_startButton_button_up():
	get_tree().quit(0)
	pass # Replace with function body.


func _on_exit_button_up():
	get_tree().quit(0)
	pass # Replace with function body.


func _on_1v1_button_up():
	get_tree().change_scene("res://Scenes/1V1 Level.tscn")
	pass # Replace with function body.


func _on_start_button_up():
	get_tree().change_scene("res://Scenes/Game.tscn")
	pass # Replace with function body.
