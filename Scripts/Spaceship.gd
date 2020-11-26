extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2()
var direction = Vector2()
var accelration = 25
var power = 0.0
var friction = 0.03
var maxSpeed = 500.0

export var useJoyStick = true
export var controlDevice = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	$UI.global_rotation = 0
	$UI/Label.text = "Position: " + str(position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if useJoyStick == false:
		direction = (get_global_mouse_position() - global_position).normalized()
		look_at(get_global_mouse_position())
	else:
		var nd = Vector2(Input.get_joy_axis(controlDevice, 0), Input.get_joy_axis(controlDevice, 1))
		if(nd.length() > 0.3):
			direction = vectorLerp(direction, nd, 0.2)
			rotation = direction.angle()
	
	if isPressed("move"):
		power = min(accelration/2 + power, maxSpeed)
		velocity = vectorLerp(velocity, (direction * power), 0.1)
		get_node("JetFlame").show()
	else:
		get_node("JetFlame").hide()
		power = lerp(power, 0, friction)
		velocity = vecFriction(velocity)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func getDist(pos1:Vector2, pos2:Vector2):
	return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)
	

func vecFriction(vec:Vector2):
	vec.x = lerp(vec.x, 0, friction)
	vec.y = lerp(vec.y, 0, friction)
	return vec

func vectorLerp(vec:Vector2, to:Vector2, f:float):
	vec.x = lerp(vec.x, to.x, f)
	vec.y = lerp(vec.y, to.y, f)
	return vec
	

func isPressed(key:String):
	if useJoyStick == false:
		if key == "move" and getDist(get_global_mouse_position(), position) < 70: return false
		if Input.is_action_pressed(key):
			return true
		else : return false
	if Input.is_action_pressed(key+String(controlDevice)):
		return true
	else: return false






