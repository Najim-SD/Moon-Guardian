extends RigidBody2D


var ownerId = 0
var alive = 30
var beginDestroy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if beginDestroy: alive -= 1
	$Sprite.modulate.a = alive/30.0
	if alive <= 0:
		queue_free()
	pass


func _on_LaserShot_body_entered(body):
	beginDestroy = true
	pass # Replace with function body.

