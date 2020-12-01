extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fadeMax:float = 60*2
var fadeCounter:float = fadeMax

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fadeCounter = max(fadeCounter -1, 0)
	$CanvasLayer/Label.modulate.a = fadeCounter/fadeMax
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	#$LevelBoundary.position = $MultiCam.position
	pass
