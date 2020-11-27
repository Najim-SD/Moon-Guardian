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

var health = 100

var bulletSpeed = 800.0
export var fireRate = 60 * 0.20
var fireCounter = 0
var bulletScene = preload("res://Scenes/LaserShot.tscn")

export var useJoyStick = true
export var controlDevice = 0
export var playerId = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	$UI.global_rotation = 0
	$UI/Label.text = "Player: " + str(playerId+1) + "\nHealth : " + str(health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# MOVEMENT -----------------------------------------
	if useJoyStick == false:
		direction = (get_global_mouse_position() - global_position).normalized()
		look_at(get_global_mouse_position())
	else:
		var nd:Vector2 = Vector2(Input.get_joy_axis(controlDevice, 0), Input.get_joy_axis(controlDevice, 1))
		nd = nd.normalized()
		if(nd.length() > 0.3):
			direction = vectorLerp(direction, nd, 0.1)
			rotation = direction.angle()
	
	if isPressed("move"):
		power = min(accelration/2 + power, maxSpeed)
		velocity = vectorLerp(velocity, (direction * power), 0.1)
		get_node("JetFlame").show()
	else:
		get_node("JetFlame").hide()
		power = lerp(power, 0, friction)
		velocity = vecFriction(velocity)
	
	# LASER SHOOTING ---------------------------------------
	fireCounter = max(fireCounter-1,0)
	
	if isPressed("fire") and fireCounter == 0:
		fireCounter = fireRate
		fire()
		
	
	velocity = move_and_slide(velocity, Vector2.UP)
	pass # Physics_Process

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


func fire():
	var bulletInstance = bulletScene.instance()
	bulletInstance.position = Vector2($bulletSpawnPos.global_position.x, $bulletSpawnPos.global_position.y)
	bulletInstance.rotation = rotation
	bulletInstance.apply_impulse(Vector2(), Vector2(bulletSpeed, 0).rotated(rotation))
	get_tree().root.call_deferred("add_child", bulletInstance)







