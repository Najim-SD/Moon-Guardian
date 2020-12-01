extends Control

var fade = 60 * 3

func _ready():
	$BlackScreen.show()
	pass

func _process(delta):
	fade -= 1
	$BlackScreen.modulate.a = fade/(60.0*3)
	if fade <= 0:
		get_tree().change_scene("res://Scenes/Level.tscn")
	pass
