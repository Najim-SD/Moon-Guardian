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
	beginDestroy = true
	# stop the rigid body from moving
	if not (("ship" in body.name or "Laser" in body) and body.team == team):
		$AnimatedSprite.play("laserImpact")
		$AnimatedSprite.offset.y = -9
		if body.name == "Moonship":
			body.takeDamage(5)
	pass # Replace with function body.

