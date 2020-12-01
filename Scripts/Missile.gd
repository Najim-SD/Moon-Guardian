extends Area2D

var ownerId = 0
var team = "t"
var launched = false

var velocity = Vector2.ONE
var direction = Vector2(1,1)
var power = 0.0
var accelration = 0.08

var target
var lockedON = false
var exploding = false
var soundCounter = 0
var soundDur = 60

var frameCounter = 0

func _ready():
	pass

func _physics_process(delta):
	if exploding or not launched: return
	if launched:
		frameCounter += 1
		if frameCounter > 60 * 15: queue_free()
		$SmokeParticles.process_material.direction = Vector3(direction.x, direction.y, 0).rotated(Vector3(0,0,1), deg2rad(180.0))
		$SmokeParticles.process_material.spread = int((velocity.x / 1000.0) * 180) - 180
		if lockedON:
			soundCounter -= 1
			var prox:float = abs(global_position.x - target.global_position.x) / 1280.0
			soundDur = int(prox * 60)
			if soundCounter <= 0:
				soundCounter = soundDur
				$AudioStreamPlayer2D.play()
				$AudioStreamPlayer2D.pitch_scale = 1.0 + prox
			target.lockON(true)
			var nd:Vector2 = (target.global_position - global_position).normalized()
			direction = vectorLerp(direction, nd, 0.1)
			rotation = direction.angle()
		
		power = min(accelration + power, 5000.0)
		velocity = vectorLerp(velocity, (direction * power), 0.1)
		position += velocity
	pass


func vectorLerp(vec:Vector2, to:Vector2, f:float):
	vec.x = lerp(vec.x, to.x, f)
	vec.y = lerp(vec.y, to.y, f)
	return vec

func launch(dir:Vector2):
	direction = dir
	launched = true
	$AnimatedSprite.play("launched")
	$SmokeParticles.visible = true
	$detectionArea.monitoring = true
	monitoring = true

func _on_Missile_body_entered(body):
	if launched and not exploding:
		if "ship" in body.name and body.team != team:
			explode()
#	elif "Laser" in body.name:
#		get_parent().takeDamage(5)
#		print("Damage from Missile")
	pass

func explode():
	$SmokeParticles.visible = false
	$AnimatedSprite.play("explosion")
	$AnimatedSprite.offset.y = -10
	exploding = true
	if target != null:
		target.lockON(false)
		target.takeDamage(40)
		target.cam.shakeCam(20, Vector2(-8,8))
		target.cam.playFX("WhiteScreenFX")
	pass

func _on_detectionArea_body_entered(body):
	if not launched or exploding: return
	if "ship" in body.name:
		if body.team != team and not lockedON:
			lockedON = true
			$AnimatedSprite.play("launched")
			target = body
			body.lockON(true)
	pass # Replace with function body.


func _on_detectionArea_body_exited(body):
	if not launched or exploding: return
	if "ship" in body.name:
		if body.team != team and lockedON and target.name == body.name:
			lockedON = false
			$AnimatedSprite.play("normal")
			#target = null
			body.lockON(false)
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "explosion":
		queue_free()
	pass # Replace with function body.
