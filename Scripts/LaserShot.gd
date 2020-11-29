extends RigidBody2D

var team = "player"
var ownerId = 0
var maxFadeCount = 10.0
var fadeCounter = maxFadeCount
var beginDestroy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if beginDestroy:
		fadeCounter -= 1
	$AnimatedSprite.modulate.a = fadeCounter/maxFadeCount
	if fadeCounter <= 0:
		queue_free()
	pass


func _on_LaserShot_body_entered(body):
	print("Laser entered " + body.name)
	beginDestroy = true
	# stop the rigid body from moving
	$AnimatedSprite.play("laserImpact")
	$AnimatedSprite.offset.y = -9
	pass # Replace with function body.

