extends KinematicBody2D


var velocity = Vector2()
var direction = Vector2(1,0)
var accelration = 25
var power = 0.0
var friction = 0.03
export var maxSpeed = 500.0

var health = 100

var bulletSpeed = 800.0
export var fireRate = 60 * 0.10
var fireCounter = 0
var bulletScene = preload("res://Scenes/LaserShot.tscn")
var cam = null

export var useJoyStick = true
export var controlDevice = 0
export var playerId = 0
export var playerName = "Player"
export var team = "Player Team"

var hitSound = preload("res://Sounds/Hit.wav")
var laserSound = preload("res://Sounds/Laser_Shoot.wav")
var explosionSound = preload("res://Sounds/Explosion.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_parent().find_node("MultiCam")
	pass # Replace with function body.

func _process(delta):
	$UI.modulate.a = health/100.0
	$UI.global_rotation = 0
	$UI/Label.text = playerName + ": " + str(playerId+1) + "\nHealth : " + str(health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# MOVEMENT -----------------------------------------
	if useJoyStick == false:
		var nd:Vector2 = (get_global_mouse_position() - global_position).normalized()
		direction = vectorLerp(direction, nd, 0.1)
		rotation = direction.angle()
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
	pass # Physics_Process()

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
	bulletInstance.ownerId = playerId
	bulletInstance.team = team
	cam.shakeCam(5, Vector2(-2,2))
	$AudioStreamPlayer2D.stream = laserSound
	$AudioStreamPlayer2D.volume_db = -20
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.60,1)
	$AudioStreamPlayer2D.play()


func _on_Area2D_body_entered(body):
	print("Ship entered " + body.name)
	if "Laser" in body.name and body.team != team and body.ownerId != playerId and body.fadeCounter == body.maxFadeCount:
		takeDamage(5)
	pass # Replace with function body.
	

func checkDeath():
	if health <= 0:
		for t in cam.targets:
			if t == name:
				cam.targets.erase(t)
				break
		kill()
	pass
	

func takeDamage(dmg:int):
	health -= dmg
	cam.shaking = 12
	cam.shakingRange = Vector2(-4,4)
	$AudioStreamPlayer2D.stream = hitSound
	$AudioStreamPlayer2D.volume_db = -20
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.60,1)
	$AudioStreamPlayer2D.play()
	checkDeath()
	pass

func kill():
	cam.shakeCam(60, Vector2(-10,10))
	var audio = get_parent().find_node("LevelAudioPlayer")
	audio.stream = explosionSound
	audio.volume_db = -20
	audio.pitch_scale = rand_range(0.60,1)
	audio.play()
	queue_free()
	pass
