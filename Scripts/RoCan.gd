extends Area2D

func _ready():
	pass

func _on_RoCan_body_entered(body):
	if body.name == "Spaceship":
		body.missilesAvailable = 2
		body.find_node("Missile1").visible = true
		body.find_node("Missile2").visible = true
		queue_free()
	pass # Replace with function body.
