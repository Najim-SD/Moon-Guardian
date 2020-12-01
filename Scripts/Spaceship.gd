extends KinematicBody2D


var velocity = Vector2()
var direction = Vector2(1,0)
var accelration = 25
var power = 0.0
var friction = 0.03
export var maxSpeed = 500.0

export var health:float = 100
export var maxHealth:float = 100

var bulletSpeed = 800.0
export var fireRate = 60 * 0.15
var fireCounter = 0
var missilesAvailable = 2
var bulletScene = preload("res://Scenes/LaserShot.tscn")
var missileScene = preload("res://Scenes/Missile.tscn")
var HPCanScene = preload("res://Scenes/HPCan.tscn")
var RoCanScene = preload("res://Scenes/RoCan.tscn")
var cam = null
var locks = []

# AI stuff ---------------------------
export var isBot = false
var target
var chaseType = 1
var chaseMax = int(rand_range(60,60*4))
var chaseCounter = chaseMax

export var useJoyStick = true
export var controlDevice = 0
export var playerId = 0
export var playerName = "Player"
export var team = "player"

var hitSound = preload("res://Sounds/Hit.wav")
var laserSound = preload("res://Sounds/Laser_Shoot.wav")
var explosionSound = preload("res://Sounds/Explosion.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_parent().find_node("MultiCam")
	$UI/ProgressBar.min_value = 0
	$UI/ProgressBar.max_value = maxHealth
	$UI/ProgressBar.value = health
	$Missile1.ownerId = playerId
	$Missile1.team = team
	$Missile2.ownerId = playerId
	$Missile2.team = team
	pass # Replace with function body.

func _process(delta):
	$UI.global_rotation = 0
	$UI/ProgressBar.value = health
	$UI/Label.text = playerName + ": " + str(playerId+1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health <= 0: return
	# MOVEMENT -----------------------------------------
	if isBot:
		botMovement()
	else: 
		playerMovement()
	
	
	# SHOOTING ---------------------------------------
	if isBot:
		botShooting()
	else: 
		playerShooting()
	
	# Smoke Particles ----------------------------------------
	var cv:float = (health/maxHealth)
	$SmokeParticles.emitting = cv <= 0.25
	$SmokeParticles.process_material.direction = Vector3(direction.x, direction.y, 0).rotated(Vector3(0,0,1), deg2rad(180.0))
	$SmokeParticles.process_material.spread = int((velocity.x / maxSpeed) * 180) - 180
	
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
	

func playerMovement():
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
		if isJustPressed("move"):
			$JetFlame.play("flameStart")
			$JetFlame.speed_scale = 1
			$JetFlame.show()
	else:
		if isJustReleased("move"):
			$JetFlame.play("flameStart", true)
			$JetFlame.speed_scale = 2
		power = lerp(power, 0, friction)
		velocity = vecFriction(velocity)
	pass

func botMovement():
	var isMoving = false
	if chaseType == 0 or chaseType == 1:
		if chaseType == 1:
			isMoving = true
		chaseCounter -= 1
		if chaseCounter == 0:
			chaseCounter = chaseMax
			chaseType = randi() % 2
	elif chaseType == 2:
		isMoving = true
		
	
	if target != null:	
		var nd:Vector2 = (target.global_position - global_position).normalized()
		direction = vectorLerp(direction, nd, 0.1)
		rotation = direction.angle()
	
		if isMoving and getDist(global_position, target.global_position) >= 200:	
			power = min(accelration/2 + power, maxSpeed)
			velocity = vectorLerp(velocity, (direction * power), 0.1)
			if (chaseType == 1 and chaseCounter == chaseMax - 1) or (chaseType == 2 and not $JetFlame.visible):
				$JetFlame.play("flameStart")
				$JetFlame.speed_scale = 1
				$JetFlame.show()

func botShooting():
	fireCounter = max(fireCounter-1,0)
	if fireCounter == 0:
		fireCounter = fireRate
		fire()
	if missilesAvailable > 0:
		if missilesAvailable == 2 and health/maxHealth < 0.6:
			launchMissile()
		elif missilesAvailable == 1 and health/maxHealth < 0.2:
			launchMissile()
	pass

func playerShooting():
	fireCounter = max(fireCounter-1,0)
	if isPressed("fire") and fireCounter == 0:
		fireCounter = fireRate
		fire()
		
	if isJustPressed("launch") and missilesAvailable > 0:
		launchMissile()
	pass

func isPressed(key:String):
	if useJoyStick == false:
		if key == "move" and getDist(get_global_mouse_position(), position) < 70: return false
		if Input.is_action_pressed(key):
			return true
		else : return false
	if Input.is_action_pressed(key+String(controlDevice)):
		return true
	else: return false

func isJustPressed(key:String):
	if useJoyStick == false:
		if key == "move" and getDist(get_global_mouse_position(), position) < 70: return false
		if Input.is_action_just_pressed(key):
			return true
		else : return false
	if Input.is_action_just_pressed(key+String(controlDevice)):
		return true
	else: return false

func isJustReleased(key:String):
	if useJoyStick == false:
		if key == "move" and getDist(get_global_mouse_position(), position) < 70: return false
		if Input.is_action_just_released(key):
			return true
		else : return false
	if Input.is_action_just_released(key+String(controlDevice)):
		return true
	else: return false

func lockON(lock:bool):
	$UI/Lock.visible = lock
	pass

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

func launchMissile():
	if missilesAvailable <= 0: return
	var missileName = "Missile1"
	if missilesAvailable == 1 : missileName = "Missile2"
	var missile = find_node(missileName)
	missile.hide()
	missilesAvailable -= 1
	
	var missileInstance = missileScene.instance()
	missileInstance.position = missile.global_position
	missileInstance.rotation = rotation
	get_tree().root.call_deferred("add_child", missileInstance)
	missileInstance.ownerId = playerId
	missileInstance.team = team
	missileInstance.launch(direction)
	cam.shakeCam(7, Vector2(-3,3))
	pass


func _on_Area2D_body_entered(body):
	if "Laser" in body.name and body.team != team and body.ownerId != playerId and body.fadeCounter == body.maxFadeCount:
		takeDamage(5)
	pass # Replace with function body.
	


func takeDamage(dmg:int):
	if health <= 0: return
	health -= dmg
	cam.shakeCam(12, Vector2(-4,4))
	$AudioStreamPlayer2D.stream = hitSound
	$AudioStreamPlayer2D.volume_db = -20
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.60,1)
	$AudioStreamPlayer2D.play()
	checkDeath()
	pass

func checkDeath():
	if health <= 0:
		for t in cam.targets:
			if t == name:
				cam.targets.erase(t)
				break
		kill()
	pass


func kill():
	cam.shakeCam(60, Vector2(-10,10))
	var audio = get_parent().find_node("LevelAudioPlayer")
	audio.stream = explosionSound
	audio.volume_db = -20
	audio.pitch_scale = rand_range(0.60,1)
	audio.play()
	$AnimatedSprite.play("explosion")
	cam.playFX("WhiteScreenFX")
	$Missile1.visible = false
	$Missile2.visible = false
	$UI.visible = false
	$JetFlame.hide()
	pass


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "explosion":
		queue_free()
		cam.targets.erase(name)
		if name == "Spaceship": return
		if randf() < 0.6:
			var hp = HPCanScene.instance()
			hp.global_position = global_position
			get_parent().call_deferred("add_child", hp)
			pass
		if randf() < 0.3:
			var ro = RoCanScene.instance()
			ro.global_position = global_position
			get_parent().call_deferred("add_child", ro)
			pass
	pass # Replace with function body.


func _on_JetFlame_animation_finished():
	if $JetFlame.animation == "flameStart":
		$JetFlame.play("jetFlame")
		$JetFlame.speed_scale = 1
		if not isPressed("move"):
			$JetFlame.hide()
	pass # Replace with function body.
