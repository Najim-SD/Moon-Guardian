extends Area2D

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.name == "Spaceship":
		body.health += int(rand_range(30, 60))
		body.get_parent().find_node("Moonship").health += int(rand_range(30, 60)) * 3
		queue_free()
	pass # Replace with function body.
