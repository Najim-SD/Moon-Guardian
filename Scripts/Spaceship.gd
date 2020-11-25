extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2()
var direction = Vector2()
var speed = 500.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	direction = (get_global_mouse_position() - global_position).normalized()
	
	velocity = direction * speed
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("move"):
		velocity = move_and_slide(velocity, Vector2.UP)
		get_node("JetFlame").show()
	else:
		get_node("JetFlame").hide()
	pass	#_Physics Process
